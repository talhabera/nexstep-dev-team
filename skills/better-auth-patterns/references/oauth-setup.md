# OAuth Setup Guide

## Google OAuth

### 1. Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create new project or select existing
3. Enable "Google+ API" or "People API"
4. Go to Credentials → Create OAuth 2.0 Client ID
5. Set authorized redirect URI: `https://yourdomain.com/api/auth/callback/google`

### 2. Environment Variables
```env
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
```

## GitHub OAuth

### 1. Create GitHub OAuth App
1. Go to GitHub → Settings → Developer Settings → OAuth Apps
2. Create new OAuth App
3. Set Authorization callback URL: `https://yourdomain.com/api/auth/callback/github`

### 2. Environment Variables
```env
GITHUB_CLIENT_ID=your-client-id
GITHUB_CLIENT_SECRET=your-client-secret
```

## API Route Handler

```typescript
// src/app/api/auth/[...all]/route.ts
import { auth } from "@/lib/auth";
import { toNextJsHandler } from "better-auth/next-js";

export const { POST, GET } = toNextJsHandler(auth);
```

## Client-Side Auth

```typescript
// src/lib/auth-client.ts
import { createAuthClient } from "better-auth/react";

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_APP_URL,
});

export const { signIn, signUp, signOut, useSession } = authClient;
```

## Login Component

```tsx
"use client";

import { signIn } from "@/lib/auth-client";
import { Button } from "@/components/ui/button";

export function LoginButtons() {
  return (
    <div className="flex flex-col gap-2">
      <Button onClick={() => signIn.social({ provider: "google" })}>
        Continue with Google
      </Button>
      <Button onClick={() => signIn.social({ provider: "github" })} variant="outline">
        Continue with GitHub
      </Button>
    </div>
  );
}
```

## Session Hook Usage

```tsx
"use client";

import { useSession } from "@/lib/auth-client";

export function UserMenu() {
  const { data: session, isPending } = useSession();

  if (isPending) return <Skeleton className="h-8 w-8 rounded-full" />;
  if (!session) return <LoginButton />;

  return (
    <div>
      <span>{session.user.name}</span>
      <img src={session.user.image} alt={session.user.name} />
    </div>
  );
}
```

## Required Environment Variables

```env
BETTER_AUTH_SECRET=your-random-secret-at-least-32-chars
BETTER_AUTH_URL=https://yourdomain.com
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
GITHUB_CLIENT_ID=...
GITHUB_CLIENT_SECRET=...
```
