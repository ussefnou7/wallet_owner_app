# Wallet Options Architecture

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter UI Layer                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Reports Page (_AdvancedFiltersCard)                │  │
│  │  - Branch Dropdown                                  │  │
│  │  - Wallet Dropdown (depends on branch)              │  │
│  │  - Active Filter Chips                              │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                  Presentation Layer                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Reports Controller                                 │  │
│  │  - reportWalletOptionsProvider                      │  │
│  │  - Calls repository.getWalletOptions(branchId)      │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                   Domain Layer                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  WalletsRepository (interface)                       │  │
│  │  - getWalletOptions({String? branchId})             │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    Data Layer                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  AppWalletsRepository (implementation)               │  │
│  │  - Delegates to WalletsRemoteDataSource              │  │
│  │  - Unwraps ApiResult<T>                              │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  WalletsRemoteDataSource                             │  │
│  │  - DioWalletsRemoteDataSource                        │  │
│  │  - Calls API endpoint                                │  │
│  │  - Maps response to WalletOptionModel                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                   Network Layer                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ApiClient (Dio)                                     │  │
│  │  GET /api/v1/wallets/options?branchId=<uuid>        │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                   Backend API                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  GET /api/v1/wallets/options                         │  │
│  │  - Tenant filtering                                 │  │
│  │  - Branch filtering (optional)                       │  │
│  │  - Branch validation                                 │  │
│  │  - Role-based access control                         │  │
│  │  - Returns lightweight wallet data                   │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Model Hierarchy

```
WalletOption (Domain Entity)
├── id: String
├── name: String
├── number: String
└── branchId: String
    ↓
WalletOptionModel (Data Model)
├── Extends WalletOption
├── fromJson(Map<String, dynamic>)
└── toJson() → Map<String, dynamic>
```

## Repository Pattern

```
WalletsRepository (Interface)
├── getWallets()
├── getWalletsByBranch(String branchId)
├── getWalletById(String walletId)
├── getWalletOptions({String? branchId})  ← NEW
├── createWallet(...)
├── updateWallet(...)
├── collectProfit(...)
└── deleteWallet(String walletId)
    ↓
AppWalletsRepository (Implementation)
├── Delegates to WalletsRemoteDataSource
├── Unwraps ApiResult<T> to T or throws
└── Handles error mapping
    ↓
WalletsRemoteDataSource (Interface)
├── getWallets()
├── getWalletsByBranch(String branchId)
├── getWalletById(String walletId)
├── getWalletOptions({String? branchId})  ← NEW
├── createWallet(...)
├── updateWallet(...)
├── collectProfit(...)
└── deleteWallet(String walletId)
    ↓
DioWalletsRemoteDataSource (Implementation)
├── Uses ApiClient (Dio)
├── Handles HTTP requests
├── Maps responses to models
└── Handles exceptions
```

## Provider Pattern

```
reportWalletOptionsProvider
├── Type: FutureProvider.family<List<WalletOption>, String?>
├── Parameter: branchId (String?)
├── Logic:
│   ├── Get WalletsRepository
│   ├── Normalize branchId
│   └── Call repository.getWalletOptions(branchId: ...)
└── Returns: AsyncValue<List<WalletOption>>
    ├── AsyncLoading
    ├── AsyncError
    └── AsyncData<List<WalletOption>>
```

## UI Integration

```
Reports Page
├── State Variables
│   ├── _selectedBranchId: String?
│   ├── _selectedWalletId: String?
│   └── _filtersExpanded: bool
├── Providers
│   ├── branchesControllerProvider
│   ├── reportWalletOptionsProvider(_selectedBranchId)
│   └── usersControllerProvider
└── Widgets
    ├── _AdvancedFiltersCard
    │   ├── Branch Dropdown
    │   │   └── onChanged: (branchId) {
    │   │       _selectedBranchId = branchId
    │   │       _selectedWalletId = null  // Clear wallet
    │   │     }
    │   └── Wallet Dropdown (depends on branch)
    │       ├── Loading state
    │       ├── Error state
    │       ├── Empty state (no wallets in branch)
    │       └── Items from walletOptionsAsync
    └── _ActiveFilterChipsRow
        ├── Shows active branch filter
        └── Shows active wallet filter
```

## State Management

```
Branch Selection Changes
    ↓
onBranchChanged callback
    ↓
setState(() {
  _selectedBranchId = newBranchId
  _selectedWalletId = null  // Clear wallet
})
    ↓
reportWalletOptionsProvider re-evaluates
    ↓
getWalletOptions(branchId: newBranchId) called
    ↓
Wallet dropdown updates with new options
```

## Error Handling

```
API Call
├── Success (200)
│   └── Parse response → List<WalletOptionModel>
├── Client Error (4xx)
│   ├── 400: Invalid branchId format
│   ├── 403: Branch doesn't belong to tenant
│   └── 404: No wallets found
└── Server Error (5xx)
    └── Show error state in UI
```

## Performance Considerations

```
Network
├── Request Size: ~50 bytes (branchId query param)
└── Response Size: ~200 bytes per wallet (4 fields)

Backend
├── Query: Simple WHERE clause (no joins)
├── Indexes: tenantId, branchId, name
└── Caching: 5-10 minutes per tenant/branch

Frontend
├── Provider Caching: Automatic (Riverpod)
├── UI Caching: None (real-time updates)
└── Memory: Minimal (4 fields per wallet)
```

## Backward Compatibility

```
Existing Methods (Unchanged)
├── getWallets() → List<Wallet>
├── getWalletsByBranch(String) → List<Wallet>
├── getWalletById(String) → Wallet
├── createWallet(...) → Wallet
├── updateWallet(...) → Wallet
├── collectProfit(...) → Wallet?
└── deleteWallet(String) → void

New Method
└── getWalletOptions({String?}) → List<WalletOption>

Usage
├── Full wallet data: Use existing methods
└── Dropdowns/filters: Use new method
```

## Testing Strategy

```
Unit Tests
├── WalletOptionModel.fromJson()
├── WalletOptionModel.toJson()
└── Repository methods

Integration Tests
├── API endpoint with various branches
├── Branch validation
├── Role-based access control
└── Error scenarios

UI Tests
├── Branch-wallet dependency
├── Loading states
├── Error states
└── Empty states
```
