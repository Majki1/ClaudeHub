---
title: Use app/index.tsx as a thin entry redirect, not a real screen
impact: MEDIUM
impactDescription: Single source of truth for "where does the app open?"
tags: routing, expo-router
---

## Use app/index.tsx as a thin entry redirect, not a real screen

**Impact: MEDIUM**

`app/index.tsx` is the first screen the router resolves. Use it as a thin redirect that decides where to send the user based on app state (signed in / onboarded / first-launch flag) — not as a real screen with content. This keeps the entry decision in one file instead of scattered across multiple layouts.

**Incorrect (welcome screen handles routing inline, creating a flash):**

```tsx
// app/index.tsx
export default function Index() {
  const { isLoggedIn } = useSession();
  return (
    <View>
      <Welcome />
      {isLoggedIn && useEffect(() => router.replace('/home'), [])}
    </View>
  );
}
```

**Correct (entry file is a pure redirect):**

```tsx
// app/index.tsx
import { Redirect } from 'expo-router';
import { useSession } from '@/lib/session';

export default function Index() {
  const { isLoggedIn, isLoading } = useSession();
  if (isLoading) return null; // splash already on screen — see splash-fonts-pattern
  return <Redirect href={isLoggedIn ? '/(root)/(tabs)/home' : '/(auth)/welcome'} />;
}
```

If your entry decision is async (waiting on a stored token, a remote config flag, a hydrated cache), return `null` while loading rather than rendering UI that's about to be replaced. Pair this with `splash-fonts-pattern` so the native splash stays up until the redirect resolves.

Reference: [Expo Router — Redirect](https://docs.expo.dev/router/reference/redirects/)
