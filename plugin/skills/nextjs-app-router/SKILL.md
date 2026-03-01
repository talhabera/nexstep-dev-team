---
name: Next.js App Router
description: This skill should be used when the user asks to "create page", "add route", "layout", "loading state", "error boundary", "server component", or when working with Next.js App Router patterns.
---

# Next.js App Router Patterns

Conventions and patterns for Next.js 16 App Router in SaaS projects.

## Directory Conventions

```
src/app/
├── (marketing)/        → Public pages (landing, pricing, about)
│   ├── layout.tsx      → Marketing layout (header, footer)
│   ├── page.tsx        → Landing page
│   └── pricing/page.tsx
├── (dashboard)/        → Authenticated pages
│   ├── layout.tsx      → Dashboard layout (sidebar, nav)
│   ├── page.tsx        → Dashboard home
│   ├── projects/
│   │   ├── page.tsx    → Project list
│   │   └── [id]/page.tsx → Project detail
│   └── settings/page.tsx
├── api/                → API routes
│   ├── health/route.ts → Health check
│   └── projects/route.ts
├── layout.tsx          → Root layout (providers, fonts)
└── not-found.tsx       → 404 page
```

## Server vs Client Decision Tree

Use **Server Component** (default) when:
- Fetching data directly from database
- Accessing backend resources
- Rendering static or SEO-critical content
- No user interaction needed

Use **Client Component** (`"use client"`) when:
- Using React hooks (`useState`, `useEffect`)
- Handling user events (`onClick`, `onChange`)
- Using browser APIs (`localStorage`, `window`)
- Using third-party client libraries

## Key Patterns

- Route groups `()` for shared layouts without URL segments
- `loading.tsx` for Suspense-based loading states
- `error.tsx` for error boundaries (must be client component)
- `not-found.tsx` for 404 pages
- Metadata API for SEO (`export const metadata` or `generateMetadata`)
- Middleware in `src/middleware.ts` for auth redirects

## Reference

For route organization patterns, see `references/routing-patterns.md`.
