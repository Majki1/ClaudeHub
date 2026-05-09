---
title: Centralise static assets in constants/icons.ts and constants/images.ts
impact: LOW
impactDescription: One place to rename or swap an asset; no scattered require() calls
tags: structure, assets, refactoring
---

## Centralise static assets in constants/icons.ts and constants/images.ts

**Impact: LOW**

React Native requires `require()` for static asset imports (Metro can't resolve dynamic strings). When `require()` calls are sprinkled across components, renaming or swapping an asset means hunting through dozens of files. Centralise them in barrel files under `constants/` and import the named bag instead.

**Incorrect (require() scattered through every component):**

```tsx
// components/Header.tsx
<Image source={require('../assets/icons/search.png')} />

// components/Filters.tsx
<Image source={require('../assets/icons/search.png')} /> // duplicate
```

**Correct (single source of truth, components reference by key):**

```ts
// constants/icons.ts
import search from '@/assets/icons/search.png';
import filter from '@/assets/icons/filter.png';
import star from '@/assets/icons/star.png';

export default { search, filter, star };
```

```tsx
// components/Header.tsx
import icons from '@/constants/icons';
<Image source={icons.search} />
```

Apply the same pattern to `constants/images.ts` for static images (logos, illustrations, onboarding art). For remote/dynamic images, use `expo-image` with a URL — see `ui-expo-image`.

If you have many assets, consider grouping them by domain (`constants/icons/onboarding.ts`) once a single file gets unwieldy.
