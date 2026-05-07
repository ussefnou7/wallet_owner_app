# Quick Reference: Wallet Options API

## What's New

A lightweight wallet options endpoint for dropdown selectors that returns only essential wallet data (id, name, number, branchId).

## Key Files

| File | Purpose |
|------|---------|
| `lib/features/wallets/domain/entities/wallet_option.dart` | Domain model |
| `lib/features/wallets/data/models/wallet_option_model.dart` | JSON serialization |
| `lib/features/wallets/data/services/wallets_remote_data_source.dart` | API client |
| `lib/features/wallets/data/repositories/app_wallets_repository.dart` | Repository |
| `lib/features/reports/presentation/controllers/reports_controller.dart` | Provider |
| `lib/features/reports/presentation/pages/reports_page.dart` | UI integration |
| `docs/WALLET_OPTIONS_API.md` | Backend spec |

## API Endpoint

```
GET /api/v1/wallets/options
GET /api/v1/wallets/options?branchId=<uuid>
```

## Response

```json
{
  "data": [
    {
      "id": "wallet-uuid",
      "name": "Wallet Name",
      "number": "WN-001",
      "branchId": "branch-uuid"
    }
  ]
}
```

## Usage in Code

```dart
// Get all wallets
final wallets = await repository.getWalletOptions();

// Get wallets for a branch
final wallets = await repository.getWalletOptions(branchId: branchId);

// In Riverpod provider
final walletOptionsAsync = ref.watch(
  reportWalletOptionsProvider(selectedBranchId)
);
```

## Branch-Wallet Dependency

```dart
// When branch changes, clear wallet
onBranchChanged: (branchId) {
  setState(() {
    _selectedBranchId = branchId;
    _selectedWalletId = null; // Clear wallet
  });
}
```

## Integration Points

- ✅ Reports filters (implemented)
- ⏳ Transactions filters (ready to implement)
- ⏳ Create transaction (ready to implement)
- ⏳ Profit collection (ready to implement)

## Performance

- **Payload**: 4 fields per wallet (vs. 20+ for full wallet)
- **No Joins**: Backend doesn't join heavy tables
- **Suitable for**: Real-time filtering, frequent API calls

## Testing

```bash
flutter analyze  # Should show 0 errors
```

## Backend Checklist

- [ ] Create WalletOptionProjection interface
- [ ] Create WalletOptionResponse DTO
- [ ] Implement GET /api/v1/wallets/options endpoint
- [ ] Add tenant filtering
- [ ] Add branch filtering with validation
- [ ] Add role-based access control
- [ ] Order results by wallet name
- [ ] Test with various branch/tenant combinations

## Documentation

- `docs/WALLET_OPTIONS_API.md` - Complete backend specification
- `docs/FLUTTER_WALLET_OPTIONS_IMPLEMENTATION.md` - Flutter implementation details
- `docs/IMPLEMENTATION_SUMMARY.md` - Overview and checklist
