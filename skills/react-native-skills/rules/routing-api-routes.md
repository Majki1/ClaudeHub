---
title: Colocate server endpoints as +api.ts files in app/(api)/
impact: MEDIUM
impactDescription: Backend code lives next to the screens that call it; no separate server repo for simple cases
tags: routing, expo-router, api
---

## Colocate server endpoints as +api.ts files in app/(api)/

**Impact: MEDIUM**

Expo Router supports server routes via files ending in `+api.ts`. Group them under `app/(api)/` so they don't pollute the URL but still benefit from the file-based routing system. This is the canonical place for any work that needs to stay off the device — touching a private API key, signing a webhook payload, writing to a database with admin credentials.

Two requirements: set `web.output: "server"` (or `"static"` if you don't need server routes on web) in `app.json`, and deploy to a host that supports server routes (EAS Hosting, Vercel, etc.).

**Incorrect (private key shipped in the JS bundle):**

```ts
// app/(tabs)/checkout.tsx
const res = await fetch('https://api.example.com/charge', {
  headers: { Authorization: `Bearer ${SECRET_KEY}` }, // ❌ recoverable from the bundle
});
```

**Correct (secret stays on the server, client calls a thin proxy):**

```ts
// app/(api)/charge+api.ts
export async function POST(request: Request) {
  const body = await request.json();
  const upstream = await fetch('https://api.example.com/charge', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${process.env.SECRET_KEY!}`, // server-only env var
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });
  if (!upstream.ok) return Response.json({ error: 'upstream' }, { status: 502 });
  return Response.json(await upstream.json());
}
```

```tsx
// client
const res = await fetch('/(api)/charge', {
  method: 'POST',
  body: JSON.stringify({ amount, currency }),
});
```

Three things to do at the top of every server route — they are public by default:

1. **Validate the request body** with a schema library (Zod or similar). Don't trust the shape of `await request.json()`.
2. **Authenticate the caller** — verify a session cookie / JWT / signed header before doing any privileged work.
3. **Rate-limit** writes and anything that costs money downstream.

Pair this rule with `data-public-env-secrets` — the whole point of `+api.ts` is to keep secrets out of `EXPO_PUBLIC_*`.

Reference: [Expo Router — API Routes](https://docs.expo.dev/router/reference/api-routes/)
