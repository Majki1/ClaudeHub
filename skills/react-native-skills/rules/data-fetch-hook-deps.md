---
title: useFetch hooks must track their parameters in effect deps
impact: HIGH
impactDescription: Stops the silent "param changes don't refetch" bug that plagues hand-rolled data hooks
tags: data, hooks, react
---

## useFetch hooks must track their parameters in effect deps

**Impact: HIGH**

A common tutorial pattern is a generic `useFetch<T>(fn, params)` hook with `useEffect(() => fetchData(), [])`. The empty deps array means the fetch runs once and never reacts when `params` change — so search inputs, filter changes, and pagination silently return stale data unless the caller manually invokes `refetch()`.

**Incorrect (params change but data doesn't):**

```ts
export function useFetch<T, P>({ fn, params, skip }: { fn: (p: P) => Promise<T>; params: P; skip?: boolean }) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(false);

  const fetchData = async (p: P) => {
    setLoading(true);
    setData(await fn(p));
    setLoading(false);
  };

  useEffect(() => {
    if (!skip) fetchData(params);
  }, []); // ❌ ignores params

  return { data, loading, refetch: fetchData };
}
```

**Correct option A (track params, stable-stringify to dedupe):**

```ts
useEffect(() => {
  if (!skip) fetchData(params);
}, [JSON.stringify(params), skip]);
```

**Correct option B (just use a real query library):**

```ts
import { useQuery } from '@tanstack/react-query';

const { data, isLoading, refetch } = useQuery({
  queryKey: ['movies', query],
  queryFn: () => fetchMovies({ query }),
  enabled: !skip,
});
```

For anything beyond a single-page demo, option B is the right answer — you also get caching, retries, request dedup, and stale-while-revalidate for free. Use option A only when you genuinely need a hand-rolled hook (e.g. zero-dep constraints).

Common partner bug: returning `null`/`[]` on error and `console.error`'ing — see `data-no-silent-errors`.
