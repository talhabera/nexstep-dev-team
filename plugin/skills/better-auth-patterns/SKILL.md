---
name: Better Auth Patterns
description: This skill should be used when the user asks about "authentication", "login flow", "OAuth", "session", "protect route", "Better Auth", or when implementing auth in Next.js projects with Better Auth.
---

# Better Auth Patterns

Authentication patterns using Better Auth with Drizzle adapter for Next.js projects.

## Setup

Better Auth requires:
1. Server-side auth instance (`src/lib/auth.ts`)
2. Client-side auth instance (`src/lib/auth-client.ts`)
3. API route handler (`src/app/api/auth/[...all]/route.ts`)
4. Drizzle adapter for database sessions

## Server Auth Instance

```typescript
// src/lib/auth.ts
import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { db } from "@/db";

export const auth = betterAuth({
  database: drizzleAdapter(db, { provider: "pg" }),
  emailAndPassword: { enabled: true },
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    },
  },
});
```

## Session Checking

```typescript
// In API routes or server components:
import { auth } from "@/lib/auth";
import { headers } from "next/headers";

const session = await auth.api.getSession({ headers: await headers() });
if (!session) {
  return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
}
// session.user.id, session.user.email available
```

## Protected Layout

Redirect unauthenticated users at the layout level for entire route groups.

## Reference

For complete OAuth setup guide, see `references/oauth-setup.md`.
