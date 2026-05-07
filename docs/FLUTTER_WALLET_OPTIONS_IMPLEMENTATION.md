# Flutter Wallet Options Implementation

## Overview

This implementation adds a lightweight wallet options API integration to Flutter for use in dropdown selectors and filters. The new `WalletOption` model contains only essential fields (id, name, number, branchId) and is used instead of the full `Wallet` entity in UI components.

## Files Created

### Domain Layer

**`lib/features/wallets/domain/entities/wallet_option.dart`**
- New `WalletOption` entity with minimal fields
- Extends `Equatable` for value comparison

### Data Layer

**`lib/features/wallets/data/models/wallet_option_model.dart`**
- `WalletOptionModel` for JSON serialization
- Implements `fromJson()` and `toJson()` methods

### Network Configuration

**`lib/core/network/network_constants.dart`** (updated)
- Added `walletOptionsPath` constant: `/api/v1/wallets/options`
- Added `walletOptionsPathWithBranch()` helper method for branch filtering

### Repository Layer

**`lib/features/wallets/domain/repositories/wallets_repository.dart`** (updated)
- Added `getWalletOptions({String? branchId})` method signature

**`lib/features/wallets/data/repositories/app_wallets_repository.dart`** (updated)
- Implemented `getWalletOptions()` method

**`lib/features/wallets/data/repositories/mock_wallets_repository.dart`** (updated)
- Implemented mock `getWalletOptions()` for testing

### Remote Data Source

**`lib/features/wallets/data/services/wallets_remote_data_source.dart`** (updated)
- Added `getWalletOptions({String? branchId})` method to interface
- Implemented in `DioWalletsRemoteDataSource` with proper error handling

### Reports Feature Integration

**`lib/features/reports/presentation/controllers/reports_controller.dart`** (updated)
- Updated `reportWalletOptionsProvider` to use `getWalletOptions()` instead of full wallet data
- Simplified provider logic for branch filtering

**`lib/features/reports/presentation/pages/reports_page.dart`** (updated)
- Changed wallet type from `Wallet` to `WalletOption` throughout
- Updated `_AdvancedFiltersCard` to use `WalletOption`
- Updated `_ActiveFilterChipsRow` to use `WalletOption`
- Updated `_walletLabel()` helper function to work with `WalletOption`
- Maintained branch-wallet dependency logic (clear wallet when branch changes)

### Test Updates

**`test/api_exception_mapper_test.dart`** (updated)
- Added `getWalletOptions()` and `getWalletsByBranch()` implementations to `_FakeWalletsRemoteDataSource`

## Key Features

### Branch-Wallet Dependency

The implementation maintains the existing branch-wallet dependency logic:

1. **Branch Filter First**: Branch dropdown appears before wallet dropdown
2. **Clear on Change**: When branch changes, selected wallet is cleared
3. **Load Wallets**: Wallets are loaded for the selected branch
4. **Clear Branch**: When branch is cleared, wallet is also cleared and all wallets are loaded
5. **Prevent Stale Data**: Wallet ID from another branch is never sent

### Loading States

- Loading indicator shown while fetching wallet options
- Error state displayed if wallet options fail to load
- Empty state shown if no wallets exist in selected branch
- Wallet dropdown disabled when no options are available

### Performance Optimizations

- Lightweight payload (only 4 fields per wallet)
- No heavy joins or calculations on backend
- Suitable for frequent API calls in filter dropdowns
- Reduced network bandwidth compared to full wallet data

## Usage

### In Reports Filters

```dart
// Branch filter
AppDropdownField<String?>(
  value: selectedBranchId,
  label: l10n.branchName,
  items: [...branches],
  onChanged: (branchId) {
    setState(() {
      _selectedBranchId = branchId;
      _selectedWalletId = null; // Clear wallet when branch changes
    });
    _applyFilters();
  },
)

// Wallet filter (depends on branch)
walletOptionsAsync.when(
  loading: () => AppLoadingView(message: l10n.loadingWalletOptions),
  error: (error, stackTrace) => AppErrorState(
    message: l10n.unableToLoadWalletOptions,
    compact: true,
  ),
  data: (wallets) => AppDropdownField<String?>(
    value: selectedWalletId,
    label: l10n.wallet,
    hintText: wallets.isEmpty && _normalizeString(selectedBranchId) != null
        ? l10n.noWalletsInBranch
        : l10n.selectWallet,
    items: [
      DropdownMenuItem<String?>(
        value: null,
        child: Text(l10n.all),
      ),
      ...wallets.map((wallet) => DropdownMenuItem<String?>(
        value: wallet.id,
        child: Text(wallet.name),
      )),
    ],
    onChanged: wallets.isEmpty ? null : onWalletChanged,
  ),
)
```

### In Other Features

The `getWalletOptions()` method can be used in:
- Transactions filters
- Create transaction wallet selector
- Profit collection wallet selector
- Any other UI component needing wallet dropdowns

## Localization Strings Required

The following localization strings are already used in the reports page:
- `loadingWalletOptions` - Loading message
- `unableToLoadWalletOptions` - Error message
- `noWalletsInBranch` - Empty state message

## Testing

Run `flutter analyze` to verify code quality:

```bash
flutter analyze
```

All errors should be resolved. Some info-level suggestions may remain (e.g., deprecated `withOpacity` usage in other parts of the codebase).

## Migration Path

### For Existing Screens

1. **Wallets Screen**: Continue using `getWallets()` (needs full wallet data)
2. **Wallet Details**: Continue using `getWalletById()` (needs full wallet data)
3. **Reports/Transactions Filters**: Now use `getWalletOptions()` (lightweight)
4. **Wallet Cards**: Continue using `getWallets()` (needs balance/profit data)

### For New Features

Use `getWalletOptions()` for any new dropdown/select UI components that only need wallet identification.

## Backend Implementation Required

See `docs/WALLET_OPTIONS_API.md` for complete backend specification including:
- Endpoint definition
- Response schema
- Repository query implementation
- Role-based access control
- Branch validation
- Performance considerations
