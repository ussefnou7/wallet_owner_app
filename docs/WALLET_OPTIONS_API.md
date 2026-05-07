# Wallet Options API Specification

## Overview
The Wallet Options API provides a lightweight endpoint for retrieving wallet metadata (id, name, number, branchId) for use in dropdown selectors and filters. This endpoint is optimized for performance and does not include heavy wallet data like balances, profits, or transaction counts.

## Endpoint

### GET /api/v1/wallets/options

Retrieve lightweight wallet options for the current tenant.

#### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `branchId` | UUID | No | Filter wallets by branch ID. If provided, only wallets belonging to this branch are returned. |

#### Request Examples

```bash
# Get all wallets for current tenant
GET /api/v1/wallets/options

# Get wallets for a specific branch
GET /api/v1/wallets/options?branchId=550e8400-e29b-41d4-a716-446655440000
```

#### Response Format

**Success (200 OK)**

```json
{
  "data": [
    {
      "id": "wallet-uuid-1",
      "name": "Main Wallet",
      "number": "MW-001",
      "branchId": "branch-uuid-1"
    },
    {
      "id": "wallet-uuid-2",
      "name": "Branch Wallet",
      "number": "BW-014",
      "branchId": "branch-uuid-2"
    }
  ]
}
```

**Error (400 Bad Request)**

```json
{
  "code": "INVALID_BRANCH_ID",
  "message": "Branch ID format is invalid"
}
```

**Error (403 Forbidden)**

```json
{
  "code": "BRANCH_NOT_FOUND",
  "message": "Branch does not belong to current tenant"
}
```

**Error (404 Not Found)**

```json
{
  "code": "NO_WALLETS_FOUND",
  "message": "No wallets found for the specified criteria"
}
```

## Response Schema

### WalletOptionResponse

```java
@Data
@Builder
public class WalletOptionResponse {
    private String id;
    private String name;
    private String number;
    private String branchId;
}
```

### WalletOptionProjection

```java
public interface WalletOptionProjection {
    String getId();
    String getName();
    String getNumber();
    String getBranchId();
}
```

## Backend Implementation

### Repository Query

The repository should:

1. **Filter by Tenant**: Always filter wallets by the current tenant ID from the security context
2. **Filter by Branch** (optional): If `branchId` is provided:
   - Validate that the branch belongs to the current tenant
   - Filter wallets by the specified branch
3. **Order Results**: Sort wallets by name in ascending order
4. **Exclude Heavy Data**: Do NOT join or include:
   - Consumption data
   - Profit data
   - Collection data
   - Transaction counts
   - Balance information

### Query Example (JPA)

```java
@Query("""
    SELECT new com.example.dto.WalletOptionResponse(
        w.id, w.name, w.number, w.branchId
    )
    FROM Wallet w
    WHERE w.tenantId = :tenantId
    AND (:branchId IS NULL OR w.branchId = :branchId)
    ORDER BY w.name ASC
""")
List<WalletOptionResponse> findWalletOptions(
    @Param("tenantId") String tenantId,
    @Param("branchId") String branchId
);
```

### Role-Based Access Control

- **OWNER**: Can access all wallets for their tenant
- **USER**: Can access only wallets assigned to them (if current rules require this)
- **SYSTEM_ADMIN**: Can access wallets based on existing rules

### Branch Validation

When `branchId` is provided:

```java
// Validate branch belongs to current tenant
Branch branch = branchRepository.findById(branchId)
    .orElseThrow(() -> new BranchNotFoundException(branchId));

if (!branch.getTenantId().equals(currentTenantId)) {
    throw new ForbiddenException("Branch does not belong to current tenant");
}
```

## Performance Considerations

- **No Joins**: This endpoint should not join with consumption, profit, or collection tables
- **Indexed Columns**: Ensure `tenantId`, `branchId`, and `name` are indexed
- **Caching**: Consider caching results for 5-10 minutes per tenant/branch combination
- **Pagination**: Not required for this endpoint (typically < 100 wallets per branch)

## Usage in Flutter

### Wallet Dropdown Behavior

1. **Branch Filter First**: Branch filter appears before wallet filter
2. **Wallet Dependency**: Wallet filter depends on selected branch
3. **Clear on Branch Change**: When branch changes, clear selected wallet
4. **Load Wallets**: Load wallets for selected branch
5. **Clear Branch**: When branch is cleared, clear wallet and load all wallets
6. **Prevent Stale Data**: Do not send walletId from another branch

### Loading States

- Show loading indicator in wallet dropdown while fetching options
- Show friendly empty text if no wallets exist in selected branch
- Disable wallet dropdown if no wallets are available

### Integration Points

- **Reports Filters**: Branch → Wallet dependency
- **Transactions Filters**: Branch → Wallet dependency
- **Create Transaction**: Wallet selector (if only needs id/name/number)
- **Profit Collection**: Wallet selector (if only needs id/name/number)

## Migration Notes

- Existing `getWallets()` and `getWalletsByBranch()` endpoints continue to work for screens needing full wallet data
- Use `getWalletOptions()` only for dropdown/select UI components
- Do not use for wallet detail screens or cards that need balance/profit information
