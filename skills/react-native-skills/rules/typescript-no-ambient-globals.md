---
title: Don't ship domain types as ambient declarations
impact: MEDIUM
impactDescription: Real imports beat magic globals — better refactors, tooling, and onboarding
tags: typescript, structure
---

## Don't ship domain types as ambient declarations

**Impact: MEDIUM**

Tutorials often put domain types in a `type.d.ts` or `interfaces.d.ts` using `declare interface` so callers don't have to import them. It's frictionless to write but creates several real problems at scale: jump-to-definition is unreliable, types can't be tree-shaken, name collisions happen silently, and a new contributor can't tell where a type lives.

**Incorrect (`declare` floods the global namespace):**

```ts
// types/type.d.ts
declare interface User {
  id: string;
  name: string;
  email: string;
}

declare interface Driver {
  id: number;
  // ...
}
```

```tsx
// any file — User and Driver "just exist", no import
function welcome(user: User) { /* ... */ }
```

**Correct (real modules, explicit imports):**

```ts
// types/user.ts
export interface User {
  id: string;
  name: string;
  email: string;
}

// types/driver.ts
export interface Driver { /* ... */ }

// types/index.ts
export * from './user';
export * from './driver';
```

```tsx
import { User } from '@/types';
function welcome(user: User) { /* ... */ }
```

Legitimate uses for `*.d.ts` files in a React Native project:

- **Asset modules**: `declare module '*.png' { const src: ImageSourcePropType; export default src; }` — the bundler does the runtime work; the types just describe it.
- **Untyped third-party packages**: `declare module 'some-old-lib';` to silence TS until you add real types.
- **`expo-env.d.ts`** (auto-generated) and `nativewind-env.d.ts` — leave these alone.

Domain types (`User`, `Movie`, `Ride`, `Property`) belong in real modules with explicit imports. The 5 seconds you save not typing `import { User } from '@/types'` cost the next person 5 minutes finding where `User` is defined.
