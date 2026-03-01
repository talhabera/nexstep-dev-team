---
name: Deployment Checklist
description: This skill should be used when the user asks to "deploy", "pre-deploy check", "deployment checklist", "ready for production", "go live", or when the DevOps agent needs to verify a project is ready for deployment.
---

# Deployment Checklist

Pre-deployment verification for Next.js/Drizzle/PostgreSQL projects deployed via Docker to Coolify or similar platforms.

## Quick Checklist

1. **Build passes:** `pnpm build` succeeds with no errors
2. **Docker builds:** `docker build .` completes successfully
3. **Env vars set:** All required environment variables configured in deployment target
4. **Migrations ready:** `drizzle/` contains latest migration files matching schema
5. **Health check:** `/api/health` endpoint exists and returns 200
6. **No secrets in code:** No hardcoded API keys, passwords, or connection strings
7. **Standalone output:** `next.config.ts` has `output: "standalone"`
8. **Docker entrypoint:** Runs migrations before starting app
9. **Non-root user:** Dockerfile creates and uses non-root user (nextjs)
10. **Volumes configured:** Database and cache volumes are persistent

## Critical Environment Variables

Check these are set in the deployment environment (not hardcoded):
- `DATABASE_URL` — PostgreSQL connection string
- `BETTER_AUTH_SECRET` — Auth signing key (if using Better Auth)
- `BETTER_AUTH_URL` — Auth callback URL (if using Better Auth)
- `REDIS_URL` — Redis connection (if using Redis)
- API keys for external services (Anthropic, BFL, etc.)

## Reference

For detailed step-by-step deploy process, see `references/pre-deploy-steps.md`.
