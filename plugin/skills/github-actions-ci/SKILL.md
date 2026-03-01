---
name: GitHub Actions CI
description: This skill should be used when the user asks about "CI/CD", "GitHub Actions", "pipeline", "workflow", "automated tests", or when setting up continuous integration for Next.js projects.
---

# GitHub Actions CI/CD

Workflow patterns for Next.js/Drizzle/PostgreSQL projects with Docker deployments.

## Workflow Structure

Standard pipeline: **lint → test → build → deploy**

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

## Key Patterns

- Cache `pnpm` store for faster installs
- Use `pnpm` via `corepack enable`
- Run lint and type-check in parallel
- Build Docker image and push to registry
- Deploy via Coolify webhook trigger
- Use GitHub Secrets for sensitive values

## Environment Secrets

Required secrets in GitHub repo settings:
- `DATABASE_URL` — for test database
- `COOLIFY_WEBHOOK_URL` — deployment trigger
- `COOLIFY_TOKEN` — auth for deploy API
- `DOCKER_REGISTRY` — container registry URL (if using external)

## Example

For a complete workflow file, see `examples/nextjs-deploy.yml`.
