---
name: API Route Patterns
description: This skill should be used when the user asks about "API route", "endpoint", "REST API", "route handler", "server action", or when creating API endpoints in Next.js App Router.
---

# API Route Patterns

Patterns for Next.js App Router route handlers with Zod validation, auth checks, and consistent error responses.

## Route Handler Structure

Every route handler follows this order:
1. **Validate input** — Parse body/params with Zod
2. **Check auth** — Verify session if protected
3. **Execute logic** — Database query or business logic
4. **Return response** — Consistent JSON shape

## Standard Pattern

```typescript
import { NextResponse } from "next/server";
import { z } from "zod";
import { auth } from "@/lib/auth";
import { headers } from "next/headers";
import { db } from "@/db";

const createSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().optional(),
});

export async function POST(request: Request) {
  // 1. Validate
  const body = await request.json();
  const parsed = createSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.issues[0].message }, { status: 400 });
  }

  // 2. Auth
  const session = await auth.api.getSession({ headers: await headers() });
  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  // 3. Logic
  const result = await db.insert(projects).values({
    ...parsed.data,
    ownerId: session.user.id,
  }).returning();

  // 4. Response
  return NextResponse.json({ data: result[0] }, { status: 201 });
}
```

## Response Shapes

- Success: `{ data: T }` with status 200/201
- Error: `{ error: string }` with status 4xx/5xx
- List: `{ data: T[], count?: number }`

## Reference

For CRUD, streaming, and file upload examples, see `references/validation-examples.md`.
