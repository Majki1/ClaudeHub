---
title: Use the @/* path alias from the project root
impact: MEDIUM
impactDescription: Imports survive file moves; no fragile ../../../ chains
tags: structure, typescript, expo
---

## Use the @/* path alias from the project root

**Impact: MEDIUM**

Configure a single `@/*` alias that points at the project root (not `src/*`) and use it for every cross-folder import. Relative imports like `../../components/Card` rot every time you move a file; the alias never does.

**Incorrect (relative chains across folder boundaries):**

```ts
import { Card } from '../../../components/Card';
import { fetchMovies } from '../../services/api';
```

**Correct (`@/` alias resolves from root):**

```ts
import { Card } from '@/components/Card';
import { fetchMovies } from '@/services/api';
```

`tsconfig.json`:

```jsonc
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  }
}
```

For Babel resolution, Expo's default `metro` config already understands the `tsconfig` paths — no `babel-plugin-module-resolver` needed. Keep relative imports for siblings within the same folder (`./Card`).

Reference: [Expo — Path aliases](https://docs.expo.dev/guides/typescript/#path-aliases)
