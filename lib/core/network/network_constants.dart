abstract final class NetworkConstants {
  static const acceptHeader = 'Accept';
  static const authorizationHeader = 'Authorization';
  static const bearerPrefix = 'Bearer';
  static const authLoginPath = '/api/v1/auth/login';
  static const publicAuthPaths = {authLoginPath};
  static const walletsPath = '/api/v1/wallets';
  static const transactionsPath = '/api/v1/transactions';
  static const usersPath = '/api/v1/users';
  static const mePasswordPath = '$usersPath/me/password';
  static const branchesPath = '/api/v1/branches';
  static const reportsDashboardOverviewPath =
      '/api/v1/reports/dashboard/overview';
  static const reportsTransactionsSummaryPath =
      '/api/v1/reports/transactions/summary';
  static const supportTicketsPath = '/api/v1/support/tickets';
  static const renewalRequestsPath = '/api/v1/renewal-requests';
  static const notificationsPath = '/api/v1/notifications';
  static const notificationsUnreadPath = '$notificationsPath/unread';
  static const notificationsUnreadCountPath = '$notificationsPath/unread-count';
  static const notificationsReadLowPath = '$notificationsPath/read-low';
  static const notificationsReadAllPath = '$notificationsPath/read-all';

  static String branchPath(String branchId) => '$branchesPath/$branchId';

  static String userPath(String userId) => '$usersPath/$userId';

  static String userAssignBranchPath(String userId) =>
      '$usersPath/$userId/assign-branch';

  static String userBranchAssignmentPath(String userId) =>
      '$usersPath/$userId/branch';

  static String notificationReadPath(String notificationId) =>
      '$notificationsPath/$notificationId/read';

  static bool isPublicAuthPath(String path) {
    final uri = Uri.tryParse(path);
    final normalizedPath = _normalizePath(
      uri != null && uri.path.isNotEmpty ? uri.path : path,
    );
    return publicAuthPaths.contains(normalizedPath);
  }

  static String _normalizePath(String path) {
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }
}
