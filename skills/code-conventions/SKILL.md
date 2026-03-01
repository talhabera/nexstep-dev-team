---
name: Code Conventions
description: This skill should be used when the user asks about "naming conventions", "code style", "import order", "file structure", "component patterns", or when any agent needs to follow project conventions for Next.js/Drizzle/PostgreSQL SaaS projects.
---

# Code Conventions

Shared conventions for Next.js/Drizzle/PostgreSQL SaaS projects. Apply these when writing or reviewing code.

## File Naming

- **Components:** PascalCase (`UserProfile.tsx`, `DashboardLayout.tsx`)
- **Pages/Routes:** kebab-case directories (`(dashboard)/settings/page.tsx`)
- **Utilities/Libs:** camelCase (`authClient.ts`, `chatParser.ts`)
- **Schema files:** kebab-case (`team-members.ts`, `chat-messages.ts`)
- **API routes:** kebab-case directories (`api/token-usage/route.ts`)
- **Hooks:** camelCase with `use` prefix (`useSession.ts`, `useChat.ts`)
- **Types:** camelCase (`types/index.ts`)

## Import Order

1. React/Next.js imports
2. Third-party libraries
3. Internal `@/lib/` utilities
4. Internal `@/db/` database imports
5. Internal `@/components/` components
6. Relative imports
7. Type-only imports last

## Component Patterns

- Use Server Components by default (no `"use client"` unless needed)
- Mark Client Components explicitly with `"use client"` at top
- Co-locate feature components in `components/feature-name/`
- Shared UI in `components/ui/` (shadcn managed)
- Layout components in `components/layout/`

## API Route Patterns

- Validate input with Zod schemas at the top of handlers
- Return consistent error shapes: `{ error: string, status: number }`
- Use `NextResponse.json()` for all responses
- Auth check at the start of protected routes

## Database Patterns

- UUID primary keys with `defaultRandom()`
- Timestamps: `createdAt` with `defaultNow()`, `updatedAt` nullable
- Relations in separate `relations.ts` file or inline per schema file
- Schema files export both table definitions and TypeScript types

## Reference

For detailed naming patterns and examples, see `references/naming-patterns.md`.
