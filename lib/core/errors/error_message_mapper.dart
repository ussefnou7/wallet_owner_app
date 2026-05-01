import 'package:flutter/widgets.dart';

import '../localization/app_l10n.dart';
import 'app_exception.dart';

abstract final class ErrorMessageMapper {
  static String getMessage(Object? error) {
    if (error is! AppException) {
      return 'Something went wrong';
    }

    final backendMessage = error.message.trim();
    if (backendMessage.isNotEmpty &&
        error.code.toUpperCase() != 'DATA_CONFLICT') {
      return backendMessage;
    }

    return switch (error.code.toUpperCase()) {
      'TOKEN_EXPIRED' => 'Session expired. Please login again.',
      'INVALID_TOKEN' => 'Invalid session. Please login again.',
      'ACCOUNT_INACTIVE' => 'This account has been disabled.',
      'UNAUTHORIZED' ||
      'INVALID_CREDENTIALS' ||
      'BAD_CREDENTIALS' => 'Invalid username or password',
      'FILE_TOO_LARGE' => 'File is too large',
      'UNSUPPORTED_FILE_TYPE' => 'Unsupported file type',
      'VALIDATION_ERROR' => 'Please check the entered data',
      'FORBIDDEN' => 'You do not have permission to perform this action',
      'DATA_CONFLICT' => _mapDataConflictMessage(
        backendMessage,
        defaultMessage: 'This action conflicts with existing data',
      ),
      _ => 'Something went wrong',
    };
  }

  static String getLocalizedMessage(
    BuildContext context,
    Object? error, {
    String? fallbackMessage,
  }) {
    final l10n = appL10n(context);
    final defaultMessage = fallbackMessage ?? l10n.somethingWentWrong;

    if (error is! AppException) {
      return defaultMessage;
    }

    final backendMessage = error.message.trim();

    return switch (error.code.toUpperCase()) {
      'TOKEN_EXPIRED' => l10n.sessionExpiredLoginAgain,
      'INVALID_TOKEN' => l10n.invalidSessionLoginAgain,
      'ACCOUNT_INACTIVE' => l10n.accountDisabledMessage,
      'UNAUTHORIZED' ||
      'INVALID_CREDENTIALS' ||
      'BAD_CREDENTIALS' => l10n.invalidUsernameOrPassword,
      'FILE_TOO_LARGE' => l10n.fileTooLarge,
      'UNSUPPORTED_FILE_TYPE' => l10n.unsupportedFileType,
      'VALIDATION_ERROR' => l10n.validationError,
      'FORBIDDEN' => l10n.forbiddenError,
      'DATA_CONFLICT' => _mapDataConflictMessage(
        backendMessage,
        defaultMessage: l10n.dataConflict,
        branchLimitMessage: l10n.branchLimitReachedForCurrentPlan,
        userLimitMessage: l10n.userLimitReachedForCurrentPlan,
        walletLimitMessage: l10n.walletLimitReachedForCurrentPlan,
      ),
      'INTERNAL_SERVER_ERROR' => l10n.somethingWentWrong,
      _ => defaultMessage,
    };
  }

  static String _mapDataConflictMessage(
    String backendMessage, {
    required String defaultMessage,
    String? branchLimitMessage,
    String? userLimitMessage,
    String? walletLimitMessage,
  }) {
    if (backendMessage.contains('Branch limit reached')) {
      return branchLimitMessage ?? 'Branch limit reached for current plan';
    }
    if (backendMessage.contains('User limit reached')) {
      return userLimitMessage ?? 'User limit reached for current plan';
    }
    if (backendMessage.contains('Wallet limit reached')) {
      return walletLimitMessage ?? 'Wallet limit reached for current plan';
    }
    return defaultMessage;
  }
}
