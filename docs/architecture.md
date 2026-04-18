# Architecture Overview

This app is a Flutter owner-facing client for wallet operations and reporting. The current phase is intentionally frontend-first: authentication, wallets, users, branches, reports, and transactions run on mock repositories with local session persistence only.

## Structure

- `lib/app`: application bootstrap, Riverpod container setup, and `go_router` navigation.
- `lib/core`: shared theme, constants, storage wrappers, utilities, and reusable widgets.
- `lib/features/<feature>`: feature-scoped domain, data, and presentation code.

## Runtime Flow

`lib/app/bootstrap.dart` builds the dependency graph, wires mock repositories, and restores any saved session before the widget tree starts. `authControllerProvider` owns the authenticated session state, and `app_router.dart` uses that state to gate access to owner routes.

## Feature Pattern

Each feature keeps the existing layered split:

- `domain`: entities and repository contracts
- `data`: mock repositories, models, and local data sources
- `presentation`: Riverpod controllers/providers plus pages and widgets

This keeps UI code isolated from data sources and allows later backend integration to replace repository implementations without changing page structure.

## Current Boundaries

- Session data is stored locally through `SharedPreferences` and secure storage wrappers.
- Dashboard and management pages consume mock repositories only.
- No backend integration, sync engine, or remote persistence is included in this phase.
