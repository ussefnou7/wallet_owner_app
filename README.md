# Ta2feela

A production-oriented Flutter mobile application for managing wallet transactions in a multi-tenant SaaS environment.

The app is designed for businesses that manage multiple wallets, users, and branches. It does not execute financial transactions directly. Instead, it allows authenticated users to record and monitor transactions that already happened in real life.

The current version supports role-based experiences under one unified Ta2feela brand.

---

## Features

### Dashboard

* Overview KPI cards
* Total Profit
* Active Wallets
* Total Transactions
* Total Credit
* Total Debit
* Recent Transactions preview
* Quick Actions
* Bottom navigation

### Wallets

* Wallets list
* Search support
* Status and balance display
* Branch and transaction count information

### Transactions

* Create Transaction form
* Credit / Debit selection
* Wallet selection
* Date picker
* Amount validation
* Transaction history list
* Search and filter support

### Reports

* Financial report entry points
* Operational report entry points
* PDF and Excel export placeholders

### Management

* Users management page
* Branches management page
* Plans page
* Request Renewal page
* Settings placeholder

---

## Architecture

The project uses a feature-first clean architecture approach.

```text
lib/
├── app/
│   ├── app.dart
│   ├── bootstrap.dart
│   └── router/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── wallets/
│   ├── transactions/
│   ├── reports/
│   ├── users/
│   ├── branches/
│   ├── plans/
│   └── settings/
```

Each feature follows the same structure:

```text
feature/
├── data/
├── domain/
└── presentation/
```

This keeps the project scalable and ready for future backend integration.

---

## Tech Stack

Built with:

* Flutter
* Dart
* Riverpod
* go_router
* Dio
* flutter_secure_storage
* shared_preferences
* Equatable
* intl

---

## Current App Flow

### Authentication

The current implementation uses a mock login flow and local session abstraction.

Planned future support:

* Real backend authentication
* Secure token refresh
* Role-based routing
* Multi-tenant session handling

### App Flow

1. Login
2. Dashboard
3. Wallets
4. Create Transaction
5. Transaction History
6. Reports
7. Users / Branches
8. Plans / Renewal

---

## Running the Project

### Requirements

* Flutter 3.41+
* Dart 3+
* Android Studio or VS Code
* Android SDK installed

### Run locally

```bash
flutter pub get
flutter run
```

### Analyze

```bash
flutter analyze
```

### Test

```bash
flutter test
```

---

## Supported Platforms

* Android
* iOS

The app is designed to remain compatible with older Android and iPhone devices where reasonably possible.

---

## Current Status

Implemented:

* App shell
* Authentication skeleton
* Dashboard
* Wallets module
* Create Transaction module
* Transactions history
* Reports landing page
* Users module
* Branches module

In progress:

* Plans module
* Request Renewal module
* Settings refinement

Planned:

* Real backend integration
* Offline-safe behavior
* API environment configuration
* Export generation
* Advanced reporting
* Additional role-based experience refinements
* Push notifications

---

## Testing

The project already includes widget tests for:

* Login validation
* Wallets flow
* Transactions filtering
* Users filtering

Future work:

* More controller/provider tests
* Repository tests
* Integration tests

---

## Roadmap

### Phase 1

* App foundation
* Routing
* Authentication shell
* Dashboard

### Phase 2

* Shared design system
* Login refinement
* Dashboard refinement

### Phase 3

* Wallets
* Create Transaction

### Phase 4

* Transaction History
* Reports

### Phase 5

* Users
* Branches

### Phase 6

* Plans
* Renewal

### Next

* Settings
* Backend integration
* USER role flow

---

## Screenshots

*Add screenshots and GIFs here once the UI is finalized.*

Example:

```text
screenshots/
├── login.png
├── dashboard.png
├── wallets.png
├── transactions.png
└── reports.png
```

---

## Contributing

This project is currently under active development.

Suggestions, refactors, and architectural improvements are welcome.

---

## License

Private project – all rights reserved.
