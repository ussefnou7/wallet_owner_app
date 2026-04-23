// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'إدارة المحافظ';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get dashboard => 'الرئيسية';

  @override
  String get wallets => 'المحافظ';

  @override
  String get transactions => 'المعاملات';

  @override
  String get createTransaction => 'إنشاء معاملة';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get reports => 'التقارير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get plans => 'الباقات';

  @override
  String get requestRenewal => 'طلب التجديد';

  @override
  String get totalBalance => 'إجمالي الرصيد';

  @override
  String get activeWallets => 'المحافظ النشطة';

  @override
  String get daily => 'يومي';

  @override
  String get monthly => 'شهري';

  @override
  String get yearly => 'سنوي';

  @override
  String get credits => 'الإيداعات';

  @override
  String get debits => 'السحوبات';

  @override
  String get credit => 'إيداع';

  @override
  String get debit => 'سحب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get amount => 'المبلغ';

  @override
  String get type => 'النوع';

  @override
  String get date => 'التاريخ';

  @override
  String get status => 'الحالة';

  @override
  String get name => 'الاسم';

  @override
  String get number => 'الرقم';

  @override
  String get balance => 'الرصيد';

  @override
  String get note => 'ملاحظة';

  @override
  String get submit => 'إرسال';

  @override
  String get success => 'تم بنجاح';

  @override
  String get error => 'خطأ';

  @override
  String get users => 'المستخدمون';

  @override
  String get branches => 'الفروع';

  @override
  String get owners => 'المالكون';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get welcome => 'مرحبًا';

  @override
  String get create => 'إنشاء';

  @override
  String get back => 'رجوع';

  @override
  String get confirm => 'تأكيد';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get refresh => 'تحديث';

  @override
  String get all => 'الكل';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get enabled => 'مفعلة';

  @override
  String get disabled => 'معطلة';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get portfolioOverview => 'نظرة عامة على المحفظة';

  @override
  String get portfolioOverviewSubtitle =>
      'تابع حركة الرصيد ونشاط المحافظ في حساب المالك.';

  @override
  String get totalCredits => 'إجمالي الإيداعات';

  @override
  String get totalDebits => 'إجمالي السحوبات';

  @override
  String activeWalletsCount(int count) {
    return '$count محافظ نشطة';
  }

  @override
  String get walletDirectory => 'دليل المحافظ';

  @override
  String get walletDirectoryManageSubtitle =>
      'راجع أرصدة المحافظ والفروع والحالة.';

  @override
  String get walletDirectoryReadOnlySubtitle => 'راجع المحافظ المتاحة لحسابك.';

  @override
  String get searchWallets => 'بحث في المحافظ';

  @override
  String get searchWalletsHint => 'ابحث بالاسم أو الكود أو الفرع';

  @override
  String get loadingWallets => 'جارٍ تحميل المحافظ...';

  @override
  String get unableToLoadWallets => 'تعذر تحميل المحافظ حاليًا.';

  @override
  String get noWalletsFound => 'لا توجد محافظ';

  @override
  String get noMatchingWallets => 'لا توجد محافظ مطابقة';

  @override
  String get walletsEmptyMessage => 'ستظهر سجلات المحافظ هنا عند توفرها.';

  @override
  String get walletsSearchEmptyMessage =>
      'جرّب كلمة بحث مختلفة أو امسح التصفية.';

  @override
  String get createWallet => 'إنشاء محفظة';

  @override
  String get editWallet => 'تعديل محفظة';

  @override
  String get walletName => 'اسم المحفظة';

  @override
  String get walletNameRequired => 'اسم المحفظة مطلوب';

  @override
  String get walletCreated => 'تم إنشاء المحفظة.';

  @override
  String get walletUpdated => 'تم تحديث المحفظة.';

  @override
  String get walletCreateFailed => 'تعذر إنشاء المحفظة. حاول مرة أخرى.';

  @override
  String get walletUpdateFailed => 'تعذر تحديث المحفظة. حاول مرة أخرى.';

  @override
  String get deleteWallet => 'حذف المحفظة';

  @override
  String deleteWalletConfirmation(String name) {
    return 'حذف $name؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get walletDeleted => 'تم حذف المحفظة.';

  @override
  String get walletDeleteFailed => 'تعذر حذف المحفظة. حاول مرة أخرى.';

  @override
  String get transactionsHistory => 'سجل المعاملات';

  @override
  String get transactionsHistorySubtitle =>
      'ابحث وراجع نشاط الإيداع والسحب المسجل عبر المحافظ.';

  @override
  String get searchTransactions => 'بحث في المعاملات';

  @override
  String get searchTransactionsHint =>
      'ابحث بالمحفظة أو الملاحظة أو منشئ المعاملة';

  @override
  String get refreshTransactions => 'تحديث المعاملات';

  @override
  String get loadingTransactions => 'جارٍ تحميل المعاملات...';

  @override
  String get unableToLoadTransactions => 'تعذر تحميل المعاملات حاليًا.';

  @override
  String get noTransactionsAvailable => 'لا توجد معاملات';

  @override
  String get noMatchingTransactions => 'لا توجد معاملات مطابقة';

  @override
  String get transactionsEmptyMessage => 'ستظهر المعاملات المسجلة هنا.';

  @override
  String get transactionsSearchEmptyMessage => 'جرّب بحثًا أو تصفية مختلفة.';

  @override
  String get recordTransaction => 'تسجيل معاملة';

  @override
  String get recordTransactionSubtitle =>
      'سجّل التفاصيل بعد إتمام المعاملة فعليًا.';

  @override
  String get transactionDetails => 'تفاصيل المعاملة';

  @override
  String get wallet => 'المحفظة';

  @override
  String get selectWallet => 'اختر محفظة';

  @override
  String get walletRequired => 'المحفظة مطلوبة';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get selectCreditOrDebit => 'اختر إيداعًا أو سحبًا';

  @override
  String get transactionTypeRequired => 'نوع المعاملة مطلوب';

  @override
  String get amountRequired => 'المبلغ مطلوب';

  @override
  String get positiveAmountRequired => 'أدخل مبلغًا موجبًا';

  @override
  String get percent => 'النسبة';

  @override
  String get percentRequired => 'النسبة مطلوبة';

  @override
  String get validPercentRequired => 'أدخل نسبة صحيحة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneNumberRequired => 'رقم الهاتف مطلوب';

  @override
  String get validPhoneNumberRequired => 'أدخل رقم هاتف صحيحًا';

  @override
  String get cash => 'نقدي';

  @override
  String get description => 'الوصف';

  @override
  String get optionalDescription => 'وصف اختياري';

  @override
  String get saveTransaction => 'حفظ المعاملة';

  @override
  String get loadingWalletOptions => 'جارٍ تحميل خيارات المحافظ...';

  @override
  String get unableToLoadWalletOptions => 'تعذر تحميل خيارات المحافظ.';

  @override
  String savedTransactionForWallet(String type, String walletName) {
    return 'تم حفظ معاملة $type لمحفظة $walletName.';
  }

  @override
  String get ownerSettings => 'إعدادات المالك';

  @override
  String get ownerSettingsSubtitle =>
      'راجع هوية الحساب وحالة مساحة العمل والتفضيلات وإجراءات الجلسة من مكان واحد.';

  @override
  String get account => 'الحساب';

  @override
  String get accountSubtitle => 'هوية المالك الحالية وتعيين مساحة العمل.';

  @override
  String get ownerName => 'اسم المالك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get role => 'الدور';

  @override
  String get workspace => 'مساحة العمل';

  @override
  String get workspaceSubscription => 'مساحة العمل والاشتراك';

  @override
  String get workspaceSubscriptionSubtitle =>
      'نظرة عامة للقراءة فقط على اشتراك مساحة العمل.';

  @override
  String get loadingWorkspaceSubscription => 'جارٍ تحميل اشتراك مساحة العمل...';

  @override
  String get unableToLoadSubscription => 'تعذر تحميل ملخص الاشتراك حاليًا.';

  @override
  String get currentPlan => 'الباقة الحالية';

  @override
  String get renewalDate => 'تاريخ التجديد';

  @override
  String get openPlans => 'فتح الباقات';

  @override
  String get openPlansSubtitle => 'راجع مستويات الباقات والحدود المتاحة.';

  @override
  String get requestRenewalSubtitle => 'أرسل طلب تجديد أو ترقية تجريبي.';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get preferencesSubtitle => 'تفضيلات بسيطة للتطبيق في هذه المرحلة.';

  @override
  String get notificationsEnabledSubtitle => 'مفعلة لتنبيهات المالك التجريبية';

  @override
  String get notificationsDisabledSubtitle => 'معطلة لتنبيهات المالك التجريبية';

  @override
  String get theme => 'المظهر';

  @override
  String get systemDefault => 'إعدادات النظام';

  @override
  String get themeComingSoon =>
      'ستتم إضافة إعدادات المظهر بعد تخطيط تكامل الخادم.';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get securitySession => 'الأمان والجلسة';

  @override
  String get securitySessionSubtitle =>
      'إجراءات أمان الحساب التجريبية والتحكم في الجلسة.';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordSubtitle => 'سيتوفر لاحقًا مع تكامل الخادم.';

  @override
  String get changePasswordComingSoon =>
      'سيتم ربط إدارة كلمة المرور في مرحلة لاحقة.';

  @override
  String get session => 'الجلسة';

  @override
  String signedInAs(String value) {
    return 'تم تسجيل الدخول باسم $value';
  }

  @override
  String get logoutSubtitle => 'تسجيل الخروج من جلسة المالك الحالية.';

  @override
  String get notificationsComingSoon => 'ستتوفر الإشعارات قريبًا.';

  @override
  String get reportingWorkspace => 'مساحة التقارير';

  @override
  String get reportingWorkspaceSubtitle =>
      'اختر تقريرًا لمراجعة الأداء المالي والتشغيلي.';

  @override
  String get financialReports => 'التقارير المالية';

  @override
  String get financialReportsSubtitle =>
      'عروض مالية عالية المستوى لمتابعة المالك.';

  @override
  String get operationalReports => 'التقارير التشغيلية';

  @override
  String get operationalReportsSubtitle =>
      'ملخصات النشاط التشغيلي عبر الفرق والفروع.';

  @override
  String get exportFormats => 'صيغ التصدير';

  @override
  String get exportFormatsSubtitle =>
      'جهّز التقارير للمشاركة والمراجعة دون اتصال.';

  @override
  String reportAvailableLater(String title) {
    return 'سيتوفر $title لاحقًا.';
  }

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInSubtitle =>
      'استخدم حساب المالك للوصول إلى أدوات المحافظ والتقارير.';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get usernamePlaceholder => 'اسم المستخدم';

  @override
  String get passwordPlaceholder => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get continueAsOwner => 'تسجيل الدخول';

  @override
  String get authStorageNote =>
      'يستخدم نقطة المصادقة المضبوطة ويحفظ الجلسة النشطة محليًا.';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'كلمة المرور قصيرة جدًا';

  @override
  String get loginHeroSubtitle =>
      'وصول عبر الجوال لمتابعة المحافظ وتسجيل المعاملات والتقارير على مستوى المالك.';

  @override
  String get loadingWorkspace => 'جارٍ تحميل مساحة العمل...';

  @override
  String get unsupportedAccountRole => 'دور الحساب غير مدعوم';

  @override
  String unsupportedAccountRoleMessage(String role) {
    return 'يدعم هذا التطبيق حسابات OWNER و USER. الدور الحالي: $role.';
  }

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get unknown => 'غير معروف';

  @override
  String get recorded => 'مسجلة';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String createdBy(String name) {
    return 'تم الإنشاء بواسطة $name';
  }

  @override
  String transactionSavedRef(String referenceId) {
    return 'تم حفظ المعاملة بنجاح. المرجع: $referenceId';
  }

  @override
  String get branchDirectory => 'دليل الفروع';

  @override
  String get branchDirectorySubtitle =>
      'راجع توفر الفروع والتغطية وتعيين المحافظ والمستخدمين.';

  @override
  String get searchBranches => 'بحث في الفروع';

  @override
  String get searchBranchesHint => 'ابحث باسم الفرع أو الكود';

  @override
  String get allStatus => 'كل الحالات';

  @override
  String get loadingBranches => 'جارٍ تحميل الفروع...';

  @override
  String get unableToLoadBranches => 'تعذر تحميل الفروع حاليًا.';

  @override
  String get noBranchesAvailable => 'لا توجد فروع';

  @override
  String get noMatchingBranches => 'لا توجد فروع مطابقة';

  @override
  String get branchesEmptyMessage => 'ستظهر فروع المؤسسة هنا.';

  @override
  String get branchesSearchEmptyMessage => 'جرّب بحثًا أو حالة مختلفة.';

  @override
  String usersCount(int count) {
    return '$count مستخدمين';
  }

  @override
  String walletsCount(int count) {
    return '$count محافظ';
  }

  @override
  String get userDirectory => 'دليل المستخدمين';

  @override
  String get userDirectorySubtitle =>
      'راقب حسابات المالكين والمستخدمين وتعيين الفروع وحالة النشاط.';

  @override
  String get searchUsers => 'بحث في المستخدمين';

  @override
  String get searchUsersHint => 'ابحث بالاسم أو البريد الإلكتروني أو الفرع';

  @override
  String get allRoles => 'كل الأدوار';

  @override
  String get owner => 'مالك';

  @override
  String get user => 'مستخدم';

  @override
  String get loadingUsers => 'جارٍ تحميل المستخدمين...';

  @override
  String get unableToLoadUsers => 'تعذر تحميل المستخدمين حاليًا.';

  @override
  String get noUsersAvailable => 'لا يوجد مستخدمون';

  @override
  String get noMatchingUsers => 'لا يوجد مستخدمون مطابقون';

  @override
  String get usersEmptyMessage => 'سيظهر مستخدمو مساحة العمل هنا.';

  @override
  String get usersSearchEmptyMessage => 'جرّب بحثًا أو تصفية مختلفة.';

  @override
  String get ownerRole => 'مالك';

  @override
  String get userRole => 'مستخدم';

  @override
  String get noBranch => 'لا يوجد فرع';

  @override
  String get loadingSubscriptionPlans => 'جارٍ تحميل باقات الاشتراك...';

  @override
  String get unableToLoadSubscriptionDetails =>
      'تعذر تحميل تفاصيل الاشتراك حاليًا.';

  @override
  String get noPlansAvailable => 'لا توجد باقات';

  @override
  String get plansEmptyMessage => 'ستظهر خيارات باقات الاشتراك هنا.';

  @override
  String get subscriptionPlans => 'باقات الاشتراك';

  @override
  String get subscriptionPlansSubtitle =>
      'راجع الاشتراك الحالي وقارن الباقات المتاحة وجهّز قرار الترقية القادم.';

  @override
  String get subscriptionSummarySubtitle =>
      'تابع حالة الباقة وحدود مساحة العمل قبل نافذة التجديد القادمة.';

  @override
  String get availablePlans => 'الباقات المتاحة';

  @override
  String get availablePlansSubtitle =>
      'خيارات الباقات التجريبية جاهزة للمقارنة والترقيات المستقبلية من الخادم.';

  @override
  String get current => 'الحالية';

  @override
  String get recommended => 'موصى بها';

  @override
  String get available => 'متاحة';

  @override
  String get currentPlanAction => 'الباقة الحالية';

  @override
  String get upgrade => 'ترقية';

  @override
  String get choosePlan => 'اختيار الباقة';

  @override
  String get maxUsers => 'الحد الأقصى للمستخدمين';

  @override
  String get maxWallets => 'الحد الأقصى للمحافظ';

  @override
  String get maxBranches => 'الحد الأقصى للفروع';

  @override
  String get enterpriseUpgradeComingSoon =>
      'سيتم ربط مراجعة ترقية Enterprise في مرحلة لاحقة.';

  @override
  String planSelectionComingSoon(String planName) {
    return 'سيتم ربط اختيار $planName في مرحلة لاحقة.';
  }
}
