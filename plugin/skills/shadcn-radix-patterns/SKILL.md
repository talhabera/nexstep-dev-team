---
name: shadcn/Radix Patterns
description: This skill should be used when the user asks about "shadcn component", "radix ui", "add button", "create dialog", "component variant", or when working with shadcn/ui and Radix UI in Next.js projects.
---

# shadcn/ui & Radix UI Patterns

Patterns for using shadcn/ui with Radix UI primitives in Next.js projects.

## Adding Components

```bash
pnpm dlx shadcn@latest add button card dialog form input select table tabs toast
```

## Configuration

shadcn/ui uses `components.json` for project-wide settings:
- **style:** `new-york` (recommended) or `default`
- **tailwind.baseColor:** theme color palette
- **aliases.components:** `@/components`
- **aliases.utils:** `@/lib/utils`

## Key Patterns

- Never modify files in `components/ui/` directly — extend with wrappers
- Use CVA (class-variance-authority) for variant definitions
- Theme via CSS variables in `globals.css`
- Compound components for complex UI (e.g., DataTable = Table + Toolbar + Pagination)

## Component Extension

Create project-specific wrappers that compose shadcn primitives:

```tsx
// components/feature/ProjectCard.tsx — NOT in ui/
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export function ProjectCard({ project }: { project: Project }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>{project.name}</CardTitle>
      </CardHeader>
      <CardContent>{project.description}</CardContent>
    </Card>
  );
}
```

## Reference

For common component composition recipes, see `references/component-recipes.md`.
