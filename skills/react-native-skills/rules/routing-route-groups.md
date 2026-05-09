---
title: Use Expo Router route groups for auth/tabs/protected sections
impact: HIGH
impactDescription: Cleaner separation of auth, tabs, and protected screens; one place to gate access
tags: routing, expo-router, structure
---

## Use Expo Router route groups for auth/tabs/protected sections

**Impact: HIGH**

Group related screens with parenthesised folders (`(auth)`, `(tabs)`, `(root)`, `(api)`). Group folders don't appear in the URL, but each can have its own `_layout.tsx` that controls navigator type, headers, and access gating. This concentrates checks (auth state, onboarding completion, feature flags) in one place per group instead of repeating `<Redirect>` logic in every screen.

Common arrangement:

- `app/(auth)/_layout.tsx` — `Stack`, redirects to `/home` if already signed in
- `app/(root)/_layout.tsx` or `app/(tabs)/_layout.tsx` — redirects to `/sign-in` if not signed in
- `app/(api)/...+api.ts` — server routes, no UI

**Incorrect (auth check repeated in every screen):**

```tsx
// app/home.tsx
export default function Home() {
  const { isLoggedIn } = useSession();
  if (!isLoggedIn) return <Redirect href="/sign-in" />;
  // ...
}
// app/profile.tsx — same logic again, etc.
```

**Correct (gate once at the group layout):**

```tsx
// app/(tabs)/_layout.tsx
import { Redirect, Tabs } from 'expo-router';
import { useSession } from '@/lib/session';

export default function TabsLayout() {
  const { isLoggedIn, isLoading } = useSession();
  if (isLoading) return null;
  if (!isLoggedIn) return <Redirect href="/sign-in" />;
  return <Tabs screenOptions={{ headerShown: false }} />;
}
```

The `useSession` hook above is a stand-in for whatever your app uses (a context provider, a Zustand store, a third-party auth SDK). The pattern is the same regardless: read state once at the layout, redirect or render.

Reference: [Expo Router — Groups](https://docs.expo.dev/router/layouts/#groups)
