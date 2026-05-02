abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const unauthorizedRole = '/unauthorized-role';

  static const ownerDashboard = '/owner/dashboard';
  static const ownerWallets = '/owner/wallets';
  static const ownerTransactions = '/owner/transactions';
  static const ownerCreateTransaction = '/owner/transactions/create';
  static const ownerReports = '/owner/reports';
  static const ownerUsers = '/owner/users';
  static const ownerBranches = '/owner/branches';
  static const ownerPlans = '/owner/plans';
  static const ownerRequestRenewal = '/owner/request-renewal';
  static const ownerCreateRenewalRequest = '/owner/request-renewal/new';
  static const ownerSupport = '/owner/support';
  static const ownerCreateSupport = '/owner/support/new';
  static const ownerSettings = '/owner/settings';
  static const ownerAbout = '/owner/settings/about';
  static const ownerPrivacyPolicy = '/owner/settings/privacy-policy';
  static const ownerTermsAndConditions = '/owner/settings/terms-and-conditions';
  static const ownerNotifications = '/owner/notifications';

  static const userDashboard = '/user/dashboard';
  static const userWallets = '/user/wallets';
  static const userTransactions = '/user/transactions';
  static const userCreateTransaction = '/user/transactions/create';
  static const userSupport = '/user/support';
  static const userCreateSupport = '/user/support/new';

  static const dashboard = ownerDashboard;
  static const wallets = ownerWallets;
  static const transactions = ownerTransactions;
  static const createTransaction = ownerCreateTransaction;
  static const reports = ownerReports;
  static const users = ownerUsers;
  static const branches = ownerBranches;
  static const plans = ownerPlans;
  static const requestRenewal = ownerRequestRenewal;
  static const createRenewalRequest = ownerCreateRenewalRequest;
  static const support = ownerSupport;
  static const createSupport = ownerCreateSupport;
  static const settings = ownerSettings;
  static const about = ownerAbout;
  static const privacyPolicy = ownerPrivacyPolicy;
  static const termsAndConditions = ownerTermsAndConditions;
  static const notificationsCenter = ownerNotifications;
}
