# Schema Examples from Production Projects

## Auth Tables (Better Auth Pattern)

Better Auth manages its own tables. The schema adapter creates these automatically:

```typescript
import { pgTable, uuid, text, timestamp, boolean } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull(),
  email: text("email").notNull().unique(),
  emailVerified: boolean("email_verified").default(false).notNull(),
  image: text("image"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at"),
});

export const sessions = pgTable("sessions", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  token: text("token").notNull().unique(),
  expiresAt: timestamp("expires_at").notNull(),
  ipAddress: text("ip_address"),
  userAgent: text("user_agent"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at"),
});
```

## Project/Resource Tables

```typescript
export const projects = pgTable("projects", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull(),
  slug: text("slug").notNull().unique(),
  description: text("description"),
  ownerId: uuid("owner_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  settings: jsonb("settings").$type<ProjectSettings>().default({}),
  isActive: boolean("is_active").default(true).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at"),
});

export type Project = typeof projects.$inferSelect;
export type NewProject = typeof projects.$inferInsert;
```

## JSONB Usage

```typescript
import { jsonb } from "drizzle-orm/pg-core";

// Type-safe JSONB with TypeScript interface
interface ProjectSettings {
  theme?: "light" | "dark";
  notifications?: boolean;
  webhookUrl?: string;
}

export const projects = pgTable("projects", {
  // ...
  settings: jsonb("settings").$type<ProjectSettings>().default({}),
  metadata: jsonb("metadata").$type<Record<string, unknown>>(),
});
```

## Relations

```typescript
import { relations } from "drizzle-orm";

export const usersRelations = relations(users, ({ many }) => ({
  projects: many(projects),
  sessions: many(sessions),
}));

export const projectsRelations = relations(projects, ({ one, many }) => ({
  owner: one(users, {
    fields: [projects.ownerId],
    references: [users.id],
  }),
  tasks: many(tasks),
}));
```

## Index Patterns

```typescript
import { pgTable, uuid, text, index } from "drizzle-orm/pg-core";

export const tasks = pgTable("tasks", {
  id: uuid("id").primaryKey().defaultRandom(),
  projectId: uuid("project_id").notNull().references(() => projects.id, { onDelete: "cascade" }),
  assigneeId: uuid("assignee_id").references(() => users.id, { onDelete: "set null" }),
  status: text("status").notNull().default("pending"),
  // ...
}, (table) => [
  index("tasks_project_id_idx").on(table.projectId),
  index("tasks_assignee_id_idx").on(table.assigneeId),
  index("tasks_status_idx").on(table.status),
]);
```

## Cascade Delete Patterns

- **User deletes account** → cascade delete sessions, projects, team memberships
- **Project deleted** → cascade delete tasks, settings, invitations
- **Team member removed** → set null on assigned tasks (don't delete tasks)

```typescript
// Cascade: delete child when parent is deleted
userId: uuid("user_id").references(() => users.id, { onDelete: "cascade" })

// Set null: keep record but remove reference
assigneeId: uuid("assignee_id").references(() => users.id, { onDelete: "set null" })

// Restrict: prevent parent deletion if children exist
categoryId: uuid("category_id").references(() => categories.id, { onDelete: "restrict" })
```
