# Tutorial Pattern Provenance

Patterns and anti-patterns extracted from four widely-followed Expo Router / React Native tutorial repositories by [Adrian Hajdin (JavaScript Mastery)](https://github.com/adrianhajdin). Each repo contributed real-world idioms — both worth-keeping and worth-flagging — that informed the new rule files in `rules/`.

This document maps each rule back to the source repo(s) so you can read the original code, judge the trade-offs, and decide what to apply.

## Source repos

| Repo | Domain | Stack highlights |
|---|---|---|
| [`adrianhajdin/react_native-restate`](https://github.com/adrianhajdin/react_native-restate) | Real estate listings | Expo SDK 52, Appwrite, NativeWind 4, OAuth deep-link |
| [`adrianhajdin/react-native-movie-app`](https://github.com/adrianhajdin/react-native-movie-app) | Movies / search | Expo SDK 52, TMDB, Appwrite (analytics), NativeWind 4 |
| [`adrianhajdin/uber`](https://github.com/adrianhajdin/uber) | Uber clone | Expo SDK 51, Clerk, Stripe, Neon Postgres, Google Maps, Zustand |
| [`adrianhajdin/aora`](https://github.com/adrianhajdin/aora) | Video sharing | Expo SDK 50, Appwrite, expo-av, NativeWind 2, **JS only** |

## Rules by source

### Routing & Expo Router

- **`routing-route-groups`** — All four repos. Distilled from `app/(auth)/_layout`, `app/(tabs)/_layout`, `app/(root)/_layout` patterns. The Uber repo also adds `app/(api)/` for server routes.
- **`routing-typed-routes`** — Restate and Movie repos enable `experiments.typedRoutes: true` in `app.json`. Worth adopting universally.
- **`routing-index-redirect`** — Uber's `app/index.tsx` redirects via `useAuth().isSignedIn`; Aora redirects via `<Redirect>` based on context state.
- **`routing-api-routes`** — Uber repo only: `app/(api)/(stripe)/create+api.ts`, `app/(api)/ride/create+api.ts`. The cleanest demonstration of when `+api.ts` is the right tool (Stripe `paymentIntent` creation, signed DB writes).

### Project structure

- **`structure-path-alias`** — All four use `@/*` → project root. Restate's `tsconfig.json` is the canonical setup.
- **`structure-asset-barrels`** — All four use `constants/icons.ts` + `constants/images.ts` re-export bags. Movie repo uses `constants/icons.ts` with `import icons from '@/constants/icons'; <Image source={icons.search} />`.

### TypeScript

- **`typescript-no-ambient-globals`** — Movie repo's `interfaces/interfaces.d.ts` and Uber's `types/type.d.ts` both use `declare interface` for domain types. The rule pushes back on this for production codebases — fine in a tutorial; hostile to scaling, jump-to-definition, and tree-shaking.

### Data layer

- **`data-fetch-hook-deps`** — All three TS repos roll a generic `useFetch<T>` hook (Restate's `lib/useAppwrite.ts`, Movie's `services/usefetch.ts`, Uber's `lib/fetch.ts`). All three use empty deps `[]`, so `params` changes don't refetch — silent stale data unless `refetch()` is called manually. The rule recommends either correcting the deps or graduating to React Query / SWR.
- **`data-public-env-secrets`** — Aora hardcodes Appwrite credentials in `lib/appwrite.js`. Movie repo bundles a TMDB read-token into `EXPO_PUBLIC_*`. Both are tutorial-acceptable but an active hazard if copy-pasted into production. The rule clarifies which keys are safe in `EXPO_PUBLIC_*` and which must be server-side only.
- **`data-no-silent-errors`** — Universal pattern across the four repos: `try { ... } catch (e) { console.error(e); return null }` plus `Alert.alert` from inside the data layer. The rule advocates a `Result<T>` shape, server-side telemetry (Sentry/PostHog), and decoupling UI from data.

### Styling

- **`styling-nativewind-variants`** — Uber's `components/CustomButton.tsx` is the source: `getBgVariantStyle(bgVariant)` + `getTextVariantStyle(textVariant)` switch helpers, composed via template literal. The rule generalises and cleans up the typing.

### Splash & fonts

- **`splash-fonts-pattern`** — Restate, Aora, Uber all use `SplashScreen.preventAutoHideAsync` + `useFonts` + conditional `hideAsync()` on load. The rule consolidates the three details that matter most: top-level `preventAutoHideAsync`, hiding on `fontError` too, returning `null` while loading.

## Patterns intentionally NOT codified

Some patterns appear across the four repos but were excluded from this skill — either because they're vendor-specific (Clerk, Appwrite, Stripe, Neon, Zustand integrations) and don't belong in a generic React Native / Expo skill, or because they conflict with existing skill rules:

- **Vendor-specific auth flows** (Clerk + `expo-secure-store`, Appwrite OAuth deep-link round-trip, Stripe `paymentSheet` orchestration) → live in their respective vendor skills, not here. The general routing/structure/data rules above still apply when integrating any of them.
- **`<TouchableOpacity>` everywhere** (all four repos) → existing `ui-pressable.md` recommends `<Pressable>`. Kept the existing rule.
- **`<FlatList>` for everything, no `FlashList`** (all four repos) → existing `list-performance-virtualize.md` recommends FlashList. Kept.
- **Inline 500ms `setTimeout` debounce in `useEffect`** (Movie's search) → fine for a single screen but `use-debounce` (used in Restate) is the cleaner approach for re-use.
- **`Math.random()` for driver locations** (Uber's `lib/map.ts`) → tutorial-only, not a generalisable pattern.
- **All-Zustand-stores-in-one-file** (Uber's `store/index.ts`) → fine for a small app; doesn't warrant a rule of its own.

## How to extend this list

When adopting a pattern from one of these repos:

1. Read the original code in context — patterns often look better in isolation than they are at scale.
2. Cross-check against the existing `rules/` folder before adding a new file. Don't duplicate.
3. Add a new rule using `_template.md` and update `SKILL.md`'s Quick Reference + this provenance doc.
4. Where a tutorial pattern is wrong but pedagogically common, a rule that names the anti-pattern (`data-public-env-secrets`, `typescript-no-ambient-globals`) is more valuable than one describing the correct pattern in the abstract.
