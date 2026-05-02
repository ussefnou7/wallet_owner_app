import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ta2feela'**
  String get appName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @createTransaction.
  ///
  /// In en, this message translates to:
  /// **'Create transaction'**
  String get createTransaction;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

  /// No description provided for @userDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get userDashboardTitle;

  /// No description provided for @dashboardToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboardToday;

  /// No description provided for @userDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your transaction activity and quick actions.'**
  String get userDashboardSubtitle;

  /// No description provided for @dashboardCredits.
  ///
  /// In en, this message translates to:
  /// **'Total Credits'**
  String get dashboardCredits;

  /// No description provided for @dashboardDebits.
  ///
  /// In en, this message translates to:
  /// **'Total Debits'**
  String get dashboardDebits;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @noRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions'**
  String get noRecentTransactions;

  /// No description provided for @recentTransactionsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your recent activity will appear here.'**
  String get recentTransactionsEmptyMessage;

  /// No description provided for @transactionCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get transactionCredit;

  /// No description provided for @transactionDebit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get transactionDebit;

  /// No description provided for @userDashboardUnableToLoadSummary.
  ///
  /// In en, this message translates to:
  /// **'Unable to load today\'s activity right now.'**
  String get userDashboardUnableToLoadSummary;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @requestRenewal.
  ///
  /// In en, this message translates to:
  /// **'Request Renewal'**
  String get requestRenewal;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @activeWallets.
  ///
  /// In en, this message translates to:
  /// **'Active Wallets'**
  String get activeWallets;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @debits.
  ///
  /// In en, this message translates to:
  /// **'Debits'**
  String get debits;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @owners.
  ///
  /// In en, this message translates to:
  /// **'Owners'**
  String get owners;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @portfolioOverview.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Overview'**
  String get portfolioOverview;

  /// No description provided for @portfolioOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track balance movement and wallet activity across your account.'**
  String get portfolioOverviewSubtitle;

  /// No description provided for @latestTransactions.
  ///
  /// In en, this message translates to:
  /// **'Latest Transactions'**
  String get latestTransactions;

  /// No description provided for @latestTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest recorded wallet activity'**
  String get latestTransactionsSubtitle;

  /// No description provided for @totalCredits.
  ///
  /// In en, this message translates to:
  /// **'Total Credits'**
  String get totalCredits;

  /// No description provided for @totalDebits.
  ///
  /// In en, this message translates to:
  /// **'Total Debits'**
  String get totalDebits;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @activeWalletsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active wallets'**
  String activeWalletsCount(int count);

  /// No description provided for @walletDirectory.
  ///
  /// In en, this message translates to:
  /// **'Wallet Directory'**
  String get walletDirectory;

  /// No description provided for @walletDirectoryManageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review wallet balances, branch assignment, and status.'**
  String get walletDirectoryManageSubtitle;

  /// No description provided for @walletDirectoryReadOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the wallets available to your account.'**
  String get walletDirectoryReadOnlySubtitle;

  /// No description provided for @searchWallets.
  ///
  /// In en, this message translates to:
  /// **'Search wallets'**
  String get searchWallets;

  /// No description provided for @searchWalletsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, code, or branch'**
  String get searchWalletsHint;

  /// No description provided for @loadingWallets.
  ///
  /// In en, this message translates to:
  /// **'Loading wallets...'**
  String get loadingWallets;

  /// No description provided for @unableToLoadWallets.
  ///
  /// In en, this message translates to:
  /// **'Unable to load wallets right now.'**
  String get unableToLoadWallets;

  /// No description provided for @noWalletsFound.
  ///
  /// In en, this message translates to:
  /// **'No wallets found'**
  String get noWalletsFound;

  /// No description provided for @noMatchingWallets.
  ///
  /// In en, this message translates to:
  /// **'No matching wallets'**
  String get noMatchingWallets;

  /// No description provided for @walletsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Wallet records will appear here once available.'**
  String get walletsEmptyMessage;

  /// No description provided for @walletsSearchEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or clear the filter.'**
  String get walletsSearchEmptyMessage;

  /// No description provided for @createWallet.
  ///
  /// In en, this message translates to:
  /// **'Create wallet'**
  String get createWallet;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit wallet'**
  String get editWallet;

  /// No description provided for @walletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get walletName;

  /// No description provided for @walletCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get walletCurrentBalance;

  /// No description provided for @walletTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet type'**
  String get walletTypeLabel;

  /// No description provided for @walletStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet status'**
  String get walletStatusLabel;

  /// No description provided for @dailyLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily limit'**
  String get dailyLimitLabel;

  /// No description provided for @monthlyLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit'**
  String get monthlyLimitLabel;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get selectBranch;

  /// No description provided for @selectWalletType.
  ///
  /// In en, this message translates to:
  /// **'Select wallet type'**
  String get selectWalletType;

  /// No description provided for @walletNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet number is required'**
  String get walletNumberRequired;

  /// No description provided for @balanceRequired.
  ///
  /// In en, this message translates to:
  /// **'Balance is required'**
  String get balanceRequired;

  /// No description provided for @validAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get validAmountRequired;

  /// No description provided for @dailyLimitRequired.
  ///
  /// In en, this message translates to:
  /// **'Daily limit is required'**
  String get dailyLimitRequired;

  /// No description provided for @monthlyLimitRequired.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit is required'**
  String get monthlyLimitRequired;

  /// No description provided for @validLimitRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid limit'**
  String get validLimitRequired;

  /// No description provided for @branchRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch is required'**
  String get branchRequired;

  /// No description provided for @walletTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet type is required'**
  String get walletTypeRequired;

  /// No description provided for @noWalletTypesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No wallet types available'**
  String get noWalletTypesAvailable;

  /// No description provided for @failedToLoadBranches.
  ///
  /// In en, this message translates to:
  /// **'Failed to load branches'**
  String get failedToLoadBranches;

  /// No description provided for @failedToLoadWalletTypes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wallet types'**
  String get failedToLoadWalletTypes;

  /// No description provided for @sessionExpiredLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get sessionExpiredLoginAgain;

  /// No description provided for @invalidSessionLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Invalid session. Please login again.'**
  String get invalidSessionLoginAgain;

  /// No description provided for @accountDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get accountDisabledMessage;

  /// No description provided for @walletDailyConsumption.
  ///
  /// In en, this message translates to:
  /// **'Daily consumption'**
  String get walletDailyConsumption;

  /// No description provided for @walletMonthlyConsumption.
  ///
  /// In en, this message translates to:
  /// **'Monthly consumption'**
  String get walletMonthlyConsumption;

  /// No description provided for @walletProfitLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet profit'**
  String get walletProfitLabel;

  /// No description provided for @walletCashProfit.
  ///
  /// In en, this message translates to:
  /// **'Cash profit'**
  String get walletCashProfit;

  /// No description provided for @walletTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get walletTotalLabel;

  /// No description provided for @totalProfitLabel.
  ///
  /// In en, this message translates to:
  /// **'Total profit'**
  String get totalProfitLabel;

  /// No description provided for @noCollectionYet.
  ///
  /// In en, this message translates to:
  /// **'No collection yet'**
  String get noCollectionYet;

  /// No description provided for @lastCollectionWithDate.
  ///
  /// In en, this message translates to:
  /// **'Last collection: {date}'**
  String lastCollectionWithDate(String date);

  /// No description provided for @lastCollectionWithDateByName.
  ///
  /// In en, this message translates to:
  /// **'Last collection: {date} by {name}'**
  String lastCollectionWithDateByName(String date, String name);

  /// No description provided for @collectProfit.
  ///
  /// In en, this message translates to:
  /// **'Collect Profit'**
  String get collectProfit;

  /// No description provided for @currentWalletProfit.
  ///
  /// In en, this message translates to:
  /// **'Current wallet profit'**
  String get currentWalletProfit;

  /// No description provided for @currentCashProfit.
  ///
  /// In en, this message translates to:
  /// **'Current cash profit'**
  String get currentCashProfit;

  /// No description provided for @walletProfitAmount.
  ///
  /// In en, this message translates to:
  /// **'Wallet Profit Amount'**
  String get walletProfitAmount;

  /// No description provided for @cashProfitAmount.
  ///
  /// In en, this message translates to:
  /// **'Cash Profit Amount'**
  String get cashProfitAmount;

  /// No description provided for @optionalNote.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get optionalNote;

  /// No description provided for @collectProfitAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than 0 for wallet profit or cash profit.'**
  String get collectProfitAmountRequired;

  /// No description provided for @walletProfitAmountExceeds.
  ///
  /// In en, this message translates to:
  /// **'Wallet profit amount cannot exceed the current wallet profit.'**
  String get walletProfitAmountExceeds;

  /// No description provided for @cashProfitAmountExceeds.
  ///
  /// In en, this message translates to:
  /// **'Cash profit amount cannot exceed the current cash profit.'**
  String get cashProfitAmountExceeds;

  /// No description provided for @collectProfitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profit collected successfully.'**
  String get collectProfitSuccess;

  /// No description provided for @walletNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet name is required'**
  String get walletNameRequired;

  /// No description provided for @walletCreated.
  ///
  /// In en, this message translates to:
  /// **'Wallet created.'**
  String get walletCreated;

  /// No description provided for @walletUpdated.
  ///
  /// In en, this message translates to:
  /// **'Wallet updated.'**
  String get walletUpdated;

  /// No description provided for @walletCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to create wallet. Please try again.'**
  String get walletCreateFailed;

  /// No description provided for @walletUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update wallet. Please try again.'**
  String get walletUpdateFailed;

  /// No description provided for @deleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Delete wallet'**
  String get deleteWallet;

  /// No description provided for @deleteWalletConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}? This action cannot be undone.'**
  String deleteWalletConfirmation(String name);

  /// No description provided for @walletDeleted.
  ///
  /// In en, this message translates to:
  /// **'Wallet deleted.'**
  String get walletDeleted;

  /// No description provided for @walletDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete wallet. Please try again.'**
  String get walletDeleteFailed;

  /// No description provided for @transactionsHistory.
  ///
  /// In en, this message translates to:
  /// **'Transactions History'**
  String get transactionsHistory;

  /// No description provided for @transactionsHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search and review recorded credit and debit activity across wallets.'**
  String get transactionsHistorySubtitle;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get searchTransactions;

  /// No description provided for @searchTransactionsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by wallet, note, or created by'**
  String get searchTransactionsHint;

  /// No description provided for @refreshTransactions.
  ///
  /// In en, this message translates to:
  /// **'Refresh transactions'**
  String get refreshTransactions;

  /// No description provided for @loadMoreTransactions.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMoreTransactions;

  /// No description provided for @loadingMoreTransactions.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMoreTransactions;

  /// No description provided for @loadMoreTransactionsFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load more transactions. Try again.'**
  String get loadMoreTransactionsFailed;

  /// No description provided for @loadingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Loading transactions...'**
  String get loadingTransactions;

  /// No description provided for @unableToLoadTransactions.
  ///
  /// In en, this message translates to:
  /// **'Unable to load transactions right now.'**
  String get unableToLoadTransactions;

  /// No description provided for @noTransactionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No transactions available'**
  String get noTransactionsAvailable;

  /// No description provided for @noMatchingTransactions.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions'**
  String get noMatchingTransactions;

  /// No description provided for @transactionsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Recorded transactions will appear here.'**
  String get transactionsEmptyMessage;

  /// No description provided for @transactionsSearchEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter combination.'**
  String get transactionsSearchEmptyMessage;

  /// No description provided for @recordTransaction.
  ///
  /// In en, this message translates to:
  /// **'Record Transaction'**
  String get recordTransaction;

  /// No description provided for @recordTransactionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture the details after the real-life transaction has already happened.'**
  String get recordTransactionSubtitle;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @selectWallet.
  ///
  /// In en, this message translates to:
  /// **'Select a wallet'**
  String get selectWallet;

  /// No description provided for @walletRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet is required'**
  String get walletRequired;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @selectCreditOrDebit.
  ///
  /// In en, this message translates to:
  /// **'Select credit or debit'**
  String get selectCreditOrDebit;

  /// No description provided for @transactionTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Transaction type is required'**
  String get transactionTypeRequired;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// No description provided for @positiveAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive amount'**
  String get positiveAmountRequired;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get percent;

  /// No description provided for @percentRequired.
  ///
  /// In en, this message translates to:
  /// **'Percent is required'**
  String get percentRequired;

  /// No description provided for @validPercentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid percent'**
  String get validPercentRequired;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @validPhoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validPhoneNumberRequired;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @occurredAt.
  ///
  /// In en, this message translates to:
  /// **'Occurred At'**
  String get occurredAt;

  /// No description provided for @optionalDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get optionalDescription;

  /// No description provided for @createdByUser.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get createdByUser;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// No description provided for @loadingWalletOptions.
  ///
  /// In en, this message translates to:
  /// **'Loading wallet options...'**
  String get loadingWalletOptions;

  /// No description provided for @unableToLoadWalletOptions.
  ///
  /// In en, this message translates to:
  /// **'Unable to load wallet options.'**
  String get unableToLoadWalletOptions;

  /// No description provided for @savedTransactionForWallet.
  ///
  /// In en, this message translates to:
  /// **'Saved {type} transaction for {walletName}.'**
  String savedTransactionForWallet(String type, String walletName);

  /// No description provided for @ownerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get ownerSettings;

  /// No description provided for @ownerSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your profile, subscription details, preferences, and account security from one place.'**
  String get ownerSettingsSubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current account identity and workspace assignment.'**
  String get accountSubtitle;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get ownerName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspace;

  /// No description provided for @ownerWorkspaceFallback.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get ownerWorkspaceFallback;

  /// No description provided for @workspaceSubscription.
  ///
  /// In en, this message translates to:
  /// **'Workspace & Subscription'**
  String get workspaceSubscription;

  /// No description provided for @workspaceSubscriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read-only workspace subscription overview.'**
  String get workspaceSubscriptionSubtitle;

  /// No description provided for @loadingWorkspaceSubscription.
  ///
  /// In en, this message translates to:
  /// **'Loading workspace subscription...'**
  String get loadingWorkspaceSubscription;

  /// No description provided for @unableToLoadSubscription.
  ///
  /// In en, this message translates to:
  /// **'Unable to load subscription summary right now.'**
  String get unableToLoadSubscription;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get currentPlan;

  /// No description provided for @renewalDate.
  ///
  /// In en, this message translates to:
  /// **'Renewal date'**
  String get renewalDate;

  /// No description provided for @subscriptionAndPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Plans'**
  String get subscriptionAndPlans;

  /// No description provided for @subscriptionAndPlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your current plan, usage limits, and renewal requests.'**
  String get subscriptionAndPlansSubtitle;

  /// No description provided for @browsePlans.
  ///
  /// In en, this message translates to:
  /// **'Browse plans'**
  String get browsePlans;

  /// No description provided for @browsePlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review available plan options, limits, and pricing.'**
  String get browsePlansSubtitle;

  /// No description provided for @openPlans.
  ///
  /// In en, this message translates to:
  /// **'Open Plans'**
  String get openPlans;

  /// No description provided for @openPlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review available plan tiers and limits.'**
  String get openPlansSubtitle;

  /// No description provided for @requestRenewalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a mock renewal or upgrade request.'**
  String get requestRenewalSubtitle;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @preferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust language, notifications, theme, and app details.'**
  String get preferencesSubtitle;

  /// No description provided for @notificationsEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enabled for app alerts'**
  String get notificationsEnabledSubtitle;

  /// No description provided for @notificationsDisabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disabled for app alerts'**
  String get notificationsDisabledSubtitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @themeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Theme settings will be added after backend integration planning.'**
  String get themeComingSoon;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @legalInformation.
  ///
  /// In en, this message translates to:
  /// **'Legal & Information'**
  String get legalInformation;

  /// No description provided for @legalInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read simple information about Ta2feela, privacy, and platform terms.'**
  String get legalInformationSubtitle;

  /// No description provided for @aboutTa2feela.
  ///
  /// In en, this message translates to:
  /// **'About Ta2feela'**
  String get aboutTa2feela;

  /// No description provided for @aboutTa2feelaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn what Ta2feela helps you manage and where to get support.'**
  String get aboutTa2feelaSubtitle;

  /// No description provided for @aboutOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get aboutOverviewTitle;

  /// No description provided for @aboutOverviewBody.
  ///
  /// In en, this message translates to:
  /// **'Ta2feela is a wallet management app for tracking wallets, transactions, branches, users, profits, and daily or monthly consumption. It helps teams keep account activity organized in one place.'**
  String get aboutOverviewBody;

  /// No description provided for @aboutMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'What you can manage'**
  String get aboutMissionTitle;

  /// No description provided for @aboutMissionBody.
  ///
  /// In en, this message translates to:
  /// **'With Ta2feela, you can review wallet balances, record transaction activity, follow branch and user assignments, monitor profits, and check consumption details across your workspace.'**
  String get aboutMissionBody;

  /// No description provided for @aboutContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Version & Support'**
  String get aboutContactTitle;

  /// No description provided for @aboutContactBody.
  ///
  /// In en, this message translates to:
  /// **'Ta2feela support is available through the in-app Support page when you need help. Current app version: {version}. Support contact placeholder: support@ta2feela.example.'**
  String aboutContactBody(String version);

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn what data Ta2feela may use and why it is needed.'**
  String get privacyPolicySubtitle;

  /// No description provided for @privacyCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data we may collect'**
  String get privacyCollectionTitle;

  /// No description provided for @privacyCollectionBody.
  ///
  /// In en, this message translates to:
  /// **'Ta2feela may collect account and usage data such as username, role, wallet data, transaction data, branch and user assignment data, support tickets, and technical logs needed to operate the service.'**
  String get privacyCollectionBody;

  /// No description provided for @privacyUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Why data is used'**
  String get privacyUsageTitle;

  /// No description provided for @privacyUsageBody.
  ///
  /// In en, this message translates to:
  /// **'This data may be used for authentication, wallet management, reporting, support, security, and service improvement so the app can work reliably for each tenant.'**
  String get privacyUsageBody;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Access, sharing, and support'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecurityBody.
  ///
  /// In en, this message translates to:
  /// **'Ta2feela does not sell your data. Access to data is role-based and tenant-scoped. Support contact placeholder: support@ta2feela.example.'**
  String get privacySecurityBody;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @termsAndConditionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read the simple rules for using the Ta2feela platform.'**
  String get termsAndConditionsSubtitle;

  /// No description provided for @termsAcceptanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of terms'**
  String get termsAcceptanceTitle;

  /// No description provided for @termsAcceptanceBody.
  ///
  /// In en, this message translates to:
  /// **'By continuing to use Ta2feela, you accept these terms. You must keep your account credentials secure and protect access to your account.'**
  String get termsAcceptanceBody;

  /// No description provided for @termsUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Using the service'**
  String get termsUsageTitle;

  /// No description provided for @termsUsageBody.
  ///
  /// In en, this message translates to:
  /// **'You must enter accurate wallet and transaction data when using Ta2feela. Unauthorized access, misuse, or attempts to use another tenant\'s data are prohibited. The service may sometimes be unavailable during maintenance.'**
  String get termsUsageBody;

  /// No description provided for @termsResponsibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account responsibilities'**
  String get termsResponsibilityTitle;

  /// No description provided for @termsResponsibilityBody.
  ///
  /// In en, this message translates to:
  /// **'Ta2feela is not responsible for losses caused by incorrect data entry, misuse, or unauthorized account activity. Each user is responsible for using the app properly within their assigned access.'**
  String get termsResponsibilityBody;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password and manage access to this account.'**
  String get securitySubtitle;

  /// No description provided for @securitySession.
  ///
  /// In en, this message translates to:
  /// **'Security & Session'**
  String get securitySession;

  /// No description provided for @securitySessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mock account security actions and session controls.'**
  String get securitySessionSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password securely.'**
  String get changePasswordSubtitle;

  /// No description provided for @changePasswordSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your current password and choose a new one with at least 8 characters.'**
  String get changePasswordSheetSubtitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequired;

  /// No description provided for @newPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 8 characters'**
  String get newPasswordMinLength;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the new password'**
  String get confirmPasswordRequired;

  /// No description provided for @confirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get confirmPasswordMismatch;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get passwordChangedSuccessfully;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your account details to submit a password reset request.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @submitResetRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitResetRequest;

  /// No description provided for @resetRequestSubmittedFallback.
  ///
  /// In en, this message translates to:
  /// **'If the account exists, a reset request has been submitted.'**
  String get resetRequestSubmittedFallback;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get usernameOrEmail;

  /// No description provided for @usernameOrEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username or email'**
  String get usernameOrEmailRequired;

  /// No description provided for @unableToSubmitResetRequest.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit reset request'**
  String get unableToSubmitResetRequest;

  /// No description provided for @changePasswordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Password management will be connected in a later phase.'**
  String get changePasswordComingSoon;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {value}'**
  String signedInAs(String value);

  /// No description provided for @logoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out from the current session.'**
  String get logoutSubtitle;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications will be available soon.'**
  String get notificationsComingSoon;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsImportantSection.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get notificationsImportantSection;

  /// No description provided for @notificationsLowPrioritySection.
  ///
  /// In en, this message translates to:
  /// **'Low Priority'**
  String get notificationsLowPrioritySection;

  /// No description provided for @notificationsReadAllLow.
  ///
  /// In en, this message translates to:
  /// **'Read all low'**
  String get notificationsReadAllLow;

  /// No description provided for @notificationsReadAll.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get notificationsReadAll;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications will appear here when action is needed.'**
  String get notificationsEmptyMessage;

  /// No description provided for @notificationsWalletDailyLimitNearTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily wallet limit is near'**
  String get notificationsWalletDailyLimitNearTitle;

  /// No description provided for @notificationsWalletDailyLimitNearMessage.
  ///
  /// In en, this message translates to:
  /// **'One of your wallets is approaching its daily limit.'**
  String get notificationsWalletDailyLimitNearMessage;

  /// No description provided for @notificationsWalletDailyLimitExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily wallet limit exceeded'**
  String get notificationsWalletDailyLimitExceededTitle;

  /// No description provided for @notificationsWalletDailyLimitExceededMessage.
  ///
  /// In en, this message translates to:
  /// **'A wallet has exceeded its daily spending limit.'**
  String get notificationsWalletDailyLimitExceededMessage;

  /// No description provided for @notificationsWalletMonthlyLimitNearTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly wallet limit is near'**
  String get notificationsWalletMonthlyLimitNearTitle;

  /// No description provided for @notificationsWalletMonthlyLimitNearMessage.
  ///
  /// In en, this message translates to:
  /// **'One of your wallets is approaching its monthly limit.'**
  String get notificationsWalletMonthlyLimitNearMessage;

  /// No description provided for @notificationsWalletMonthlyLimitExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly wallet limit exceeded'**
  String get notificationsWalletMonthlyLimitExceededTitle;

  /// No description provided for @notificationsWalletMonthlyLimitExceededMessage.
  ///
  /// In en, this message translates to:
  /// **'A wallet has exceeded its monthly spending limit.'**
  String get notificationsWalletMonthlyLimitExceededMessage;

  /// No description provided for @notificationsTransactionCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'New transaction created'**
  String get notificationsTransactionCreatedTitle;

  /// No description provided for @notificationsTransactionCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'A new wallet transaction was recorded.'**
  String get notificationsTransactionCreatedMessage;

  /// No description provided for @notificationsUnableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications right now.'**
  String get notificationsUnableToLoad;

  /// No description provided for @notificationsUnableToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Unable to update notifications right now.'**
  String get notificationsUnableToUpdate;

  /// No description provided for @genericReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Run backend-driven reports with dynamic filters and generic rendering.'**
  String get genericReportsSubtitle;

  /// No description provided for @selectReport.
  ///
  /// In en, this message translates to:
  /// **'Select Report'**
  String get selectReport;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @dynamicFiltersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only filters supported by the selected report are shown.'**
  String get dynamicFiltersSubtitle;

  /// No description provided for @loadingReports.
  ///
  /// In en, this message translates to:
  /// **'Loading reports....'**
  String get loadingReports;

  /// No description provided for @unableToLoadReports.
  ///
  /// In en, this message translates to:
  /// **'Unable to load reports right now.'**
  String get unableToLoadReports;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @reportResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Results are rendered from backend title, columns, and data.'**
  String get reportResultsSubtitle;

  /// No description provided for @noReportData.
  ///
  /// In en, this message translates to:
  /// **'The selected report returned no rows or values.'**
  String get noReportData;

  /// No description provided for @unsupportedReportData.
  ///
  /// In en, this message translates to:
  /// **'This report response could not be rendered with the current generic view.'**
  String get unsupportedReportData;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @walletId.
  ///
  /// In en, this message translates to:
  /// **'Wallet ID'**
  String get walletId;

  /// No description provided for @walletIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a wallet id'**
  String get walletIdHint;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @reportTypeTransactionSummary.
  ///
  /// In en, this message translates to:
  /// **'Transaction Summary'**
  String get reportTypeTransactionSummary;

  /// No description provided for @reportTypeTransactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get reportTypeTransactionDetails;

  /// No description provided for @reportTypeWalletConsumption.
  ///
  /// In en, this message translates to:
  /// **'Wallet Consumption'**
  String get reportTypeWalletConsumption;

  /// No description provided for @reportTypeProfitSummary.
  ///
  /// In en, this message translates to:
  /// **'Profit Summary'**
  String get reportTypeProfitSummary;

  /// No description provided for @reportTypeTransactionTimeAggregation.
  ///
  /// In en, this message translates to:
  /// **'Transaction Time Aggregation'**
  String get reportTypeTransactionTimeAggregation;

  /// No description provided for @reportsFieldsTotalCredits.
  ///
  /// In en, this message translates to:
  /// **'Total Credits'**
  String get reportsFieldsTotalCredits;

  /// No description provided for @reportsFieldsTotalDebits.
  ///
  /// In en, this message translates to:
  /// **'Total Debits'**
  String get reportsFieldsTotalDebits;

  /// No description provided for @reportsFieldsNetAmount.
  ///
  /// In en, this message translates to:
  /// **'Net Amount'**
  String get reportsFieldsNetAmount;

  /// No description provided for @reportsFieldsTransactionCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get reportsFieldsTransactionCount;

  /// No description provided for @reportsFieldsWalletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet Name'**
  String get reportsFieldsWalletName;

  /// No description provided for @reportsFieldsBranchName.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get reportsFieldsBranchName;

  /// No description provided for @reportsFieldsTenantName.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get reportsFieldsTenantName;

  /// No description provided for @reportsFieldsDailySpent.
  ///
  /// In en, this message translates to:
  /// **'Daily Spent'**
  String get reportsFieldsDailySpent;

  /// No description provided for @reportsFieldsMonthlySpent.
  ///
  /// In en, this message translates to:
  /// **'Monthly Spent'**
  String get reportsFieldsMonthlySpent;

  /// No description provided for @reportsFieldsDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit'**
  String get reportsFieldsDailyLimit;

  /// No description provided for @reportsFieldsMonthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Monthly Limit'**
  String get reportsFieldsMonthlyLimit;

  /// No description provided for @reportsFieldsDailyPercent.
  ///
  /// In en, this message translates to:
  /// **'Daily Percent'**
  String get reportsFieldsDailyPercent;

  /// No description provided for @reportsFieldsMonthlyPercent.
  ///
  /// In en, this message translates to:
  /// **'Monthly Percent'**
  String get reportsFieldsMonthlyPercent;

  /// No description provided for @reportsFieldsUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get reportsFieldsUpdatedAt;

  /// No description provided for @reportsFieldsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get reportsFieldsActive;

  /// No description provided for @reportsFieldsNearDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Near Daily Limit'**
  String get reportsFieldsNearDailyLimit;

  /// No description provided for @reportsFieldsNearMonthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Near Monthly Limit'**
  String get reportsFieldsNearMonthlyLimit;

  /// No description provided for @totalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get totalTransactions;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionCount;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @netAmount.
  ///
  /// In en, this message translates to:
  /// **'Net Amount'**
  String get netAmount;

  /// No description provided for @pageSummary.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {totalPages} - {totalElements} items'**
  String pageSummary(String page, String totalPages, String totalElements);

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your account to access wallet controls and reporting.'**
  String get signInSubtitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @usernamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernamePlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordPlaceholder;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @continueAsOwner.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get continueAsOwner;

  /// No description provided for @authStorageNote.
  ///
  /// In en, this message translates to:
  /// **'Uses the configured authentication endpoint and stores the active session locally.'**
  String get authStorageNote;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get passwordTooShort;

  /// No description provided for @loginHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile access for wallet oversight, transaction recording, and reporting.'**
  String get loginHeroSubtitle;

  /// No description provided for @loadingWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Loading workspace...'**
  String get loadingWorkspace;

  /// No description provided for @unsupportedAccountRole.
  ///
  /// In en, this message translates to:
  /// **'Unsupported account role'**
  String get unsupportedAccountRole;

  /// No description provided for @unsupportedAccountRoleMessage.
  ///
  /// In en, this message translates to:
  /// **'This app supports OWNER and USER accounts. Current role: {role}.'**
  String unsupportedAccountRoleMessage(String role);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by: {name}'**
  String createdBy(String name);

  /// No description provided for @transactionSavedRef.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved successfully. Ref: {referenceId}'**
  String transactionSavedRef(String referenceId);

  /// No description provided for @branchDirectory.
  ///
  /// In en, this message translates to:
  /// **'Branch Directory'**
  String get branchDirectory;

  /// No description provided for @branchDirectorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review branch availability, coverage, and wallet/user assignment.'**
  String get branchDirectorySubtitle;

  /// No description provided for @searchBranches.
  ///
  /// In en, this message translates to:
  /// **'Search branches'**
  String get searchBranches;

  /// No description provided for @searchBranchesHint.
  ///
  /// In en, this message translates to:
  /// **'Search by branch name or code'**
  String get searchBranchesHint;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @loadingBranches.
  ///
  /// In en, this message translates to:
  /// **'Loading branches...'**
  String get loadingBranches;

  /// No description provided for @unableToLoadBranches.
  ///
  /// In en, this message translates to:
  /// **'Unable to load branches right now.'**
  String get unableToLoadBranches;

  /// No description provided for @noBranchesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No branches available'**
  String get noBranchesAvailable;

  /// No description provided for @noMatchingBranches.
  ///
  /// In en, this message translates to:
  /// **'No matching branches'**
  String get noMatchingBranches;

  /// No description provided for @branchesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tenant branches will appear here.'**
  String get branchesEmptyMessage;

  /// No description provided for @branchesSearchEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or status filter.'**
  String get branchesSearchEmptyMessage;

  /// No description provided for @createBranch.
  ///
  /// In en, this message translates to:
  /// **'Create Branch'**
  String get createBranch;

  /// No description provided for @editBranch.
  ///
  /// In en, this message translates to:
  /// **'Edit Branch'**
  String get editBranch;

  /// No description provided for @deleteBranch.
  ///
  /// In en, this message translates to:
  /// **'Delete Branch'**
  String get deleteBranch;

  /// No description provided for @branchCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Branch created successfully'**
  String get branchCreatedSuccessfully;

  /// No description provided for @branchUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Branch updated successfully'**
  String get branchUpdatedSuccessfully;

  /// No description provided for @branchDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Branch deleted successfully'**
  String get branchDeletedSuccessfully;

  /// No description provided for @branchNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch name is required'**
  String get branchNameRequired;

  /// No description provided for @usersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} users'**
  String usersCount(int count);

  /// No description provided for @walletsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} wallets'**
  String walletsCount(int count);

  /// No description provided for @userDirectory.
  ///
  /// In en, this message translates to:
  /// **'User Directory'**
  String get userDirectory;

  /// No description provided for @userDirectorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor account access, branch assignment, and activity status.'**
  String get userDirectorySubtitle;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users'**
  String get searchUsers;

  /// No description provided for @searchUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email, or branch'**
  String get searchUsersHint;

  /// No description provided for @allRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get allRoles;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @loadingUsers.
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loadingUsers;

  /// No description provided for @unableToLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Unable to load users right now.'**
  String get unableToLoadUsers;

  /// No description provided for @noUsersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get noUsersAvailable;

  /// No description provided for @noMatchingUsers.
  ///
  /// In en, this message translates to:
  /// **'No matching users'**
  String get noMatchingUsers;

  /// No description provided for @usersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Workspace users will appear here.'**
  String get usersEmptyMessage;

  /// No description provided for @usersSearchEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter combination.'**
  String get usersSearchEmptyMessage;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @assignBranch.
  ///
  /// In en, this message translates to:
  /// **'Assign Branch'**
  String get assignBranch;

  /// No description provided for @unassignBranch.
  ///
  /// In en, this message translates to:
  /// **'Unassign Branch'**
  String get unassignBranch;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete'**
  String get confirmDelete;

  /// No description provided for @confirmUnassign.
  ///
  /// In en, this message translates to:
  /// **'Confirm unassign'**
  String get confirmUnassign;

  /// No description provided for @userCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccessfully;

  /// No description provided for @userUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdatedSuccessfully;

  /// No description provided for @userDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeletedSuccessfully;

  /// No description provided for @userAssignedToBranchSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User assigned to branch successfully'**
  String get userAssignedToBranchSuccessfully;

  /// No description provided for @userUnassignedFromBranchSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User unassigned from branch successfully'**
  String get userUnassignedFromBranchSuccessfully;

  /// No description provided for @ownerRole.
  ///
  /// In en, this message translates to:
  /// **'OWNER'**
  String get ownerRole;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'USER'**
  String get userRole;

  /// No description provided for @noBranch.
  ///
  /// In en, this message translates to:
  /// **'No branch'**
  String get noBranch;

  /// No description provided for @loadingSubscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Loading subscription plans...'**
  String get loadingSubscriptionPlans;

  /// No description provided for @unableToLoadSubscriptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Unable to load subscription details right now.'**
  String get unableToLoadSubscriptionDetails;

  /// No description provided for @noPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plans available'**
  String get noPlansAvailable;

  /// No description provided for @plansEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Subscription plan options will appear here.'**
  String get plansEmptyMessage;

  /// No description provided for @subscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get subscriptionPlans;

  /// No description provided for @subscriptionPlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the current subscription, compare available tiers, and prepare the next upgrade decision.'**
  String get subscriptionPlansSubtitle;

  /// No description provided for @subscriptionSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track plan status and workspace limits before the next renewal window.'**
  String get subscriptionSummarySubtitle;

  /// No description provided for @availablePlans.
  ///
  /// In en, this message translates to:
  /// **'Available Plans'**
  String get availablePlans;

  /// No description provided for @availablePlansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mock plan options are ready for comparison and future backend-driven upgrades.'**
  String get availablePlansSubtitle;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @currentPlanAction.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlanAction;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Plan'**
  String get choosePlan;

  /// No description provided for @maxUsers.
  ///
  /// In en, this message translates to:
  /// **'Max Users'**
  String get maxUsers;

  /// No description provided for @maxWallets.
  ///
  /// In en, this message translates to:
  /// **'Max Wallets'**
  String get maxWallets;

  /// No description provided for @maxBranches.
  ///
  /// In en, this message translates to:
  /// **'Max Branches'**
  String get maxBranches;

  /// No description provided for @currencyEgp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEgp;

  /// No description provided for @monthlyBillingPeriod.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get monthlyBillingPeriod;

  /// No description provided for @planPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'{currency} {price} / {period}'**
  String planPricePerMonth(String currency, String price, String period);

  /// No description provided for @enterpriseUpgradeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Enterprise upgrade review will be connected in a later phase.'**
  String get enterpriseUpgradeComingSoon;

  /// No description provided for @planSelectionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{planName} selection will be connected in a later phase.'**
  String planSelectionComingSoon(String planName);

  /// No description provided for @unableToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in. Please try again.'**
  String get unableToSignIn;

  /// No description provided for @unableToSaveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Unable to save the transaction. Please try again.'**
  String get unableToSaveTransaction;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @walletLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load wallets. Please try again.'**
  String get walletLoadError;

  /// No description provided for @walletCreateError.
  ///
  /// In en, this message translates to:
  /// **'Unable to create wallet. Please try again.'**
  String get walletCreateError;

  /// No description provided for @walletUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Unable to update wallet. Please try again.'**
  String get walletUpdateError;

  /// No description provided for @walletDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete wallet. Please try again.'**
  String get walletDeleteError;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportTickets.
  ///
  /// In en, this message translates to:
  /// **'Support Tickets'**
  String get supportTickets;

  /// No description provided for @supportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Need help? Send a support request to our team.'**
  String get supportSubtitle;

  /// No description provided for @newTicket.
  ///
  /// In en, this message translates to:
  /// **'New Ticket'**
  String get newTicket;

  /// No description provided for @noSupportTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'There are no support tickets yet.'**
  String get noSupportTicketsYet;

  /// No description provided for @invalidUsernameOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidUsernameOrPassword;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large'**
  String get fileTooLarge;

  /// No description provided for @unsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type'**
  String get unsupportedFileType;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Please check the entered data'**
  String get validationError;

  /// No description provided for @forbiddenError.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action'**
  String get forbiddenError;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @branchLimitReachedForCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Branch limit reached for current plan'**
  String get branchLimitReachedForCurrentPlan;

  /// No description provided for @userLimitReachedForCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'User limit reached for current plan'**
  String get userLimitReachedForCurrentPlan;

  /// No description provided for @walletLimitReachedForCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Wallet limit reached for current plan'**
  String get walletLimitReachedForCurrentPlan;

  /// No description provided for @dataConflict.
  ///
  /// In en, this message translates to:
  /// **'This action conflicts with existing data'**
  String get dataConflict;

  /// No description provided for @unableToSubmitSupportRequest.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit support request'**
  String get unableToSubmitSupportRequest;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportMessage;

  /// No description provided for @subjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get subjectRequired;

  /// No description provided for @supportMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get supportMessageRequired;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @priorityRequired.
  ///
  /// In en, this message translates to:
  /// **'Priority is required'**
  String get priorityRequired;

  /// No description provided for @resolvedAt.
  ///
  /// In en, this message translates to:
  /// **'Resolved at'**
  String get resolvedAt;

  /// No description provided for @sendSupportRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Support Request'**
  String get sendSupportRequest;

  /// No description provided for @supportRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Support request sent successfully.'**
  String get supportRequestSent;

  /// No description provided for @unableToSendSupportRequest.
  ///
  /// In en, this message translates to:
  /// **'Unable to send support request. Please try again.'**
  String get unableToSendSupportRequest;

  /// No description provided for @unableToLoadSupportTickets.
  ///
  /// In en, this message translates to:
  /// **'Unable to load support tickets. Please try again.'**
  String get unableToLoadSupportTickets;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @renewalRequest.
  ///
  /// In en, this message translates to:
  /// **'Renewal Request'**
  String get renewalRequest;

  /// No description provided for @renewalRequests.
  ///
  /// In en, this message translates to:
  /// **'Renewal Requests'**
  String get renewalRequests;

  /// No description provided for @renewalRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request a subscription renewal for your workspace.'**
  String get renewalRequestSubtitle;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newRequest;

  /// No description provided for @noRenewalRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'There are no renewal requests yet.'**
  String get noRenewalRequestsYet;

  /// No description provided for @submitRenewalRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Renewal Request'**
  String get submitRenewalRequest;

  /// No description provided for @renewalRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Renewal request submitted successfully.'**
  String get renewalRequestSubmitted;

  /// No description provided for @unableToSubmitRenewalRequest.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit renewal request'**
  String get unableToSubmitRenewalRequest;

  /// No description provided for @unableToLoadRenewalRequests.
  ///
  /// In en, this message translates to:
  /// **'Unable to load renewal requests. Please try again.'**
  String get unableToLoadRenewalRequests;

  /// No description provided for @requestedAt.
  ///
  /// In en, this message translates to:
  /// **'Requested at'**
  String get requestedAt;

  /// No description provided for @reviewedAt.
  ///
  /// In en, this message translates to:
  /// **'Reviewed at'**
  String get reviewedAt;

  /// No description provided for @adminNote.
  ///
  /// In en, this message translates to:
  /// **'Admin Note'**
  String get adminNote;

  /// No description provided for @periodMonths.
  ///
  /// In en, this message translates to:
  /// **'Period (Months)'**
  String get periodMonths;

  /// No description provided for @periodMonthsRequired.
  ///
  /// In en, this message translates to:
  /// **'Period is required'**
  String get periodMonthsRequired;

  /// No description provided for @positivePeriodRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number of months'**
  String get positivePeriodRequired;

  /// No description provided for @password_optional_hint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if you don\'t want to change it'**
  String get password_optional_hint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
