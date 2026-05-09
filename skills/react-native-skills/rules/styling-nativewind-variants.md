---
title: Compose NativeWind variants via small switch helpers, not nested ternaries
impact: MEDIUM
impactDescription: Readable variants for buttons/inputs; easy to add new ones
tags: styling, nativewind, components
---

## Compose NativeWind variants via small switch helpers, not nested ternaries

**Impact: MEDIUM**

Reusable primitives like `<CustomButton>` need to support multiple visual variants (primary, secondary, danger, outline, success). A ternary chain inside JSX gets unreadable fast and silently breaks when a new variant is added. Extract a small helper per axis (`bg`, `text`, `border`) and compose with template literals.

**Incorrect (nested ternaries — adding "warning" requires edits in three places):**

```tsx
<TouchableOpacity
  className={`rounded-full p-3 ${
    variant === 'primary' ? 'bg-primary-500' :
    variant === 'danger' ? 'bg-red-500' :
    variant === 'outline' ? 'bg-transparent border border-neutral-300' :
    'bg-secondary-500'
  } ${
    variant === 'outline' ? 'text-black' : 'text-white'
  }`}
>
```

**Correct (helpers, exhaustive switch):**

```tsx
// components/CustomButton.tsx
import { TouchableOpacity, Text, TouchableOpacityProps } from 'react-native';

type Variant = 'primary' | 'secondary' | 'danger' | 'outline' | 'success';

const bgFor = (v: Variant) => {
  switch (v) {
    case 'primary':   return 'bg-primary-500';
    case 'secondary': return 'bg-secondary-500';
    case 'danger':    return 'bg-red-500';
    case 'success':   return 'bg-green-500';
    case 'outline':   return 'bg-transparent border border-neutral-300';
  }
};

const textFor = (v: Variant) => (v === 'outline' ? 'text-black' : 'text-white');

interface CustomButtonProps extends TouchableOpacityProps {
  title: string;
  variant?: Variant;
  IconLeft?: React.ComponentType;
  IconRight?: React.ComponentType;
}

export function CustomButton({
  title,
  variant = 'primary',
  IconLeft,
  IconRight,
  className,
  ...rest
}: CustomButtonProps) {
  return (
    <TouchableOpacity
      className={`flex-row items-center justify-center rounded-full p-3 ${bgFor(variant)} ${className ?? ''}`}
      {...rest}
    >
      {IconLeft && <IconLeft />}
      <Text className={`font-semibold ${textFor(variant)}`}>{title}</Text>
      {IconRight && <IconRight />}
    </TouchableOpacity>
  );
}
```

Two reasons the helpers beat ternaries:

1. **Exhaustive `switch` over a string-literal union** — TypeScript yells if you add a variant and forget to handle it.
2. **Single responsibility per helper** — a designer adding "warning" touches only `bgFor`.

For more complex compounds (size × variant × disabled state), graduate to `tailwind-variants` or `cva` rather than expanding the helpers. See also `ui-pressable` for why `<Pressable>` often beats `<TouchableOpacity>` for production.
