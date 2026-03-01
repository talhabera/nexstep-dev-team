# OWASP Security Checks for Next.js

## A01: Broken Access Control

**Check:** Are all protected routes verifying authentication?

```typescript
// VULNERABLE — no auth check
export async function GET() {
  const users = await db.select().from(users);
  return NextResponse.json({ data: users }); // Exposes all users!
}

// SECURE — auth + ownership check
export async function GET() {
  const session = await auth.api.getSession({ headers: await headers() });
  if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const result = await db.select().from(projects)
    .where(eq(projects.ownerId, session.user.id)); // Only own data
  return NextResponse.json({ data: result });
}
```

**Check:** Are dynamic route params validated?

```typescript
// VULNERABLE — no ownership verification
export async function DELETE(req: Request, { params }: { params: { id: string } }) {
  await db.delete(projects).where(eq(projects.id, params.id)); // Anyone can delete!
}

// SECURE — verify ownership
export async function DELETE(req: Request, { params }: { params: { id: string } }) {
  const session = await auth.api.getSession({ headers: await headers() });
  await db.delete(projects)
    .where(and(eq(projects.id, params.id), eq(projects.ownerId, session.user.id)));
}
```

## A02: Cryptographic Failures

**Check:** Are secrets properly managed?

```bash
# Check for leaked secrets
grep -r "sk-" --include="*.ts" --include="*.tsx" src/
grep -r "password\s*=" --include="*.ts" --include="*.tsx" src/
grep -r "NEXT_PUBLIC_.*SECRET" .env*
```

- Never prefix secrets with `NEXT_PUBLIC_`
- Use `process.env.SECRET` only in server-side code
- Better Auth handles password hashing automatically

## A03: Injection

**Check:** Are all database queries parameterized?

```typescript
// VULNERABLE — string interpolation in SQL
const result = await db.execute(`SELECT * FROM users WHERE id = '${userId}'`);

// SECURE — Drizzle query builder (always parameterized)
const result = await db.select().from(users).where(eq(users.id, userId));
```

## A07: Cross-Site Scripting (XSS)

**Check:** Is user content safely rendered?

```tsx
// VULNERABLE — raw HTML rendering
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// SECURE — React auto-escaping
<div>{userInput}</div>

// If HTML needed — sanitize first
import DOMPurify from "dompurify";
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userInput) }} />
```

**Check:** Are URLs validated?

```typescript
// VULNERABLE — open redirect
const url = searchParams.get("redirect");
redirect(url); // Could redirect to malicious site

// SECURE — whitelist allowed paths
const url = searchParams.get("redirect");
if (url?.startsWith("/")) redirect(url);
else redirect("/dashboard");
```

## Environment Variable Audit

```bash
# Files that should NEVER be in git
.env
.env.local
.env.production

# Check .gitignore includes them
cat .gitignore | grep -E "\.env"

# Check for accidentally committed env files
git log --all --full-history -- ".env*"
```

## Security Headers

Add to `next.config.ts`:

```typescript
const securityHeaders = [
  { key: "X-Frame-Options", value: "DENY" },
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  { key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=()" },
];
```
