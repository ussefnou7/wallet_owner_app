import 'package:flutter/foundation.dart';

/// Utility for safely building wallet options query parameters.
///
/// Ensures that invalid branchId values are never sent to the API.
/// Only includes branchId when it's a valid non-empty UUID string.
abstract final class WalletOptionsQueryBuilder {
  /// Builds safe query parameters for wallet options API.
  ///
  /// Rules:
  /// - Only adds branchId when it's a real non-empty UUID string
  /// - Filters out null, empty, "null", "undefined", and invalid values
  /// - Returns empty map if no valid branchId
  ///
  /// Example:
  /// ```dart
  /// final params = WalletOptionsQueryBuilder.build(branchId);
  /// // If branchId is null or empty: {}
  /// // If branchId is valid UUID: {'branchId': 'uuid-value'}
  /// ```
  static Map<String, dynamic> build(String? branchId) {
    final queryParams = <String, dynamic>{};

    if (_isValidBranchId(branchId)) {
      queryParams['branchId'] = branchId!;
      debugPrint('[WalletOptions] Query params: $queryParams');
    } else {
      debugPrint('[WalletOptions] No valid branchId, using base endpoint');
    }

    return queryParams;
  }

  /// Validates if branchId is safe to send to the API.
  ///
  /// Returns false for:
  /// - null
  /// - empty string
  /// - whitespace only
  /// - "null" (string)
  /// - "undefined" (string)
  /// - "all" (string)
  /// - strings that don't look like UUIDs
  static bool _isValidBranchId(String? branchId) {
    if (branchId == null) return false;

    final trimmed = branchId.trim();

    // Check for empty or invalid string values
    if (trimmed.isEmpty) return false;
    if (trimmed.toLowerCase() == 'null') return false;
    if (trimmed.toLowerCase() == 'undefined') return false;
    if (trimmed.toLowerCase() == 'all') return false;

    // Basic UUID validation (8-4-4-4-12 hex pattern)
    // This is a simple check; adjust regex if needed
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    return uuidRegex.hasMatch(trimmed);
  }

  /// Normalizes branchId for safe comparison and storage.
  ///
  /// Returns null if branchId is invalid, otherwise returns trimmed value.
  static String? normalize(String? branchId) {
    if (!_isValidBranchId(branchId)) return null;
    return branchId!.trim();
  }
}
