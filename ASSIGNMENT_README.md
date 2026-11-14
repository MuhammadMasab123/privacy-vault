# Privacy Vault — Flutter Assignment

## Included screens
1. Home Screen — overview, receipt/warranty counts, and privacy vault summary.
2. Receipt List Screen — four sample purchase receipt cards using a reusable `ReceiptCard` widget.
3. Add Receipt Screen — look-only receipt form; the Save button shows a demo message and does not store data.
4. Vault Records Screen — privacy summary and reusable warranty cards.

## Assignment constraints
- One `MaterialApp`; debug banner disabled.
- All four screens are `StatelessWidget`s.
- No navigation, database, API, or persistent saving is implemented. Screens are selected from `main.dart` only for separate demonstrations/screenshots.
- Three PNG images are registered in `pubspec.yaml` under `assets/images/`.
- A custom Privacy Vault shield launcher icon is included for Android at all five standard density sizes.
- Scrollable screen bodies help avoid vertical overflow on smaller screens.

## Update — navigation & state (added 2026-11-10)

The original "no navigation" constraint above was lifted by the project
owner. The app now has:

- **Bottom navigation** (`lib/main_screen.dart`, a `StatefulWidget`) with
  four tabs: Home, Receipts, Add, Vault. It also owns the shared receipts
  list, so adding or deleting a receipt updates every screen.
- **Navigation**: Home quick-action cards jump to the matching tab; tapping
  a receipt opens a detail page (`lib/receipt_detail_screen.dart`) with
  `Navigator.push`; saving a receipt jumps to the Receipts tab.
- **Stateful widgets**: `MainScreen` (tab + receipts state),
  `AddReceiptScreen` (validated form with controllers, date picker and
  category picker — saving really adds the receipt), `ReceiptListScreen`
  (live search filter + swipe-to-delete with Undo), `VaultRecordsScreen`
  ("show active only" switch + expandable warranty cards).
- **Model**: `lib/models/receipt.dart` holds the shared `Receipt` class.
- Home overview counts are now live (receipts = actual list size).

## Run
Open this folder (the one containing `pubspec.yaml`) in VS Code. In its terminal run:

```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

If Chrome crashes or reports memory errors, close extra Chrome tabs, stop other Flutter runs, then retry.

## Show each screen for screenshots (no navigation)
Open `lib/main.dart`. The `home:` line currently selects `HomeScreen`. For each screenshot, change only the screen class on that line, save, and let hot reload update the app:

- `home: const HomeScreen(),`
- `home: const ReceiptListScreen(),` (add `import 'receipt_list_screen.dart';`)
- `home: const AddReceiptScreen(),` (add `import 'add_receipt_screen.dart';`)
- `home: const VaultRecordsScreen(),` (add `import 'vault_records_screen.dart';`)

Take one screenshot for each screen. Restore `home: const HomeScreen(),` and its import before submitting. Do not add Navigator routes; the assignment says navigation is not allowed yet.
