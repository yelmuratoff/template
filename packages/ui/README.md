# ui

The design system of the workspace: theme contracts and ready-made light/dark
themes, plus the reusable widget set. Widgets are **theme-driven and
app-agnostic** — they read every color and text style from the theme and take
strings/images as parameters, so the package carries no l10n, asset, or
business coupling back to the app.

## Theme

- **`IColors`** / **`ITextStyles`** — `ThemeExtension` contracts for the design
  tokens that don't fit Material's `ColorScheme`/`TextTheme`. `ThemeColors`
  and the text-style implementation fill them for the bundled light
  (`themes/light.dart`) and dark (`themes/dark.dart`) themes.
- **`ThemeDataX`** — `ThemeData` extension with shorthand accessors, so widget
  code reads tokens from `Theme.of(context)` instead of raw `Color`/`TextStyle`
  literals.

The app builds its `ThemeData` via `ColorScheme.fromSeed` and attaches these
extensions; widgets in this package (and in features) only ever read them.

## Widgets

| Widget | Purpose |
|---|---|
| `AppButton` | Themed button used across features |
| `OutlinedTextfield` | Standard text input |
| `AppDialogs` | Dialog presenters (confirmations, pickers) |
| `Toaster` | Toast notifications |
| `BottomSheetBody` / `DragHandle` | Modal bottom-sheet building blocks |
| `Shimmer` / `ShimmerBox` | Loading placeholders |
| `AppLoadingIndicator` | Progress indicator |
| `ColumnBuilder` / `RowBuilder` / `WrapBuilder` | Index-based flex/wrap builders |
| `RestartWrapper` | Rebuilds the subtree with a new key (app restart, e.g. on environment switch) |
| `nil` / `Nil` | True no-op widget — cheaper than `SizedBox.shrink()` when nothing should render |

## Usage

```yaml
dependencies:
  ui:
    path: ../ui
```

```dart
import 'package:ui/ui.dart';
```

## Conventions

- New widgets stay theme-driven: read tokens through `Theme.of(context)` /
  the `IColors`/`ITextStyles` extensions, never hardcode colors or styles.
- No imports from the app or other workspace packages — `ui` depends only on
  Flutter and small presentation utilities (`gap`, `auto_size_text`,
  `iconsax_plus`, `flutter_easyloading`, `equatable`).
- App-specific composite UI (screens, scope-aware widgets) belongs in the
  app's feature folders, not here.
