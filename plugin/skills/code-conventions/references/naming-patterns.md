# Naming Patterns Reference

## Variable Naming

- **Boolean:** `is`/`has`/`can` prefix (`isAuthenticated`, `hasAccess`, `canEdit`)
- **Handlers:** `handle` prefix (`handleSubmit`, `handleDelete`)
- **Callbacks:** `on` prefix for props (`onSuccess`, `onChange`)
- **Constants:** SCREAMING_SNAKE_CASE for true constants (`MAX_RETRIES`, `API_BASE_URL`)
- **Env vars:** SCREAMING_SNAKE_CASE with `NEXT_PUBLIC_` prefix for client-side

## Drizzle Schema Naming

- **Table names:** camelCase in code, kebab-case in SQL (`chatMessages` → `chat-messages`)
- **Column names:** camelCase in code, snake_case in SQL (Drizzle handles mapping)
- **Relations:** `[tableName]Relations` naming (`usersRelations`, `projectsRelations`)
- **Enums:** PascalCase type, camelCase values (`statusEnum: 'active' | 'inactive'`)

## shadcn/ui Component Extension

- Extend shadcn components in `components/ui/`, never modify originals directly
- Create wrapper components for project-specific variants
- Use CVA (class-variance-authority) for variant definitions
- Naming: same as shadcn base (`Button`, `Card`) — add prefix only for project-specific (`ProjectCard`, `TaskDialog`)

## API Response Shapes

Success: `{ data: T }`
Error: `{ error: string }`
List: `{ data: T[], count?: number }`
Paginated: `{ data: T[], total: number, page: number, limit: number }`
