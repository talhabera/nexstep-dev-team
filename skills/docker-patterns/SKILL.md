---
name: Docker Patterns
description: This skill should be used when the user asks about "Dockerfile", "docker build", "multi-stage", "docker-compose", "container", or when configuring Docker for Next.js/PostgreSQL projects.
---

# Docker Patterns

Docker configuration patterns for Next.js/Drizzle/PostgreSQL projects deployed to Coolify or similar platforms.

## Multi-Stage Build Pattern

4-stage Dockerfile for Next.js standalone output:

1. **deps** — Install dependencies with frozen lockfile
2. **build** — Build Next.js with standalone output
3. **bundle** — Bundle migration files and Drizzle config
4. **runner** — Production image with non-root user

## Key Configuration

- `output: "standalone"` in `next.config.ts` for minimal production bundle
- Non-root user: `nextjs` (UID 1001) in `nodejs` group (GID 1001)
- Entrypoint script runs migrations before starting app
- Health check via `/api/health` endpoint
- Alpine-based images for minimal size

## Docker-Compose Services

Standard service stack:
- **app** — Next.js application (depends on postgres, redis)
- **postgres** — PostgreSQL 16+ with health check and persistent volume
- **redis** — Redis 7+ with health check and persistent volume

## Essential Practices

- Always use `--frozen-lockfile` for reproducible installs
- Copy only `package.json` + lockfile first (layer caching)
- Set `NODE_ENV=production` in runner stage
- Expose only port 3000
- Use named volumes for data persistence
- Add health checks to all services

## Reference

For complete Dockerfile and docker-compose templates, see `references/multistage-templates.md`.
