// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Wallet Owner';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get wallets => 'Wallets';

  @override
  String get transactions => 'Transactions';

  @override
  String get createTransaction => 'Create Transaction';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get plans => 'Plans';

  @override
  String get requestRenewal => 'Request Renewal';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get activeWallets => 'Active Wallets';

  @override
  String get daily => 'Daily';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get credits => 'Credits';

  @override
  String get debits => 'Debits';

  @override
  String get credit => 'Credit';

  @override
  String get debit => 'Debit';

  @override
  String get logout => 'Logout';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading';

  @override
  String get noData => 'No data';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get amount => 'Amount';

  @override
  String get type => 'Type';

  @override
  String get date => 'Date';

  @override
  String get status => 'Status';

  @override
  String get name => 'Name';

  @override
  String get number => 'Number';

  @override
  String get balance => 'Balance';

  @override
  String get note => 'Note';

  @override
  String get submit => 'Submit';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get users => 'Users';

  @override
  String get branches => 'Branches';

  @override
  String get owners => 'Owners';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get overview => 'Overview';

  @override
  String get welcome => 'Welcome';

  @override
  String get create => 'Create';

  @override
  String get back => 'Back';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get refresh => 'Refresh';

  @override
  String get all => 'All';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get notAvailable => 'Not available';

  @override
  String get portfolioOverview => 'Portfolio Overview';

  @override
  String get portfolioOverviewSubtitle =>
      'Track balance movement and wallet activity across your owner account.';

  @override
  String get totalCredits => 'Total Credits';

  @override
  String get totalDebits => 'Total Debits';

  @override
  String activeWalletsCount(int count) {
    return '$count active wallets';
  }

  @override
  String get walletDirectory => 'Wallet Directory';

  @override
  String get walletDirectoryManageSubtitle =>
      'Review wallet balances, branch assignment, and status.';

  @override
  String get walletDirectoryReadOnlySubtitle =>
      'Review the wallets available to your account.';

  @override
  String get searchWallets => 'Search wallets';

  @override
  String get searchWalletsHint => 'Search by name, code, or branch';

  @override
  String get loadingWallets => 'Loading wallets...';

  @override
  String get unableToLoadWallets => 'Unable to load wallets right now.';

  @override
  String get noWalletsFound => 'No wallets found';

  @override
  String get noMatchingWallets => 'No matching wallets';

  @override
  String get walletsEmptyMessage =>
      'Wallet records will appear here once available.';

  @override
  String get walletsSearchEmptyMessage =>
      'Try a different search term or clear the filter.';

  @override
  String get createWallet => 'Create wallet';

  @override
  String get editWallet => 'Edit wallet';

  @override
  String get walletName => 'Wallet name';

  @override
  String get walletNameRequired => 'Wallet name is required';

  @override
  String get walletCreated => 'Wallet created.';

  @override
  String get walletUpdated => 'Wallet updated.';

  @override
  String get walletCreateFailed => 'Unable to create wallet. Please try again.';

  @override
  String get walletUpdateFailed => 'Unable to update wallet. Please try again.';

  @override
  String get deleteWallet => 'Delete wallet';

  @override
  String deleteWalletConfirmation(String name) {
    return 'Delete $name? This action cannot be undone.';
  }

  @override
  String get walletDeleted => 'Wallet deleted.';

  @override
  String get walletDeleteFailed => 'Unable to delete wallet. Please try again.';

  @override
  String get transactionsHistory => 'Transactions History';

  @override
  String get transactionsHistorySubtitle =>
      'Search and review recorded credit and debit activity across wallets.';

  @override
  String get searchTransactions => 'Search transactions';

  @override
  String get searchTransactionsHint => 'Search by wallet, note, or created by';

  @override
  String get refreshTransactions => 'Refresh transactions';

  @override
  String get loadingTransactions => 'Loading transactions...';

  @override
  String get unableToLoadTransactions =>
      'Unable to load transactions right now.';

  @override
  String get noTransactionsAvailable => 'No transactions available';

  @override
  String get noMatchingTransactions => 'No matching transactions';

  @override
  String get transactionsEmptyMessage =>
      'Recorded transactions will appear here.';

  @override
  String get transactionsSearchEmptyMessage =>
      'Try a different search or filter combination.';

  @override
  String get recordTransaction => 'Record Transaction';

  @override
  String get recordTransactionSubtitle =>
      'Capture the details after the real-life transaction has already happened.';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get wallet => 'Wallet';

  @override
  String get selectWallet => 'Select a wallet';

  @override
  String get walletRequired => 'Wallet is required';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get selectCreditOrDebit => 'Select credit or debit';

  @override
  String get transactionTypeRequired => 'Transaction type is required';

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get positiveAmountRequired => 'Enter a positive amount';

  @override
  String get percent => 'Percent';

  @override
  String get percentRequired => 'Percent is required';

  @override
  String get validPercentRequired => 'Enter a valid percent';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get validPhoneNumberRequired => 'Enter a valid phone number';

  @override
  String get cash => 'Cash';

  @override
  String get branchName => 'Branch';

  @override
  String get description => 'Description';

  @override
  String get occurredAt => 'Occurred At';

  @override
  String get optionalDescription => 'Optional description';

  @override
  String get createdByUser => 'Created By';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get loadingWalletOptions => 'Loading wallet options...';

  @override
  String get unableToLoadWalletOptions => 'Unable to load wallet options.';

  @override
  String savedTransactionForWallet(String type, String walletName) {
    return 'Saved $type transaction for $walletName.';
  }

  @override
  String get ownerSettings => 'Owner Settings';

  @override
  String get ownerSettingsSubtitle =>
      'Review account identity, workspace status, app preferences, and session actions from one place.';

  @override
  String get account => 'Account';

  @override
  String get accountSubtitle =>
      'Current owner identity and workspace assignment.';

  @override
  String get ownerName => 'Owner name';

  @override
  String get email => 'Email';

  @override
  String get role => 'Role';

  @override
  String get workspace => 'Workspace';

  @override
  String get workspaceSubscription => 'Workspace & Subscription';

  @override
  String get workspaceSubscriptionSubtitle =>
      'Read-only workspace subscription overview.';

  @override
  String get loadingWorkspaceSubscription =>
      'Loading workspace subscription...';

  @override
  String get unableToLoadSubscription =>
      'Unable to load subscription summary right now.';

  @override
  String get currentPlan => 'Current plan';

  @override
  String get renewalDate => 'Renewal date';

  @override
  String get openPlans => 'Open Plans';

  @override
  String get openPlansSubtitle => 'Review available plan tiers and limits.';

  @override
  String get requestRenewalSubtitle =>
      'Send a mock renewal or upgrade request.';

  @override
  String get preferences => 'Preferences';

  @override
  String get preferencesSubtitle =>
      'Lightweight app preferences for this frontend phase.';

  @override
  String get notificationsEnabledSubtitle => 'Enabled for mock owner alerts';

  @override
  String get notificationsDisabledSubtitle => 'Disabled for mock owner alerts';

  @override
  String get theme => 'Theme';

  @override
  String get systemDefault => 'System default';

  @override
  String get themeComingSoon =>
      'Theme settings will be added after backend integration planning.';

  @override
  String get appVersion => 'App version';

  @override
  String get securitySession => 'Security & Session';

  @override
  String get securitySessionSubtitle =>
      'Mock account security actions and session controls.';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordSubtitle =>
      'Available later with backend integration.';

  @override
  String get changePasswordComingSoon =>
      'Password management will be connected in a later phase.';

  @override
  String get session => 'Session';

  @override
  String signedInAs(String value) {
    return 'Signed in as $value';
  }

  @override
  String get logoutSubtitle => 'Sign out from the current owner session.';

  @override
  String get notificationsComingSoon => 'Notifications will be available soon.';

  @override
  String get genericReportsSubtitle =>
      'Run backend-driven reports with dynamic filters and generic rendering.';

  @override
  String get selectReport => 'Select Report';

  @override
  String get filters => 'Filters';

  @override
  String get dynamicFiltersSubtitle =>
      'Only filters supported by the selected report are shown.';

  @override
  String get loadingReports => 'Loading reports...';

  @override
  String get unableToLoadReports => 'Unable to load reports right now.';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get reportResultsSubtitle =>
      'Results are rendered from backend title, columns, and data.';

  @override
  String get noReportData => 'The selected report returned no rows or values.';

  @override
  String get unsupportedReportData =>
      'This report response could not be rendered with the current generic view.';

  @override
  String get fromDate => 'From Date';

  @override
  String get toDate => 'To Date';

  @override
  String get walletId => 'Wallet ID';

  @override
  String get walletIdHint => 'Enter a wallet id';

  @override
  String get period => 'Period';

  @override
  String get reportTypeTransactionSummary => 'Transaction Summary';

  @override
  String get reportTypeTransactionDetails => 'Transaction Details';

  @override
  String get reportTypeWalletConsumption => 'Wallet Consumption';

  @override
  String get reportTypeProfitSummary => 'Profit Summary';

  @override
  String get reportTypeTransactionTimeAggregation =>
      'Transaction Time Aggregation';

  @override
  String get reportsFieldsTotalCredits => 'Total Credits';

  @override
  String get reportsFieldsTotalDebits => 'Total Debits';

  @override
  String get reportsFieldsNetAmount => 'Net Amount';

  @override
  String get reportsFieldsTransactionCount => 'Transactions';

  @override
  String get reportsFieldsWalletName => 'Wallet Name';

  @override
  String get reportsFieldsBranchName => 'Branch';

  @override
  String get reportsFieldsTenantName => 'Tenant';

  @override
  String get reportsFieldsDailySpent => 'Daily Spent';

  @override
  String get reportsFieldsMonthlySpent => 'Monthly Spent';

  @override
  String get reportsFieldsDailyLimit => 'Daily Limit';

  @override
  String get reportsFieldsMonthlyLimit => 'Monthly Limit';

  @override
  String get reportsFieldsDailyPercent => 'Daily Percent';

  @override
  String get reportsFieldsMonthlyPercent => 'Monthly Percent';

  @override
  String get reportsFieldsUpdatedAt => 'Updated At';

  @override
  String get reportsFieldsActive => 'Active';

  @override
  String get reportsFieldsNearDailyLimit => 'Near Daily Limit';

  @override
  String get reportsFieldsNearMonthlyLimit => 'Near Monthly Limit';

  @override
  String get totalTransactions => 'Total Transactions';

  @override
  String get transactionCount => 'Transactions';

  @override
  String get net => 'Net';

  @override
  String get netAmount => 'Net Amount';

  @override
  String pageSummary(String page, String totalPages, String totalElements) {
    return 'Page $page of $totalPages - $totalElements items';
  }

  @override
  String get signIn => 'Sign in';

  @override
  String get signInSubtitle =>
      'Use your owner account to access wallet controls and reporting.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get usernamePlaceholder => 'Username';

  @override
  String get passwordPlaceholder => 'Password';

  @override
  String get login => 'Login';

  @override
  String get continueAsOwner => 'Login';

  @override
  String get authStorageNote =>
      'Uses the configured authentication endpoint and stores the active session locally.';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password is too short';

  @override
  String get loginHeroSubtitle =>
      'Mobile access for owner-level wallet oversight, transaction recording, and reporting.';

  @override
  String get loadingWorkspace => 'Loading workspace...';

  @override
  String get unsupportedAccountRole => 'Unsupported account role';

  @override
  String unsupportedAccountRoleMessage(String role) {
    return 'This app supports OWNER and USER accounts. Current role: $role.';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get unknown => 'Unknown';

  @override
  String get recorded => 'Recorded';

  @override
  String get pending => 'Pending';

  @override
  String createdBy(String name) {
    return 'Created by $name';
  }

  @override
  String transactionSavedRef(String referenceId) {
    return 'Transaction saved successfully. Ref: $referenceId';
  }

  @override
  String get branchDirectory => 'Branch Directory';

  @override
  String get branchDirectorySubtitle =>
      'Review branch availability, coverage, and wallet/user assignment.';

  @override
  String get searchBranches => 'Search branches';

  @override
  String get searchBranchesHint => 'Search by branch name or code';

  @override
  String get allStatus => 'All Status';

  @override
  String get loadingBranches => 'Loading branches...';

  @override
  String get unableToLoadBranches => 'Unable to load branches right now.';

  @override
  String get noBranchesAvailable => 'No branches available';

  @override
  String get noMatchingBranches => 'No matching branches';

  @override
  String get branchesEmptyMessage => 'Tenant branches will appear here.';

  @override
  String get branchesSearchEmptyMessage =>
      'Try a different search or status filter.';

  @override
  String get createBranch => 'Create Branch';

  @override
  String get editBranch => 'Edit Branch';

  @override
  String get deleteBranch => 'Delete Branch';

  @override
  String get branchCreatedSuccessfully => 'Branch created successfully';

  @override
  String get branchUpdatedSuccessfully => 'Branch updated successfully';

  @override
  String get branchDeletedSuccessfully => 'Branch deleted successfully';

  @override
  String get branchNameRequired => 'Branch name is required';

  @override
  String usersCount(int count) {
    return '$count users';
  }

  @override
  String walletsCount(int count) {
    return '$count wallets';
  }

  @override
  String get userDirectory => 'User Directory';

  @override
  String get userDirectorySubtitle =>
      'Monitor owner and user accounts, branch assignment, and activity status.';

  @override
  String get searchUsers => 'Search users';

  @override
  String get searchUsersHint => 'Search by name, email, or branch';

  @override
  String get allRoles => 'All Roles';

  @override
  String get owner => 'Owner';

  @override
  String get user => 'User';

  @override
  String get loadingUsers => 'Loading users...';

  @override
  String get unableToLoadUsers => 'Unable to load users right now.';

  @override
  String get noUsersAvailable => 'No users available';

  @override
  String get noMatchingUsers => 'No matching users';

  @override
  String get usersEmptyMessage => 'Workspace users will appear here.';

  @override
  String get usersSearchEmptyMessage =>
      'Try a different search or filter combination.';

  @override
  String get createUser => 'Create User';

  @override
  String get editUser => 'Edit User';

  @override
  String get deleteUser => 'Delete User';

  @override
  String get assignBranch => 'Assign Branch';

  @override
  String get unassignBranch => 'Unassign Branch';

  @override
  String get selectBranch => 'Select Branch';

  @override
  String get confirmDelete => 'Confirm delete';

  @override
  String get confirmUnassign => 'Confirm unassign';

  @override
  String get userCreatedSuccessfully => 'User created successfully';

  @override
  String get userUpdatedSuccessfully => 'User updated successfully';

  @override
  String get userDeletedSuccessfully => 'User deleted successfully';

  @override
  String get userAssignedToBranchSuccessfully =>
      'User assigned to branch successfully';

  @override
  String get userUnassignedFromBranchSuccessfully =>
      'User unassigned from branch successfully';

  @override
  String get ownerRole => 'OWNER';

  @override
  String get userRole => 'USER';

  @override
  String get noBranch => 'No branch';

  @override
  String get loadingSubscriptionPlans => 'Loading subscription plans...';

  @override
  String get unableToLoadSubscriptionDetails =>
      'Unable to load subscription details right now.';

  @override
  String get noPlansAvailable => 'No plans available';

  @override
  String get plansEmptyMessage => 'Subscription plan options will appear here.';

  @override
  String get subscriptionPlans => 'Subscription Plans';

  @override
  String get subscriptionPlansSubtitle =>
      'Review the current subscription, compare available tiers, and prepare the next upgrade decision.';

  @override
  String get subscriptionSummarySubtitle =>
      'Track plan status and workspace limits before the next renewal window.';

  @override
  String get availablePlans => 'Available Plans';

  @override
  String get availablePlansSubtitle =>
      'Mock plan options are ready for comparison and future backend-driven upgrades.';

  @override
  String get current => 'Current';

  @override
  String get recommended => 'Recommended';

  @override
  String get available => 'Available';

  @override
  String get currentPlanAction => 'Current Plan';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get choosePlan => 'Choose Plan';

  @override
  String get maxUsers => 'Max Users';

  @override
  String get maxWallets => 'Max Wallets';

  @override
  String get maxBranches => 'Max Branches';

  @override
  String get enterpriseUpgradeComingSoon =>
      'Enterprise upgrade review will be connected in a later phase.';

  @override
  String planSelectionComingSoon(String planName) {
    return '$planName selection will be connected in a later phase.';
  }

  @override
  String get unableToSignIn => 'Unable to sign in. Please try again.';

  @override
  String get unableToSaveTransaction =>
      'Unable to save the transaction. Please try again.';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get walletLoadError => 'Unable to load wallets. Please try again.';

  @override
  String get walletCreateError => 'Unable to create wallet. Please try again.';

  @override
  String get walletUpdateError => 'Unable to update wallet. Please try again.';

  @override
  String get walletDeleteError => 'Unable to delete wallet. Please try again.';
}
