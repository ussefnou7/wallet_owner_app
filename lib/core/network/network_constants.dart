abstract final class NetworkConstants {
  static const acceptHeader = 'Accept';
  static const authorizationHeader = 'Authorization';
  static const bearerPrefix = 'Bearer';
  static const authLoginPath = '/api/v1/auth/login';
  static const walletsPath = '/api/v1/wallets';
  static const transactionsPath = '/api/v1/transactions';
  static const usersPath = '/api/v1/users';
  static const branchesPath = '/api/v1/branches';
  static const reportsDashboardOverviewPath =
      '/api/v1/reports/dashboard/overview';
  static const reportsTransactionsSummaryPath =
      '/api/v1/reports/transactions/summary';
  static const supportTicketsPath = '/api/v1/support/tickets';
  static const renewalRequestsPath = '/api/v1/renewal-requests';

  static String branchPath(String branchId) => '$branchesPath/$branchId';

  static String userPath(String userId) => '$usersPath/$userId';

  static String userBranchAssignmentPath(String userId) =>
      '$usersPath/$userId/branch';
}
