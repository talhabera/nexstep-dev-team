# Routing Patterns

## Route Groups for Layout Separation

```
src/app/
├── (marketing)/          → No auth required, marketing layout
│   ├── layout.tsx        → Header + Footer, no sidebar
│   ├── page.tsx          → Landing page (/)
│   ├── pricing/page.tsx  → Pricing (/pricing)
│   ├── about/page.tsx    → About (/about)
│   └── blog/
│       ├── page.tsx      → Blog list (/blog)
│       └── [slug]/page.tsx → Blog post (/blog/my-post)
│
├── (dashboard)/          → Auth required, dashboard layout
│   ├── layout.tsx        → Sidebar + TopNav, auth check
│   ├── page.tsx          → Dashboard home (/dashboard or /)
│   ├── projects/
│   │   ├── page.tsx      → Project list
│   │   ├── new/page.tsx  → Create project
│   │   └── [id]/
│   │       ├── page.tsx  → Project detail
│   │       ├── settings/page.tsx
│   │       └── layout.tsx → Project-specific sub-nav
│   └── settings/
│       ├── page.tsx      → General settings
│       ├── billing/page.tsx
│       └── team/page.tsx
│
├── (auth)/               → Auth pages, minimal layout
│   ├── layout.tsx        → Centered card layout
│   ├── login/page.tsx
│   ├── register/page.tsx
│   └── forgot-password/page.tsx
```

## Protected Layout Pattern

```tsx
// src/app/(dashboard)/layout.tsx
import { redirect } from "next/navigation";
import { auth } from "@/lib/auth";
import { headers } from "next/headers";

export default async function DashboardLayout({ children }: { children: React.ReactNode }) {
  const session = await auth.api.getSession({ headers: await headers() });

  if (!session) {
    redirect("/login");
  }

  return (
    <div className="flex min-h-screen">
      <Sidebar />
      <main className="flex-1 p-6">{children}</main>
    </div>
  );
}
```

## Loading States

```tsx
// src/app/(dashboard)/projects/loading.tsx
import { Skeleton } from "@/components/ui/skeleton";

export default function Loading() {
  return (
    <div className="space-y-4">
      <Skeleton className="h-8 w-48" />
      <div className="grid gap-4 md:grid-cols-3">
        {Array.from({ length: 6 }).map((_, i) => (
          <Skeleton key={i} className="h-32" />
        ))}
      </div>
    </div>
  );
}
```

## Error Boundaries

```tsx
// src/app/(dashboard)/projects/error.tsx
"use client";

export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center gap-4 py-16">
      <h2 className="text-lg font-semibold">Something went wrong</h2>
      <p className="text-muted-foreground">{error.message}</p>
      <button onClick={reset} className="text-primary underline">
        Try again
      </button>
    </div>
  );
}
```

## Metadata Pattern

```tsx
// Static metadata
export const metadata = {
  title: "Projects | AppName",
  description: "Manage your projects",
};

// Dynamic metadata
export async function generateMetadata({ params }: { params: { id: string } }) {
  const project = await getProject(params.id);
  return {
    title: `${project.name} | AppName`,
    description: project.description,
  };
}
```

## Middleware for Auth Redirects

```typescript
// src/middleware.ts
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const publicPaths = ["/", "/pricing", "/about", "/blog", "/login", "/register"];

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Allow public paths
  if (publicPaths.some((path) => pathname === path || pathname.startsWith("/blog/"))) {
    return NextResponse.next();
  }

  // Allow API and static assets
  if (pathname.startsWith("/api/") || pathname.startsWith("/_next/")) {
    return NextResponse.next();
  }

  // Check for session cookie
  const sessionCookie = request.cookies.get("better-auth.session_token");
  if (!sessionCookie) {
    return NextResponse.redirect(new URL("/login", request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"],
};
```
