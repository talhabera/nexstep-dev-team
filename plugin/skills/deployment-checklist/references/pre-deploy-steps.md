# Pre-Deploy Steps

## 1. Docker Multi-Stage Build Verification

Ensure Dockerfile uses the 4-stage pattern:

```dockerfile
# Stage 1: Install dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile

# Stage 2: Build application
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN corepack enable && pnpm build

# Stage 3: Bundle migrations
FROM node:20-alpine AS migrator
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY drizzle ./drizzle
COPY src/db ./src/db
COPY drizzle.config.ts ./

# Stage 4: Production runner
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs && adduser --system --uid 1001 nextjs
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
COPY --from=migrator /app/drizzle ./drizzle
COPY --from=migrator /app/node_modules ./node_modules
COPY --from=migrator /app/src/db ./src/db
COPY --from=migrator /app/drizzle.config.ts ./
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh
USER nextjs
EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]
```

## 2. Entrypoint Script

```bash
#!/bin/sh
# Run migrations before starting
echo "Running database migrations..."
npx drizzle-kit migrate
echo "Starting application..."
node server.js
```

## 3. Docker-Compose Health Checks

```yaml
services:
  app:
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  postgres:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
```

## 4. Coolify-Specific Configuration

- Set build pack to "Dockerfile"
- Configure environment variables in Coolify dashboard
- Set custom domain and SSL (auto via Coolify)
- Configure persistent volumes for database data
- Set resource limits (CPU, memory)

## 5. Rollback Strategy

1. Tag releases: `git tag v1.x.x` before deploy
2. Keep previous Docker image available
3. Database: migrations should be forward-only; if rollback needed, create a new migration that reverts
4. Coolify: use "Rollback" button to restore previous deployment

## 6. Database Backup Before Migration

```bash
# Before deploying with schema changes:
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d-%H%M%S).sql

# Or via Docker:
docker exec postgres pg_dump -U postgres dbname > backup.sql
```
