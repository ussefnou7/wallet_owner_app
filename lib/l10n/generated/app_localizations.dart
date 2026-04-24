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
  /// **'Wallet Owner'**
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
  /// **'Create Transaction'**
  String get createTransaction;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

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
  /// **'Track balance movement and wallet activity across your owner account.'**
  String get portfolioOverviewSubtitle;

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
  /// **'Owner Settings'**
  String get ownerSettings;

  /// No description provided for @ownerSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review account identity, workspace status, app preferences, and session actions from one place.'**
  String get ownerSettingsSubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current owner identity and workspace assignment.'**
  String get accountSubtitle;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
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
  /// **'Lightweight app preferences for this frontend phase.'**
  String get preferencesSubtitle;

  /// No description provided for @notificationsEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enabled for mock owner alerts'**
  String get notificationsEnabledSubtitle;

  /// No description provided for @notificationsDisabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disabled for mock owner alerts'**
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
  /// **'Available later with backend integration.'**
  String get changePasswordSubtitle;

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
  /// **'Sign out from the current owner session.'**
  String get logoutSubtitle;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications will be available soon.'**
  String get notificationsComingSoon;

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
  /// **'Loading reports...'**
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
  /// **'Use your owner account to access wallet controls and reporting.'**
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
  /// **'Mobile access for owner-level wallet oversight, transaction recording, and reporting.'**
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
  /// **'Created by {name}'**
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
  /// **'Monitor owner and user accounts, branch assignment, and activity status.'**
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
