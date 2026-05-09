---
title: Hold the splash screen until fonts (and other critical assets) load
impact: MEDIUM
impactDescription: No FOUT, no flash of unstyled text, no janky first paint
tags: splash, fonts, expo
---

## Hold the splash screen until fonts (and other critical assets) load

**Impact: MEDIUM**

Custom fonts load asynchronously. If your root layout renders before they're ready, users see a flash of unstyled text (FOUT) and a layout shift. Use `SplashScreen.preventAutoHideAsync()` at module load + `SplashScreen.hideAsync()` once `useFonts` resolves to keep the splash up until paint is correct.

**Incorrect (renders immediately; one frame of system font, then snap to custom):**

```tsx
// app/_layout.tsx
import { useFonts } from 'expo-font';
import { Stack } from 'expo-router';

export default function RootLayout() {
  const [loaded] = useFonts({ Rubik: require('../assets/fonts/Rubik-Regular.ttf') });
  return <Stack />; // ❌ renders before fonts ready
}
```

**Correct (splash held; first render is already styled):**

```tsx
// app/_layout.tsx
import { useFonts } from 'expo-font';
import { SplashScreen, Stack } from 'expo-router';
import { useEffect } from 'react';

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [fontsLoaded, fontError] = useFonts({
    'Rubik-Regular': require('../assets/fonts/Rubik-Regular.ttf'),
    'Rubik-Bold': require('../assets/fonts/Rubik-Bold.ttf'),
    'Rubik-SemiBold': require('../assets/fonts/Rubik-SemiBold.ttf'),
  });

  useEffect(() => {
    if (fontsLoaded || fontError) SplashScreen.hideAsync();
  }, [fontsLoaded, fontError]);

  if (!fontsLoaded && !fontError) return null;

  return <Stack screenOptions={{ headerShown: false }} />;
}
```

Three details that matter:

1. **Call `preventAutoHideAsync()` at module top-level**, not inside the component — the splash is already auto-hiding by the time the component mounts otherwise.
2. **Hide on `fontError` too**, not just success — a bad font file would leave you stuck on the splash forever.
3. **Return `null` while loading**. Don't return a custom loader; the native splash is already on screen.

If you also need to wait on auth state (`getCurrentUser()`) or remote config, gate the same way: keep the splash up until *all* critical async work resolves, then hide once.

For prebuilt fonts where you don't need a flash-free first paint (e.g. internal tools), the `expo-font` config plugin embeds fonts into the native build and avoids this dance entirely — see `fonts-config-plugin`.

Reference: [Expo — SplashScreen](https://docs.expo.dev/versions/latest/sdk/splash-screen/)
