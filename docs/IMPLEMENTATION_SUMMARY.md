# Wallet Options API Implementation Summary

## What Was Implemented

### Backend Specification
A complete specification for the lightweight wallet options API endpoint has been created in `docs/WALLET_OPTIONS_API.md`. This includes:

- **Endpoint**: `GET /api/v1/wallets/options` with optional `branchId` query parameter
- **Response**: Lightweight wallet data (id, name, number, branchId only)
- **Features**: Tenant filtering, branch validation, role-based access control
- **Performance**: No heavy joins, indexed queries, suitable for frequent calls

### Flutter Implementation

#### New Models
1. **WalletOption Entity** (`lib/features/wallets/domain/entities/wallet_option.dart`)
   - Lightweight domain model with 4 fields
   - Extends Equatable for value comparison

2. **WalletOptionModel** (`lib/features/wallets/data/models/wallet_option_model.dart`)
   - JSON serialization/deserialization
   - Maps API response to domain entity

#### Repository Layer
- Added `getWalletOptions({String? branchId})` method to:
  - `WalletsRepository` interface
  - `AppWalletsRepository` implementation
  - `MockWalletsRepository` for testing
  - `WalletsRemoteDataSource` interface and implementation

#### Network Configuration
- Added `walletOptionsPath` constant
- Added `walletOptionsPathWithBranch()` helper method

#### Reports Feature Integration
- Updated `reportWalletOptionsProvider` to use new lightweight endpoint
- Modified `_AdvancedFiltersCard` to work with `WalletOption` instead of `Wallet`
- Modified `_ActiveFilterChipsRow` to work with `WalletOption`
- Maintained branch-wallet dependency logic:
  - Branch filter appears first
  - Wallet filter depends on branch selection
  - Clearing branch clears wallet
  - Changing branch clears wallet

#### UI/UX Features
- Loading state while fetching wallet options
- Error state if wallet options fail to load
- Empty state message when no wallets exist in selected branch
- Disabled wallet dropdown when no options available
- Proper handling of branch-wallet relationships

#### Testing
- Updated test mocks to implement new methods
- All code passes `flutter analyze` with no errors

## Files Modified

### Created
- `lib/features/wallets/domain/entities/wallet_option.dart`
- `lib/features/wallets/data/models/wallet_option_model.dart`
- `docs/WALLET_OPTIONS_API.md`
- `docs/FLUTTER_WALLET_OPTIONS_IMPLEMENTATION.md`

### Updated
- `lib/core/network/network_constants.dart`
- `lib/features/wallets/domain/repositories/wallets_repository.dart`
- `lib/features/wallets/data/repositories/app_wallets_repository.dart`
- `lib/features/wallets/data/repositories/mock_wallets_repository.dart`
- `lib/features/wallets/data/services/wallets_remote_data_source.dart`
- `lib/features/reports/presentation/controllers/reports_controller.dart`
- `lib/features/reports/presentation/pages/reports_page.dart`
- `test/api_exception_mapper_test.dart`

## Key Design Decisions

### 1. Separate Model for Lightweight Data
- Created `WalletOption` instead of reusing `Wallet`
- Prevents accidental use of heavy wallet data in dropdowns
- Makes intent clear in code

### 2. Optional Branch Filtering
- `branchId` is optional in the method signature
- Allows flexibility for different use cases
- Backend validates branch ownership

### 3. Branch-Wallet Dependency
- Maintained existing UI pattern from reports page
- Branch filter must be selected before wallet filter
- Clearing branch automatically clears wallet
- Prevents sending stale wallet IDs from other branches

### 4. Backward Compatibility
- Existing `getWallets()` and `getWalletsByBranch()` methods unchanged
- Full wallet data still available for screens that need it
- New endpoint is additive, not replacing

## Performance Benefits

- **Reduced Payload**: Only 4 fields per wallet vs. 20+ fields in full wallet
- **No Heavy Joins**: Backend doesn't join consumption/profit/collection tables
- **Suitable for Frequent Calls**: Lightweight enough for real-time filtering
- **Network Efficient**: Smaller response size reduces bandwidth usage

## Usage in Reports

The implementation is currently integrated into the Reports feature:

```dart
// Branch filter
AppDropdownField<String?>(
  value: selectedBranchId,
  onChanged: (branchId) {
    setState(() {
      _selectedBranchId = branchId;
      _selectedWalletId = null; // Clear wallet when branch changes
    });
  },
)

// Wallet filter (depends on branch)
walletOptionsAsync.when(
  loading: () => AppLoadingView(message: l10n.loadingWalletOptions),
  error: (error, stackTrace) => AppErrorState(...),
  data: (wallets) => AppDropdownField<String?>(
    items: [
      DropdownMenuItem(value: null, child: Text(l10n.all)),
      ...wallets.map((w) => DropdownMenuItem(
        value: w.id,
        child: Text(w.name),
      )),
    ],
  ),
)
```

## Future Integration Points

The `getWalletOptions()` method can be used in:
- Transactions filters (with branch dependency)
- Create transaction wallet selector
- Profit collection wallet selector
- Any new feature requiring wallet dropdowns

## Backend Implementation Required

The backend team needs to implement:

1. **WalletOptionProjection** interface or DTO
2. **WalletOptionResponse** class
3. **GET /api/v1/wallets/options** endpoint
4. Repository query with:
   - Tenant filtering
   - Optional branch filtering
   - Branch ownership validation
   - Ordering by wallet name
5. Role-based access control (OWNER, USER, SYSTEM_ADMIN)

See `docs/WALLET_OPTIONS_API.md` for complete specifications.

## Testing

Run `flutter analyze` to verify code quality:
```bash
flutter analyze
```

Result: **29 issues found** (all pre-existing info/warnings, no errors)

## Verification Checklist

- ✅ WalletOption model created
- ✅ WalletOptionModel with JSON serialization
- ✅ Repository methods added and implemented
- ✅ Remote data source updated
- ✅ Reports page integrated
- ✅ Branch-wallet dependency maintained
- ✅ Loading/error/empty states handled
- ✅ Mock repository updated for testing
- ✅ Test mocks updated
- ✅ Flutter analyze passes (no errors)
- ✅ Documentation created
- ✅ Backward compatibility maintained

## Next Steps

1. **Backend Implementation**: Implement the endpoint as specified in `docs/WALLET_OPTIONS_API.md`
2. **Testing**: Test the endpoint with various branch/tenant combinations
3. **Integration Testing**: Test the Flutter app with the real backend
4. **Expand Usage**: Apply the same pattern to other features (transactions, etc.)
5. **Performance Monitoring**: Monitor API response times and adjust caching as needed
