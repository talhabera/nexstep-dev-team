---
name: Security Checklist
description: This skill should be used when the user asks about "security review", "vulnerability", "data leak", "injection", "XSS", "OWASP", or when performing security audits on Next.js/Drizzle/PostgreSQL projects.
---

# Security Checklist

OWASP-informed security checks for Next.js/Drizzle/PostgreSQL SaaS projects.

## Critical Checks

### 1. Injection Prevention
- Never use raw SQL queries — always use Drizzle query builder
- Validate all input with Zod before processing
- Sanitize user content before rendering

### 2. XSS Prevention
- Never use `dangerouslySetInnerHTML` unless content is sanitized
- React auto-escapes JSX expressions — don't bypass this
- Validate URL parameters before using in links (`javascript:` protocol)

### 3. Authentication
- Protected routes check session at handler start
- Session tokens are httpOnly cookies (Better Auth default)
- Password hashing handled by Better Auth (bcrypt/argon2)
- OAuth state parameter validated (Better Auth handles this)

### 4. Data Exposure
- No `.env` files in git (check `.gitignore`)
- No `NEXT_PUBLIC_` prefix on secret keys
- API responses return only needed fields (select specific columns)
- No `console.log` with sensitive data in production
- Error messages don't leak internal details

### 5. CSRF Protection
- Better Auth includes CSRF protection by default
- Custom API routes should validate `Origin` header for mutations

### 6. Rate Limiting
- Add rate limiting to auth endpoints (login, register)
- Add rate limiting to API routes handling user input
- Consider `next-rate-limit` or `upstash/ratelimit`

## Reference

For detailed OWASP checks with Next.js examples, see `references/owasp-checks.md`.
