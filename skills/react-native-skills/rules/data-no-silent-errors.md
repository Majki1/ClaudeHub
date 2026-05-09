---
title: Don't swallow data-layer errors with console.error + return null
impact: HIGH
impactDescription: Silent failures hide outages; users see blank screens with no signal to engineering
tags: data, error-handling, observability
---

## Don't swallow data-layer errors with console.error + return null

**Impact: HIGH**

A common tutorial pattern wraps every async call in `try { ... } catch (e) { console.error(e); return null }`. The screen renders empty, the user sees nothing, and your monitoring sees nothing either. Users rage-quit; engineering finds out from a support ticket a week later.

**Incorrect (failure mode is invisible):**

```ts
export async function getCurrentUser() {
  try {
    const user = await api.fetchUser();
    return user;
  } catch (e) {
    console.error(e); // ❌ goes to dev console only
    return null;       // ❌ caller can't tell "not logged in" from "network down"
  }
}
```

**Correct (let the data layer surface failure shapes; route them to UI + telemetry):**

```ts
export type Result<T> = { ok: true; data: T } | { ok: false; error: Error };

export async function getCurrentUser(): Promise<Result<User>> {
  try {
    const user = await api.fetchUser();
    return { ok: true, data: user };
  } catch (error) {
    reportError(error); // your monitoring of choice — Sentry, PostHog, custom endpoint
    return { ok: false, error: error as Error };
  }
}
```

```tsx
// caller
const result = await getCurrentUser();
if (!result.ok) return <ErrorBanner message={result.error.message} onRetry={refetch} />;
return <Profile user={result.data} />;
```

Three rules of thumb:

1. **Distinguish "no data" from "request failed."** They need different UI. `null` for both collapses information the caller needs.
2. **Send every caught error to a monitoring service.** `console.error` only exists for the developer running on a simulator — your users don't have one.
3. **Wrap render trees in error boundaries** — a thrown render-time error should not white-screen the app. Use `expo-router`'s built-in error boundary for routes, and a top-level boundary for the root layout.

Don't put `Alert.alert()` inside the data layer either — it couples data to UI and breaks any non-screen consumer (e.g. a background prefetch, a server route, a worker hook).
