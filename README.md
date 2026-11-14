# Privacy Vault

A Flutter app for keeping receipts safe, tracking warranties before they
expire, and seeing where your money goes — all in one place.

## What it does

- **Dashboard** — greeting, receipt / warranty / total-spent summary cards,
  an expiring-soon strip, and your most recent receipts.
- **Receipts** — browse all receipts with live search and category filters;
  tap one to see its full detail, swipe to delete (with Undo).
- **Add Receipt** — a validated form (name, price, category, date) with a
  camera / gallery photo attach, stored with the receipt.
- **Warranty Reminders** — every warranty sorted by days left, with
  expired / soon / safe badges and a reminder bell per item.
- **Spending Insights** — total spent, a monthly bar chart, and a
  category breakdown.
- **Vault Records** — your privacy summary and warranty cards.

The app ships with 4 sample receipts and 3 sample warranties so you can
try every screen right away. Data is kept in memory for the session — there
is no database or account.

## Tech

- Flutter & Dart, plain `StatefulWidget`s — no state-management packages
- `image_picker` for receipt photos
- Dark navy + mint theme, centralized in `lib/theme.dart` (change the
  colors there to reskin the whole app)

## How to run it

```bash
flutter pub get
flutter run -d chrome
```

Runs on web, Android, iOS, Windows, macOS and Linux. For Android / iOS,
run `flutter run` with a device or emulator attached instead of `-d chrome`.

## Project structure

```
lib/
├── main.dart                  <- entry point
├── main_screen.dart           <- bottom navigation + shared receipts list
├── theme.dart                 <- colors, fonts, shared card style
├── date_utils.dart            <- date parsing / currency formatting
├── models/
│   ├── receipt.dart           <- Receipt model (+ photo bytes)
│   └── warranty.dart          <- Warranty model (+ days-left)
├── home_screen.dart           <- dashboard
├── receipt_list_screen.dart   <- receipts + search + category filters
├── add_receipt_screen.dart    <- add-receipt form + photo attach
├── receipt_detail_screen.dart <- receipt detail + photo
├── vault_records_screen.dart  <- privacy summary + warranty cards
├── warranty_reminders_screen.dart
└── insights_screen.dart       <- spending insights + monthly chart
assets/images/                 <- privacy / receipt / warranty artwork
assignment/                    <- original screen-plan documents
```

`ASSIGNMENT_README.md` documents the assignment screens and the
navigation / stateful-widget changes made on top of the original brief.
