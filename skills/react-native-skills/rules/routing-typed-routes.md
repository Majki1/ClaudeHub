---
title: Enable typedRoutes for autocomplete-safe href values
impact: MEDIUM
impactDescription: Catches dead links and typos at compile time
tags: routing, expo-router, typescript
---

## Enable typedRoutes for autocomplete-safe href values

**Impact: MEDIUM**

Expo Router can generate a typed union of every route in your app from your file tree. When enabled, `<Link href>` and `router.push` only accept paths that actually exist. This eliminates the most common navigation bug: silently broken links after a rename or move.

Turn it on in `app.json`:

**Incorrect (any string accepted, broken links surface only at runtime):**

```jsonc
// app.json
{
  "expo": {
    "experiments": {}
  }
}
```

```tsx
router.push('/(root)/(tabs)/hoem'); // typo — compiles fine, blank screen at runtime
```

**Correct (typo is a TS error):**

```jsonc
// app.json
{
  "expo": {
    "experiments": {
      "typedRoutes": true
    }
  }
}
```

```tsx
router.push('/(root)/(tabs)/home'); // ✓ autocompleted
router.push('/(root)/(tabs)/hoem'); // ✗ TS error
```

Run `npx expo customize tsconfig.json` once if your `tsconfig` doesn't already extend `expo/tsconfig.base` so the generated types are picked up.

Reference: [Expo Router — Typed Routes](https://docs.expo.dev/router/reference/typed-routes/)
