---
name: Stack Detect
description: This skill should be used when the user asks to "detect stack", "check project tech", "what framework is this", or when any agent needs to understand the current project's technology stack before taking action. Auto-detects Next.js, Drizzle, PostgreSQL, Redis, shadcn/ui, Better Auth, Docker, and testing frameworks from project files.
---

# Stack Detection

Detect the current project's technology stack by reading configuration files. Run this at the start of any agent task to adapt behavior.

## Detection Process

1. Read `package.json` in the project root to identify:
   - Framework: Check for `next` in dependencies (Next.js version)
   - ORM: Check for `drizzle-orm` in dependencies
   - Database driver: Check for `postgres` or `@neondatabase/serverless`
   - Cache: Check for `ioredis` in dependencies
   - UI: Check for `@radix-ui/*` and presence of `components.json` (shadcn)
   - Auth: Check for `better-auth` in dependencies
   - AI: Check for `@anthropic-ai/sdk`, `@ai-sdk/anthropic`, or `ai` packages
   - Testing: Check for `vitest` in devDependencies
   - Validation: Check for `zod` in dependencies
   - Package manager: Check for `pnpm-lock.yaml`, `yarn.lock`, or `package-lock.json`

2. Check for infrastructure files:
   - `Dockerfile` — Docker deployment
   - `docker-compose.yml` / `docker-compose.dev.yml` — Service orchestration
   - `.github/workflows/` — GitHub Actions CI/CD
   - `drizzle.config.ts` — Drizzle ORM configuration (read for schema path)
   - `components.json` — shadcn/ui configuration (read for style/theme)

3. Check for project-specific patterns:
   - `src/app/api/` — API routes present
   - `src/db/schema/` or `src/lib/db/schema.ts` — Database schema location
   - `src/components/ui/` — UI component library
   - `src/lib/auth.ts` or `src/lib/auth-server.ts` — Auth setup

## Output Format

After detection, summarize findings as a checklist at the top of your response:

```
Stack: Next.js 16 | Drizzle 0.45 | PostgreSQL | Redis | shadcn/ui | Better Auth | Docker
Missing: No CI/CD | No tests
Schema: src/db/schema/index.ts
UI Style: new-york (shadcn)
Package Manager: pnpm
```

## Adaptation Rules

- If no Drizzle/PostgreSQL detected: Skip database-related suggestions
- If no shadcn/ui detected: Use project's custom component patterns instead
- If no Better Auth detected: Skip auth-specific middleware suggestions
- If no Redis detected: Skip caching layer suggestions
- If no Vitest detected: Note testing gap but don't force test creation
- If no Docker detected: Flag as infrastructure gap for DevOps agent
