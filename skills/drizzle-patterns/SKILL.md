---
name: Drizzle Patterns
description: This skill should be used when the user asks to "create schema", "add table", "database migration", "drizzle query", "add column", "schema relations", or when working with Drizzle ORM in Next.js/PostgreSQL projects.
---

# Drizzle ORM Patterns

Patterns for Drizzle ORM with PostgreSQL in Next.js projects. Based on conventions from production projects using Drizzle 0.45+ with PostgreSQL 16-17.

## Schema File Organization

- Schema files live in `src/db/schema/` with an `index.ts` barrel export
- One file per domain: `users.ts`, `projects.ts`, `tasks.ts`
- Relations can be inline or in a separate `relations.ts`
- Export both table definitions and inferred TypeScript types

## Standard Table Template

```typescript
import { pgTable, uuid, text, timestamp, boolean } from "drizzle-orm/pg-core";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";

export const tableName = pgTable("table-name", {
  id: uuid("id").primaryKey().defaultRandom(),
  // columns...
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at"),
});

export type TableName = typeof tableName.$inferSelect;
export type NewTableName = typeof tableName.$inferInsert;
```

## Key Conventions

- UUID primary keys with `defaultRandom()` — never auto-increment
- Timestamps: `createdAt` NOT NULL with `defaultNow()`, `updatedAt` nullable
- Use `text()` for strings unless length constraint needed
- Use `jsonb()` for flexible/nested data
- For financial data: `decimal("column", { precision: 18, scale: 8 })`
- Foreign keys: use `.references(() => otherTable.id, { onDelete: "cascade" })`
- Add indexes on frequently queried columns

## Migration Workflow

1. Edit schema files in `src/db/schema/`
2. Run `pnpm db:generate` to generate migration SQL
3. Review generated SQL in `drizzle/` or `src/lib/db/migrations/`
4. Run `pnpm db:migrate` to apply (or `pnpm db:push` for dev)
5. Never manually edit generated migration files

## Reference

For complete schema examples from production projects, see `references/schema-examples.md`.
