---
title: EXPO_PUBLIC_* env vars are bundled into the client — never put secrets there
impact: CRITICAL
impactDescription: Misuse leaks API keys to anyone with the app binary
tags: data, security, env
---

## EXPO_PUBLIC_* env vars are bundled into the client — never put secrets there

**Impact: CRITICAL**

Any env var prefixed `EXPO_PUBLIC_` is inlined into the JS bundle at build time. It's trivially recoverable from the shipped app (run `strings` on the bundle, or unzip the IPA/APK). Treat `EXPO_PUBLIC_*` like values printed on a billboard.

**Safe in `EXPO_PUBLIC_*`:**

- Public anon / publishable keys explicitly designed for client use (the kind labelled "publishable" or "anon" in the upstream service's docs)
- Public URLs and project IDs
- Read-only API keys with a public rate-limit tier

**NEVER in `EXPO_PUBLIC_*`:**

- Any key labelled "secret", "service-role", "admin", or "private"
- Database connection strings
- Webhook signing secrets
- Anything you couldn't tweet

**Incorrect (secret leaks into the bundle):**

```dotenv
# .env
EXPO_PUBLIC_API_SECRET=sk_live_xxx
EXPO_PUBLIC_DATABASE_URL=postgresql://user:password@host/db
```

```ts
// app/screen.tsx
const res = await fetch('https://api.example.com/charge', {
  headers: { Authorization: `Bearer ${process.env.EXPO_PUBLIC_API_SECRET!}` }, // ❌ ships to every device
});
```

**Correct (secret stays server-side, called via an API route):**

```dotenv
# .env — no EXPO_PUBLIC_ prefix → server-only
API_SECRET=sk_live_xxx
DATABASE_URL=postgresql://user:password@host/db
EXPO_PUBLIC_API_PUBLISHABLE=pk_live_xxx   # ok — public by design
```

```ts
// app/(api)/charge+api.ts  — server route, has access to non-public env
export async function POST(request: Request) {
  const upstream = await fetch('https://api.example.com/charge', {
    method: 'POST',
    headers: { Authorization: `Bearer ${process.env.API_SECRET!}` },
    body: await request.text(),
  });
  return new Response(upstream.body, { status: upstream.status });
}
```

```ts
// app/screen.tsx — client calls the proxy
const res = await fetch('/(api)/charge', { method: 'POST', body: JSON.stringify(payload) });
```

Validate every required env var at module load with a clear thrown error — silent `undefined` values are harder to debug than a hard failure.

Pair with `routing-api-routes` for the server-side half of this pattern.

Reference: [Expo — Environment variables](https://docs.expo.dev/guides/environment-variables/)
