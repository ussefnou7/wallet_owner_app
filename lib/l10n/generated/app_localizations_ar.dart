// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'تفعيلة';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'عربي';

  @override
  String get dashboard => 'الرئيسية';

  @override
  String get wallets => 'المحافظ';

  @override
  String get transactions => 'العمليات';

  @override
  String get createTransaction => 'إنشاء عملية';

  @override
  String get newTransaction => 'عملية جديدة';

  @override
  String get userDashboardTitle => 'الرئيسية';

  @override
  String get dashboardToday => 'اليوم';

  @override
  String get userDashboardSubtitle =>
      'تابع عملياتك اليومية ونفّذ المطلوب بسرعة.';

  @override
  String get dashboardCredits => 'إجمالي الإيداع';

  @override
  String get dashboardDebits => 'إجمالي السحب';

  @override
  String get dashboardProfitSnapshot => 'الأرباح';

  @override
  String get dashboardCollectedProfit => 'المتحصل';

  @override
  String get dashboardUncollectedProfit => 'غير المتحصل';

  @override
  String get dashboardTransactionVolume => 'قيمة العمليات';

  @override
  String get dashboardWalletHealth => 'حالة المحافظ';

  @override
  String get dashboardActiveBalance => 'الرصيد المتاح';

  @override
  String get dashboardNearDailyLimit => 'قريب من حد اليوم';

  @override
  String get dashboardNearMonthlyLimit => 'قريب من حد الشهر';

  @override
  String get dashboardLimitReached => 'وصل للحد';

  @override
  String get dashboardDailyLimitReached => 'وصل لحد اليوم';

  @override
  String get dashboardMonthlyLimitReached => 'وصل لحد الشهر';

  @override
  String dashboardReviewWalletsNeedingAttention(int count) {
    return 'راجع $count محافظ محتاجة متابعة';
  }

  @override
  String get dashboardAllWalletsHealthy => 'كل المحافظ تمام';

  @override
  String get dashboardHealthStatusGood => 'تمام';

  @override
  String get dashboardHealthStatusWarning => 'محتاجة متابعة';

  @override
  String get dashboardHealthStatusCritical => 'حرج';

  @override
  String get dashboardSeverityWarning => 'تحذير';

  @override
  String get dashboardSeverityCritical => 'حرج';

  @override
  String get dashboardSeverityInfo => 'معلومة';

  @override
  String get recentTransactions => 'آخر العمليات';

  @override
  String get noRecentTransactions => 'لا توجد عمليات حديثة';

  @override
  String get recentTransactionsEmptyMessage =>
      'ستظهر أحدث عملياتك هنا عند توفرها.';

  @override
  String get transactionCredit => 'إيداع';

  @override
  String get transactionDebit => 'سحب';

  @override
  String get userDashboardUnableToLoadSummary => 'تعذر تحميل نشاط اليوم الآن.';

  @override
  String get reports => 'التقارير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get plans => 'الباقات';

  @override
  String get subscriptionExpiredTitle => 'انتهى الاشتراك';

  @override
  String get organizationSubscriptionExpiredTitle => 'اشتراك المؤسسة منتهي';

  @override
  String get subscriptionExpiredMessageOwner =>
      'انتهى اشتراك المؤسسة الخاصة بك. يلزم التجديد لاستعادة الوصول إلى خصائص العمل.';

  @override
  String get subscriptionExpiredMessageUser =>
      'انتهى اشتراك المؤسسة الخاصة بك. يرجى التواصل مع مالك الحساب لتجديده.';

  @override
  String get subscriptionExpiredDateLabel => 'تاريخ الانتهاء';

  @override
  String get subscriptionPlanLabel => 'الباقة الحالية';

  @override
  String get requestRenewal => 'طلب التجديد';

  @override
  String get renewalRequestSent =>
      'تم إرسال طلب التجديد بنجاح. طلبك الآن قيد المراجعة.';

  @override
  String get renewalRequestPending => 'يوجد بالفعل طلب تجديد قيد المراجعة.';

  @override
  String get renewalRequestFailed => 'تعذر إرسال طلب التجديد.';

  @override
  String get recheckStatus => 'إعادة التحقق';

  @override
  String get subscriptionStillExpired =>
      'ما زال الاشتراك منتهيًا أو الطلب قيد المراجعة.';

  @override
  String get subscriptionReactivated =>
      'أصبح الاشتراك فعالًا مرة أخرى. يتم تحويلك الآن.';

  @override
  String get contactAccountOwner => 'تواصل مع مالك الحساب للمساعدة في التجديد.';

  @override
  String get backToExpiredSubscription => 'العودة إلى صفحة انتهاء الاشتراك';

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
  String get credits => 'الإيداع';

  @override
  String get debits => 'السحب';

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
  String get filter => 'فلترة';

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
  String get overview => 'نظرة سريعة';

  @override
  String get profit => 'الأرباح';

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
  String get portfolioOverview => 'نظرة سريعة على المحافظ';

  @override
  String get portfolioOverviewSubtitle => 'تابع الرصيد وحركة المحافظ بتاعتك.';

  @override
  String get latestTransactions => 'آخر العمليات';

  @override
  String get latestTransactionsSubtitle => 'أحدث العمليات المسجلة على المحافظ.';

  @override
  String get lastTransactions => 'آخر العمليات';

  @override
  String get totalCredits => 'إجمالي الإيداع';

  @override
  String get totalDebits => 'إجمالي السحب';

  @override
  String get transactionVolume => 'حجم العمليات';

  @override
  String get transactionsCount => 'عدد العمليات';

  @override
  String get totalProfit => 'إجمالي الأرباح';

  @override
  String get walletStatus => 'حالة المحافظ';

  @override
  String get walletConsumptions => 'استهلاك المحافظ';

  @override
  String get walletConsumptionsEmptyMessage =>
      'ستظهر بيانات استهلاك المحافظ هنا.';

  @override
  String get totalWalletProfit => 'إجمالي أرباح المحافظ';

  @override
  String get totalCashProfit => 'إجمالي أرباح الكاش';

  @override
  String get nearLimitWallets => 'المحافظ القريبة من الحد';

  @override
  String get viewAll => 'عرض الكل';

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
  String get sortWallets => 'ترتيب المحافظ';

  @override
  String get walletSortDefaultOrder => 'الترتيب الافتراضي';

  @override
  String get walletSortNearLimitFirst => 'الأقرب للحد أولاً';

  @override
  String get walletSortHighestDailyUsage => 'الأعلى في الاستخدام اليومي';

  @override
  String get walletSortHighestMonthlyUsage => 'الأعلى في الاستخدام الشهري';

  @override
  String get walletSortHighestLimit => 'أعلى حد';

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
  String get walletCurrentBalance => 'الرصيد الحالي';

  @override
  String get walletTypeLabel => 'نوع المحفظة';

  @override
  String get walletStatusLabel => 'حالة المحفظة';

  @override
  String get dailyLimitLabel => 'الحد اليومي';

  @override
  String get monthlyLimitLabel => 'الحد الشهري';

  @override
  String get selectBranch => 'اختر الفرع';

  @override
  String get selectWalletType => 'اختر نوع المحفظة';

  @override
  String get walletNumberRequired => 'رقم المحفظة مطلوب';

  @override
  String get balanceRequired => 'الرصيد مطلوب';

  @override
  String get validAmountRequired => 'أدخل مبلغًا صحيحًا';

  @override
  String get dailyLimitRequired => 'الحد اليومي مطلوب';

  @override
  String get monthlyLimitRequired => 'الحد الشهري مطلوب';

  @override
  String get validLimitRequired => 'أدخل حدًا صحيحًا';

  @override
  String get branchRequired => 'الفرع مطلوب';

  @override
  String get walletTypeRequired => 'نوع المحفظة مطلوب';

  @override
  String get noWalletTypesAvailable => 'لا توجد أنواع محافظ متاحة';

  @override
  String get failedToLoadBranches => 'تعذر تحميل الفروع';

  @override
  String get failedToLoadWalletTypes => 'تعذر تحميل أنواع المحافظ';

  @override
  String get sessionExpiredLoginAgain => 'انتهت الجلسة، سجّل دخولك مرة تانية';

  @override
  String get invalidSessionLoginAgain =>
      'الجلسة غير صالحة، سجّل دخولك مرة تانية';

  @override
  String get accountDisabledMessage => 'تم تعطيل هذا الحساب';

  @override
  String get walletDailyConsumption => 'الاستهلاك اليومي';

  @override
  String get walletMonthlyConsumption => 'الاستهلاك الشهري';

  @override
  String get walletProfitLabel => 'أرباح المحفظة';

  @override
  String get walletCashProfit => 'الربح النقدي';

  @override
  String get walletTotalLabel => 'الإجمالي';

  @override
  String get totalProfitLabel => 'إجمالي الأرباح';

  @override
  String get noCollectionYet => 'لا يوجد تحصيل بعد';

  @override
  String lastCollectionWithDate(String date) {
    return 'آخر تحصيل: $date';
  }

  @override
  String lastCollectionWithDateByName(String date, String name) {
    return 'آخر تحصيل: $date بواسطة $name';
  }

  @override
  String get collectProfit => 'تحصيل الأرباح';

  @override
  String get currentWalletProfit => 'أرباح المحفظة الحالية';

  @override
  String get currentCashProfit => 'أرباح الكاش الحالية';

  @override
  String get walletProfitAmount => 'مبلغ أرباح المحفظة';

  @override
  String get cashProfitAmount => 'مبلغ أرباح الكاش';

  @override
  String get optionalNote => 'ملاحظة اختيارية';

  @override
  String get collectProfitAmountRequired =>
      'أدخل مبلغًا أكبر من 0 في أرباح المحفظة أو أرباح الكاش.';

  @override
  String get walletProfitAmountExceeds =>
      'لا يمكن أن يتجاوز مبلغ أرباح المحفظة الربح الحالي للمحفظة.';

  @override
  String get cashProfitAmountExceeds =>
      'لا يمكن أن يتجاوز مبلغ أرباح الكاش الربح النقدي الحالي.';

  @override
  String get collectProfitSuccess => 'تم تحصيل الأرباح بنجاح.';

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
  String get transactionsHistory => 'سجل العمليات';

  @override
  String get transactionsHistorySubtitle =>
      'ابحث وراجع عمليات الإيداع والسحب على المحافظ.';

  @override
  String get searchTransactions => 'بحث في العمليات';

  @override
  String get searchTransactionsHint =>
      'ابحث في العمليات المحمّلة بالاسم أو الملاحظة أو منشئ العملية';

  @override
  String get refreshTransactions => 'تحديث العمليات';

  @override
  String get loadMoreTransactions => 'تحميل المزيد';

  @override
  String get loadingMoreTransactions => 'جارٍ تحميل المزيد...';

  @override
  String get loadMoreTransactionsFailed =>
      'تعذر تحميل مزيد من العمليات. حاول مرة أخرى.';

  @override
  String get loadingTransactions => 'جارٍ تحميل العمليات...';

  @override
  String get unableToLoadTransactions => 'تعذر تحميل العمليات حاليًا.';

  @override
  String get noTransactionsAvailable => 'لا توجد عمليات';

  @override
  String get noMatchingTransactions => 'لا توجد عمليات مطابقة';

  @override
  String get transactionsEmptyMessage => 'ستظهر العمليات المسجلة هنا.';

  @override
  String get transactionsSearchEmptyMessage => 'جرّب بحثًا أو تصفية مختلفة.';

  @override
  String get recordTransaction => 'تسجيل عملية';

  @override
  String get recordTransactionSubtitle =>
      'سجّل التفاصيل بعد تنفيذ العملية فعليًا.';

  @override
  String get transactionDetails => 'تفاصيل العملية';

  @override
  String get wallet => 'المحفظة';

  @override
  String get selectWallet => 'اختر محفظة';

  @override
  String get walletRequired => 'المحفظة مطلوبة';

  @override
  String get transactionType => 'نوع العملية';

  @override
  String get selectCreditOrDebit => 'اختر إيداعًا أو سحبًا';

  @override
  String get transactionTypeRequired => 'نوع العملية مطلوب';

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
  String get branchName => 'الفرع';

  @override
  String get description => 'الوصف';

  @override
  String get occurredAt => 'وقت العملية';

  @override
  String get optionalDescription => 'وصف اختياري';

  @override
  String get createdByUser => 'تم الإنشاء بواسطة';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get saveTransaction => 'حفظ العملية';

  @override
  String get loadingWalletOptions => 'جارٍ تحميل خيارات المحافظ...';

  @override
  String get unableToLoadWalletOptions => 'تعذر تحميل خيارات المحافظ.';

  @override
  String savedTransactionForWallet(String type, String walletName) {
    return 'تم حفظ عملية $type لمحفظة $walletName.';
  }

  @override
  String get ownerSettings => 'الإعدادات';

  @override
  String get ownerSettingsSubtitle =>
      'أدر حسابك، الاشتراك، التفضيلات، وأمان الحساب من مكان واحد.';

  @override
  String get account => 'الحساب';

  @override
  String get accountSubtitle => 'بيانات الحساب الحالية ومساحة العمل.';

  @override
  String get ownerName => 'الاسم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get role => 'الدور';

  @override
  String get workspace => 'مساحة العمل';

  @override
  String get ownerWorkspaceFallback => 'مساحة العمل';

  @override
  String get workspaceSubscription => 'مساحة العمل والاشتراك';

  @override
  String get workspaceSubscriptionSubtitle =>
      'ملخص للقراءة فقط عن اشتراك مساحة العمل.';

  @override
  String get loadingWorkspaceSubscription => 'جارٍ تحميل اشتراك مساحة العمل...';

  @override
  String get unableToLoadSubscription => 'تعذر تحميل ملخص الاشتراك حاليًا.';

  @override
  String get currentPlan => 'الباقة الحالية';

  @override
  String get renewalDate => 'تاريخ التجديد';

  @override
  String get subscriptionAndPlans => 'الاشتراك والباقات';

  @override
  String get subscriptionAndPlansSubtitle =>
      'تابع باقتك الحالية، حدود الاستخدام، وطلبات التجديد.';

  @override
  String get browsePlans => 'استعراض الباقات';

  @override
  String get browsePlansSubtitle =>
      'راجع خيارات الباقات والحدود والأسعار المتاحة.';

  @override
  String get openPlans => 'فتح الباقات';

  @override
  String get openPlansSubtitle => 'راجع مستويات الباقات والحدود المتاحة.';

  @override
  String get requestRenewalSubtitle => 'أرسل طلب تجديد أو ترقية.';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get preferencesSubtitle =>
      'اضبط اللغة والإشعارات والمظهر ومعلومات التطبيق.';

  @override
  String get notificationsEnabledSubtitle => 'مفعلة لتنبيهات التطبيق';

  @override
  String get notificationsDisabledSubtitle => 'معطلة لتنبيهات التطبيق';

  @override
  String get theme => 'المظهر';

  @override
  String get systemDefault => 'إعدادات النظام';

  @override
  String get themeComingSoon => 'إعدادات المظهر هتتوفر لاحقًا.';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get versionLabel => 'الإصدار';

  @override
  String get legalInformation => 'معلومات وقانونيات';

  @override
  String get legalInformationSubtitle =>
      'اطلع على معلومات بسيطة عن تفعيلة والخصوصية وشروط استخدام المنصة.';

  @override
  String get aboutTa2feela => 'عن تفعيلة';

  @override
  String get aboutTa2feelaSubtitle =>
      'تعرف على ما تساعدك تفعيلة على إدارته وكيفية الوصول إلى الدعم.';

  @override
  String get aboutOverviewTitle => 'نظرة سريعة';

  @override
  String get aboutOverviewBody =>
      'تفعيلة تطبيق لإدارة المحافظ يساعدك تتابع المحافظ والعمليات والفروع والمستخدمين والأرباح والاستهلاك اليومي أو الشهري من مكان واحد.';

  @override
  String get aboutMissionTitle => 'ما الذي يمكنك إدارته';

  @override
  String get aboutMissionBody =>
      'من خلال تفعيلة تقدر تراجع أرصدة المحافظ، وتسجل حركة العمليات، وتتابع ربط الفروع والمستخدمين، وتراقب الأرباح، وتشوف تفاصيل الاستهلاك داخل مساحة العمل.';

  @override
  String get aboutContactTitle => 'الإصدار والدعم';

  @override
  String aboutContactBody(String version) {
    return 'دعم تفعيلة متاح من خلال صفحة الدعم داخل التطبيق وقت ما تحتاج مساعدة. إصدار التطبيق الحالي: $version. جهة تواصل الدعم المؤقتة: support@ta2feela.example.';
  }

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicySubtitle =>
      'اعرف البيانات اللي ممكن تفعيلة تستخدمها وليه محتاجاها.';

  @override
  String get privacyCollectionTitle => 'البيانات التي قد نجمعها';

  @override
  String get privacyCollectionBody =>
      'قد تجمع تفعيلة بيانات الحساب والاستخدام مثل اسم المستخدم، والدور، وبيانات المحافظ، وبيانات العمليات، وبيانات ربط الفروع والمستخدمين، وتذاكر الدعم، والسجلات التقنية اللازمة لتشغيل الخدمة.';

  @override
  String get privacyUsageTitle => 'لماذا يتم استخدام البيانات';

  @override
  String get privacyUsageBody =>
      'ممكن نستخدم البيانات دي لتسجيل الدخول، وإدارة المحافظ، وإعداد التقارير، والدعم، والأمان، وتحسين الخدمة عشان التطبيق يشتغل بشكل موثوق لكل مستأجر.';

  @override
  String get privacySecurityTitle => 'الوصول والمشاركة والدعم';

  @override
  String get privacySecurityBody =>
      'لا تبيع تفعيلة بياناتك. الوصول للبيانات يعتمد على الدور ومحدود بنطاق المستأجر. جهة تواصل الدعم المؤقتة: support@ta2feela.example.';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get termsAndConditionsSubtitle =>
      'اطلع على القواعد الأساسية لاستخدام منصة تفعيلة.';

  @override
  String get termsAcceptanceTitle => 'قبول الشروط';

  @override
  String get termsAcceptanceBody =>
      'استمرارك في استخدام تفعيلة يعني قبولك لهذه الشروط. يجب عليك الحفاظ على سرية بيانات الدخول وتأمين الوصول إلى حسابك.';

  @override
  String get termsUsageTitle => 'استخدام الخدمة';

  @override
  String get termsUsageBody =>
      'يجب إدخال بيانات المحافظ والعمليات بشكل صحيح عند استخدام تفعيلة. يُمنع الوصول غير المصرح به أو إساءة الاستخدام أو محاولة استخدام بيانات مستأجر آخر. قد تتوقف الخدمة مؤقتًا أثناء الصيانة.';

  @override
  String get termsResponsibilityTitle => 'مسؤوليات الحساب';

  @override
  String get termsResponsibilityBody =>
      'لا تتحمل تفعيلة المسؤولية عن الخسائر الناتجة عن إدخال بيانات غير صحيح أو إساءة الاستخدام أو النشاط غير المصرح به على الحساب. كل مستخدم مسؤول عن استخدام التطبيق ضمن الصلاحيات المخصصة له.';

  @override
  String get security => 'الأمان';

  @override
  String get securitySubtitle => 'حدّث كلمة المرور وأدر الوصول للحساب.';

  @override
  String get securitySession => 'الأمان والجلسة';

  @override
  String get securitySessionSubtitle =>
      'إجراءات أمان الحساب التجريبية والتحكم في الجلسة.';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordSubtitle => 'حدّث كلمة مرور حسابك بشكل آمن.';

  @override
  String get changePasswordSheetSubtitle =>
      'استخدم كلمة المرور الحالية واختر كلمة جديدة لا تقل عن 8 أحرف.';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get currentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordRequired => 'كلمة المرور الجديدة مطلوبة';

  @override
  String get newPasswordMinLength =>
      'يجب أن تتكون كلمة المرور الجديدة من 8 أحرف على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordRequired => 'أكد كلمة المرور الجديدة';

  @override
  String get confirmPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور بنجاح.';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'ادخل بيانات حسابك لإرسال طلب استعادة كلمة المرور.';

  @override
  String get submitResetRequest => 'إرسال الطلب';

  @override
  String get resetRequestSubmittedFallback =>
      'إذا كان الحساب موجودًا، تم إرسال طلب استعادة كلمة المرور.';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get usernameOrEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get usernameOrEmailRequired =>
      'ادخل اسم المستخدم أو البريد الإلكتروني';

  @override
  String get unableToSubmitResetRequest => 'تعذر إرسال طلب استعادة كلمة المرور';

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
  String get logoutSubtitle => 'تسجيل الخروج من الجلسة الحالية.';

  @override
  String get notificationsComingSoon => 'ستتوفر الإشعارات قريبًا.';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsImportantSection => 'مهم';

  @override
  String get notificationsLowPrioritySection => 'عادي';

  @override
  String get notificationsReadAllLow => 'تحديد الكل كمقروء';

  @override
  String get notificationsReadAll => 'قراءة الكل';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات غير مقروءة';

  @override
  String get notificationsEmptyMessage =>
      'ستظهر الإشعارات غير المقروءة هنا عند الحاجة إلى إجراء.';

  @override
  String get notificationsWalletDailyLimitNearTitle =>
      'الحد اليومي للمحفظة يقترب';

  @override
  String get notificationsWalletDailyLimitNearMessage =>
      'إحدى المحافظ تقترب من حدها اليومي.';

  @override
  String get notificationsWalletDailyLimitExceededTitle =>
      'تم تجاوز الحد اليومي للمحفظة';

  @override
  String get notificationsWalletDailyLimitExceededMessage =>
      'إحدى المحافظ تجاوزت حد الإنفاق اليومي.';

  @override
  String get notificationsWalletMonthlyLimitNearTitle =>
      'الحد الشهري للمحفظة يقترب';

  @override
  String get notificationsWalletMonthlyLimitNearMessage =>
      'إحدى المحافظ تقترب من حدها الشهري.';

  @override
  String get notificationsWalletMonthlyLimitExceededTitle =>
      'تم تجاوز الحد الشهري للمحفظة';

  @override
  String get notificationsWalletMonthlyLimitExceededMessage =>
      'إحدى المحافظ تجاوزت حد الإنفاق الشهري.';

  @override
  String get notificationsTransactionCreatedTitle => 'تم إنشاء عملية جديدة';

  @override
  String get notificationsTransactionCreatedMessage =>
      'تم تسجيل عملية جديدة على إحدى المحافظ.';

  @override
  String get notificationsUnableToLoad => 'تعذر تحميل الإشعارات الآن.';

  @override
  String get notificationsUnableToUpdate => 'تعذر تحديث الإشعارات الآن.';

  @override
  String get genericReportsSubtitle =>
      'شغّل تقارير الخادم بفلاتر مرنة وعرض واضح للبيانات.';

  @override
  String get reportsProductionSubtitle =>
      'راجع الحركة المالية والعمليات والأرباح من خلال تقارير جاهزة.';

  @override
  String get selectReport => 'اختر التقرير';

  @override
  String get selectReportSubtitle => 'اختر التقرير الذي تريد مراجعته.';

  @override
  String get filters => 'الفلاتر';

  @override
  String get dynamicFiltersSubtitle =>
      'تظهر فقط المرشحات التي يدعمها التقرير المحدد.';

  @override
  String get reportFiltersSubtitle =>
      'ضيّق النتائج حسب التاريخ والفرع والمحفظة والخيارات المدعومة.';

  @override
  String get loadingReports => 'جار تحميل التقارير...';

  @override
  String get unableToLoadReports => 'تعذر تحميل التقارير الآن.';

  @override
  String get loadingTransactionsSummaryReport => 'جارٍ تحميل ملخص العمليات...';

  @override
  String get unableToLoadTransactionsSummaryReport =>
      'تعذر تحميل ملخص العمليات حاليًا.';

  @override
  String get loadingProfitSummaryReport => 'جارٍ تحميل ملخص الأرباح...';

  @override
  String get unableToLoadProfitSummaryReport =>
      'تعذر تحميل ملخص الأرباح حاليًا.';

  @override
  String get applyFilters => 'تطبيق';

  @override
  String get clearFilters => 'مسح';

  @override
  String get reportResultsSubtitle => 'النتائج بتظهر مباشرة من بيانات الخادم.';

  @override
  String get noReportData => 'لم يُرجع التقرير المحدد صفوفًا أو قيمًا.';

  @override
  String get unsupportedReportData =>
      'تعذر عرض استجابة هذا التقرير في العرض العام الحالي.';

  @override
  String get fromDate => 'من تاريخ';

  @override
  String get toDate => 'إلى تاريخ';

  @override
  String get walletId => 'معرف المحفظة';

  @override
  String get walletIdHint => 'أدخل معرف المحفظة';

  @override
  String get period => 'الفترة';

  @override
  String get reportTypeTransactionSummary => 'ملخص العمليات';

  @override
  String get reportTypeTransactionSummaryDescription =>
      'تابع إجمالي الإيداع والسحب والصافي وعدد العمليات.';

  @override
  String get reportTypeTransactionDetails => 'تفاصيل العمليات';

  @override
  String get reportTypeTransactionDetailsDescription =>
      'راجع العمليات التفصيلية حسب التاريخ والمحفظة والفرع والمنشئ.';

  @override
  String get reportTypeWalletConsumption => 'استهلاك المحافظ';

  @override
  String get reportTypeProfitSummary => 'ملخص الأرباح';

  @override
  String get reportTypeProfitSummaryDescription =>
      'راجع أرباح المحافظ والأرباح النقدية وإجمالي الأرباح في عرض واحد.';

  @override
  String get reportTypeTransactionTimeAggregation => 'تجميع العمليات حسب الوقت';

  @override
  String get noWalletsInBranch => 'لا توجد محافظ في هذا الفرع';

  @override
  String get reportsFieldsTotalCredits => 'إجمالي الإيداع';

  @override
  String get reportsFieldsTotalDebits => 'إجمالي السحب';

  @override
  String get reportsFieldsNetAmount => 'الصافي';

  @override
  String get reportsFieldsTransactionCount => 'عدد العمليات';

  @override
  String get reportsFieldsWalletName => 'اسم المحفظة';

  @override
  String get reportsFieldsBranchName => 'الفرع';

  @override
  String get reportsFieldsTenantName => 'المؤسسة';

  @override
  String get reportsFieldsDailySpent => 'المصروف اليومي';

  @override
  String get reportsFieldsMonthlySpent => 'المصروف الشهري';

  @override
  String get reportsFieldsDailyLimit => 'الحد اليومي';

  @override
  String get reportsFieldsMonthlyLimit => 'الحد الشهري';

  @override
  String get reportsFieldsDailyPercent => 'النسبة اليومية';

  @override
  String get reportsFieldsMonthlyPercent => 'النسبة الشهرية';

  @override
  String get reportsFieldsUpdatedAt => 'آخر تحديث';

  @override
  String get reportsFieldsActive => 'نشط';

  @override
  String get reportsFieldsNearDailyLimit => 'قريب من الحد اليومي';

  @override
  String get reportsFieldsNearMonthlyLimit => 'قريب من الحد الشهري';

  @override
  String get creditCount => 'عدد الإيداعات';

  @override
  String get debitCount => 'عدد السحوبات';

  @override
  String get activeUsers => 'المستخدمون النشطون';

  @override
  String get totalProfits => 'إجمالي الأرباح';

  @override
  String get totalCollectedProfit => 'إجمالي المتحصل';

  @override
  String get totalUncollectedProfit => 'إجمالي غير المتحصل';

  @override
  String get totalAmount => 'إجمالي المبلغ';

  @override
  String get totalUserProfit => 'إجمالي أرباح المستخدمين';

  @override
  String get walletBalance => 'رصيد المحفظة';

  @override
  String get branchWalletsBalance => 'رصيد محافظ الفرع';

  @override
  String get highestTransactionTitle => 'أعلى عملية';

  @override
  String get walletsWithCurrentProfit => 'المحافظ ذات أرباح حالية';

  @override
  String get totalActiveWallets => 'إجمالي المحافظ الشغالة';

  @override
  String get profitSummaryBusinessNote =>
      'المتحصل في الفترة المحددة + غير المتحصل الحالي';

  @override
  String get usersPerformanceSectionTitle => 'أداء المستخدمين';

  @override
  String get userProfit => 'ربح المستخدم';

  @override
  String get loadingUserPerformanceReport => 'جارٍ تحميل أداء المستخدمين...';

  @override
  String get unableToLoadUserPerformanceReport =>
      'تعذر تحميل أداء المستخدمين حاليًا.';

  @override
  String get noUserPerformanceResultsTitle => 'لا يوجد مستخدمون';

  @override
  String get noUserPerformanceResultsMessage =>
      'لم يطابق أي مستخدم فلاتر التقرير الحالية.';

  @override
  String get allTypes => 'كل الأنواع';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get endOfResults => 'نهاية النتائج';

  @override
  String get loadingTransactionDetailsReport => 'جارٍ تحميل تفاصيل العمليات...';

  @override
  String get unableToLoadTransactionDetailsReport =>
      'تعذر تحميل تفاصيل العمليات حاليًا.';

  @override
  String get noTransactionsFound => 'لا توجد عمليات';

  @override
  String get noTransactionsMatchedCurrentFilters =>
      'لم تطابق أي عملية الفلاتر الحالية.';

  @override
  String get noHighestTransactionTitle => 'لا توجد أعلى عملية';

  @override
  String get noHighestTransactionMessage =>
      'لم تطابق أي عملية الفلاتر الحالية.';

  @override
  String get totalTransactions => 'إجمالي العمليات';

  @override
  String get transactionCount => 'عدد العمليات';

  @override
  String get net => 'الصافي';

  @override
  String get netAmount => 'الصافي';

  @override
  String pageSummary(String page, String totalPages, String totalElements) {
    return 'الصفحة $page من $totalPages - $totalElements عنصر';
  }

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInSubtitle => 'استخدم حسابك للوصول للمحافظ والتقارير.';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'ادخل كلمة المرور';

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
      'بيستخدم نقطة المصادقة الحالية وبيحفظ الجلسة محليًا.';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'كلمة المرور قصيرة جدًا';

  @override
  String get loginHeroSubtitle =>
      'وصول من الموبايل لمتابعة المحافظ وتسجيل العمليات والتقارير.';

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
    return 'بواسطة: $name';
  }

  @override
  String transactionSavedRef(String referenceId) {
    return 'تم حفظ العملية بنجاح. المرجع: $referenceId';
  }

  @override
  String get branchDirectory => 'دليل الفروع';

  @override
  String get branchDirectorySubtitle =>
      'راجع الفروع والتغطية وتعيين المحافظ والمستخدمين.';

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
  String get createBranch => 'إنشاء فرع';

  @override
  String get editBranch => 'تعديل فرع';

  @override
  String get deleteBranch => 'حذف فرع';

  @override
  String get branchCreatedSuccessfully => 'تم إنشاء الفرع بنجاح';

  @override
  String get branchUpdatedSuccessfully => 'تم تحديث الفرع بنجاح';

  @override
  String get branchDeletedSuccessfully => 'تم حذف الفرع بنجاح';

  @override
  String get branchNameRequired => 'اسم الفرع مطلوب';

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
      'راجع الحسابات وتعيين الفروع وحالة النشاط.';

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
  String get createUser => 'إنشاء مستخدم';

  @override
  String get editUser => 'تعديل مستخدم';

  @override
  String get deleteUser => 'حذف مستخدم';

  @override
  String get assignBranch => 'تعيين فرع';

  @override
  String get unassignBranch => 'إلغاء تعيين الفرع';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get confirmUnassign => 'تأكيد إلغاء التعيين';

  @override
  String get userCreatedSuccessfully => 'تم إنشاء المستخدم بنجاح';

  @override
  String get userUpdatedSuccessfully => 'تم تحديث المستخدم بنجاح';

  @override
  String get userDeletedSuccessfully => 'تم حذف المستخدم بنجاح';

  @override
  String get userAssignedToBranchSuccessfully =>
      'تم تعيين المستخدم للفرع بنجاح';

  @override
  String get userUnassignedFromBranchSuccessfully =>
      'تم إلغاء تعيين المستخدم من الفرع بنجاح';

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
      'تابع حالة الباقة وحدود مساحة العمل قبل موعد التجديد القادم.';

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
  String get currencyEgp => 'جنيه';

  @override
  String get monthlyBillingPeriod => 'شهريًا';

  @override
  String planPricePerMonth(String currency, String price, String period) {
    return '$price $currency / $period';
  }

  @override
  String get enterpriseUpgradeComingSoon =>
      'مراجعة ترقية Enterprise هتتوصل لاحقًا.';

  @override
  String planSelectionComingSoon(String planName) {
    return 'اختيار $planName هيتوصل لاحقًا.';
  }

  @override
  String get unableToSignIn => 'تعذر تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get unableToSaveTransaction => 'تعذر حفظ العملية. حاول مرة أخرى.';

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get walletLoadError => 'تعذر تحميل المحافظ. حاول مرة أخرى.';

  @override
  String get walletCreateError => 'تعذر إنشاء المحفظة. حاول مرة أخرى.';

  @override
  String get walletUpdateError => 'تعذر تحديث المحفظة. حاول مرة أخرى.';

  @override
  String get walletDeleteError => 'تعذر حذف المحفظة. حاول مرة أخرى.';

  @override
  String get support => 'الدعم الفني';

  @override
  String get supportTickets => 'تذاكر الدعم الفني';

  @override
  String get supportSubtitle => 'هل تحتاج مساعدة؟ أرسل طلب دعم إلى فريقنا.';

  @override
  String get newTicket => 'تذكرة جديدة';

  @override
  String get noSupportTicketsYet => 'لا توجد تذاكر دعم حتى الآن.';

  @override
  String get invalidUsernameOrPassword =>
      'اسم المستخدم أو كلمة المرور غير صحيحة';

  @override
  String get fileTooLarge => 'حجم الملف كبير جدًا';

  @override
  String get unsupportedFileType => 'نوع الملف غير مدعوم';

  @override
  String get validationError => 'يرجى مراجعة البيانات المدخلة';

  @override
  String get forbiddenError => 'لا تملك صلاحية تنفيذ هذا الإجراء';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get branchLimitReachedForCurrentPlan =>
      'تم الوصول للحد الأقصى للفروع في الخطة الحالية';

  @override
  String get userLimitReachedForCurrentPlan =>
      'تم الوصول للحد الأقصى للمستخدمين في الخطة الحالية';

  @override
  String get walletLimitReachedForCurrentPlan =>
      'تم الوصول للحد الأقصى للمحافظ في الخطة الحالية';

  @override
  String get dataConflict => 'يوجد تعارض مع بيانات موجودة';

  @override
  String get unableToSubmitSupportRequest => 'تعذر إرسال طلب الدعم';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get subject => 'الموضوع';

  @override
  String get supportMessage => 'الرسالة';

  @override
  String get subjectRequired => 'الموضوع مطلوب';

  @override
  String get supportMessageRequired => 'الرسالة مطلوبة';

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get descriptionRequired => 'الوصف مطلوب';

  @override
  String get priority => 'الأولوية';

  @override
  String get priorityRequired => 'الأولوية مطلوبة';

  @override
  String get resolvedAt => 'تاريخ الحل';

  @override
  String get sendSupportRequest => 'إرسال طلب الدعم';

  @override
  String get supportRequestSent => 'تم إرسال طلب الدعم بنجاح.';

  @override
  String get unableToSendSupportRequest =>
      'تعذر إرسال طلب الدعم. حاول مرة أخرى.';

  @override
  String get unableToLoadSupportTickets =>
      'تعذر تحميل تذاكر الدعم. حاول مرة أخرى.';

  @override
  String get low => 'منخفضة';

  @override
  String get medium => 'متوسطة';

  @override
  String get high => 'عالية';

  @override
  String get renewalRequest => 'طلب تجديد';

  @override
  String get renewalRequests => 'طلبات التجديد';

  @override
  String get renewalRequestSubtitle =>
      'اطلب تجديد اشتراك مساحة العمل الخاصة بك.';

  @override
  String get newRequest => 'طلب جديد';

  @override
  String get noRenewalRequestsYet => 'لا توجد طلبات تجديد حتى الآن.';

  @override
  String get submitRenewalRequest => 'إرسال طلب التجديد';

  @override
  String get renewalRequestSubmitted => 'تم إرسال طلب التجديد بنجاح.';

  @override
  String get unableToSubmitRenewalRequest => 'تعذر إرسال طلب التجديد';

  @override
  String get unableToLoadRenewalRequests =>
      'تعذر تحميل طلبات التجديد. حاول مرة أخرى.';

  @override
  String get requestedAt => 'تاريخ الطلب';

  @override
  String get reviewedAt => 'تاريخ المراجعة';

  @override
  String get adminNote => 'ملاحظة الإدارة';

  @override
  String get periodMonths => 'المدة (بالشهور)';

  @override
  String get periodMonthsRequired => 'المدة مطلوبة';

  @override
  String get positivePeriodRequired => 'أدخل عدد شهور صحيح';

  @override
  String get password_optional_hint => 'سيبه فاضي لو مش عايز تغيّره';

  @override
  String get today => 'اليوم';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get thisYear => 'هذا العام';

  @override
  String get custom => 'مخصص';

  @override
  String get reportsHomeTitle => 'التقارير';

  @override
  String get reportsHomeSubtitle =>
      'اختر تقرير لمراجعة الحركة المالية والأرباح وأداء المستخدمين.';

  @override
  String get transactionsSummaryReportTitle => 'ملخص العمليات';

  @override
  String get transactionsSummaryReportDescription =>
      'ملخص الإيداعات والسحوبات وعدد العمليات وأعلى عملية حسب الفلاتر.';

  @override
  String get profitSummaryReportTitle => 'ملخص الأرباح';

  @override
  String get profitSummaryReportDescription =>
      'تابع ملخص الأرباح المحصلة وغير المحصلة والأرصدة.';

  @override
  String get userPerformanceReportTitle => 'أداء المستخدمين';

  @override
  String get userPerformanceReportDescription =>
      'حلل أداء المستخدمين وعدد العمليات وإجمالي الأرباح لكل مستخدم.';

  @override
  String get transactionDetailsReportTitle => 'تفاصيل العمليات';

  @override
  String get transactionDetailsReportDescription =>
      'راجع تفاصيل العمليات وابحث وفلتر حسب المحفظة أو الفرع أو المستخدم.';

  @override
  String get reportsPlaceholderMessage => 'شاشة التقرير دي هتتوفر لاحقًا.';
}

/// The translations for Arabic, as used in Egypt (`ar_EG`).
class AppLocalizationsArEg extends AppLocalizationsAr {
  AppLocalizationsArEg() : super('ar_EG');

  @override
  String get appName => 'تفعيلة';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'عربي';

  @override
  String get dashboard => 'الرئيسية';

  @override
  String get wallets => 'المحافظ';

  @override
  String get transactions => 'العمليات';

  @override
  String get createTransaction => 'إنشاء عملية';

  @override
  String get newTransaction => 'عملية جديدة';

  @override
  String get userDashboardTitle => 'الرئيسية';

  @override
  String get dashboardToday => 'اليوم';

  @override
  String get userDashboardSubtitle =>
      'تابع عملياتك اليومية ونفّذ المطلوب بسرعة.';

  @override
  String get dashboardCredits => 'إجمالي الإيداع';

  @override
  String get dashboardDebits => 'إجمالي السحب';

  @override
  String get dashboardProfitSnapshot => 'الأرباح';

  @override
  String get dashboardCollectedProfit => 'المتحصل';

  @override
  String get dashboardUncollectedProfit => 'غير المتحصل';

  @override
  String get dashboardTransactionVolume => 'قيمة العمليات';

  @override
  String get dashboardWalletHealth => 'حالة المحافظ';

  @override
  String get dashboardActiveBalance => 'الرصيد المتاح';

  @override
  String get dashboardNearDailyLimit => 'قريب من حد اليوم';

  @override
  String get dashboardNearMonthlyLimit => 'قريب من حد الشهر';

  @override
  String get dashboardLimitReached => 'وصل للحد';

  @override
  String get dashboardDailyLimitReached => 'وصل لحد اليوم';

  @override
  String get dashboardMonthlyLimitReached => 'وصل لحد الشهر';

  @override
  String dashboardReviewWalletsNeedingAttention(int count) {
    return 'راجع $count محافظ محتاجة متابعة';
  }

  @override
  String get dashboardAllWalletsHealthy => 'كل المحافظ تمام';

  @override
  String get dashboardHealthStatusGood => 'تمام';

  @override
  String get dashboardHealthStatusWarning => 'محتاجة متابعة';

  @override
  String get dashboardHealthStatusCritical => 'حرج';

  @override
  String get dashboardSeverityWarning => 'تحذير';

  @override
  String get dashboardSeverityCritical => 'حرج';

  @override
  String get dashboardSeverityInfo => 'معلومة';

  @override
  String get recentTransactions => 'آخر العمليات';

  @override
  String get noRecentTransactions => 'لا توجد عمليات حديثة';

  @override
  String get recentTransactionsEmptyMessage =>
      'ستظهر أحدث عملياتك هنا عند توفرها.';

  @override
  String get transactionCredit => 'إيداع';

  @override
  String get transactionDebit => 'سحب';

  @override
  String get userDashboardUnableToLoadSummary => 'تعذر تحميل نشاط اليوم الآن.';

  @override
  String get reports => 'التقارير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get plans => 'الباقات';

  @override
  String get subscriptionExpiredTitle => 'انتهى الاشتراك';

  @override
  String get organizationSubscriptionExpiredTitle => 'اشتراك المؤسسة منتهي';

  @override
  String get subscriptionExpiredMessageOwner =>
      'انتهى اشتراك المؤسسة الخاصة بك. يلزم التجديد لاستعادة الوصول إلى خصائص العمل.';

  @override
  String get subscriptionExpiredMessageUser =>
      'انتهى اشتراك المؤسسة الخاصة بك. يرجى التواصل مع مالك الحساب لتجديده.';

  @override
  String get subscriptionExpiredDateLabel => 'تاريخ الانتهاء';

  @override
  String get subscriptionPlanLabel => 'الباقة الحالية';

  @override
  String get requestRenewal => 'طلب التجديد';

  @override
  String get renewalRequestSent =>
      'تم إرسال طلب التجديد بنجاح. طلبك الآن قيد المراجعة.';

  @override
  String get renewalRequestPending => 'يوجد بالفعل طلب تجديد قيد المراجعة.';

  @override
  String get renewalRequestFailed => 'تعذر إرسال طلب التجديد.';

  @override
  String get recheckStatus => 'إعادة التحقق';

  @override
  String get subscriptionStillExpired =>
      'ما زال الاشتراك منتهيًا أو الطلب قيد المراجعة.';

  @override
  String get subscriptionReactivated =>
      'أصبح الاشتراك فعالًا مرة أخرى. يتم تحويلك الآن.';

  @override
  String get contactAccountOwner => 'تواصل مع مالك الحساب للمساعدة في التجديد.';

  @override
  String get backToExpiredSubscription => 'العودة إلى صفحة انتهاء الاشتراك';

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
  String get credits => 'الإيداع';

  @override
  String get debits => 'السحب';

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
  String get filter => 'فلترة';

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
  String get overview => 'نظرة سريعة';

  @override
  String get profit => 'الأرباح';

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
  String get portfolioOverview => 'نظرة سريعة على المحافظ';

  @override
  String get portfolioOverviewSubtitle => 'تابع الرصيد وحركة المحافظ بتاعتك.';

  @override
  String get latestTransactions => 'آخر العمليات';

  @override
  String get latestTransactionsSubtitle => 'أحدث العمليات المسجلة على المحافظ.';

  @override
  String get lastTransactions => 'آخر العمليات';

  @override
  String get totalCredits => 'إجمالي الإيداع';

  @override
  String get totalDebits => 'إجمالي السحب';

  @override
  String get transactionVolume => 'حجم العمليات';

  @override
  String get transactionsCount => 'عدد العمليات';

  @override
  String get totalProfit => 'إجمالي الأرباح';

  @override
  String get walletStatus => 'حالة المحافظ';

  @override
  String get walletConsumptions => 'استهلاك المحافظ';

  @override
  String get walletConsumptionsEmptyMessage =>
      'ستظهر بيانات استهلاك المحافظ هنا.';

  @override
  String get totalWalletProfit => 'إجمالي أرباح المحافظ';

  @override
  String get totalCashProfit => 'إجمالي أرباح الكاش';

  @override
  String get nearLimitWallets => 'المحافظ القريبة من الحد';

  @override
  String get viewAll => 'عرض الكل';

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
  String get sortWallets => 'ترتيب المحافظ';

  @override
  String get walletSortDefaultOrder => 'الترتيب الافتراضي';

  @override
  String get walletSortNearLimitFirst => 'الأقرب للحد أولاً';

  @override
  String get walletSortHighestDailyUsage => 'الأعلى في الاستخدام اليومي';

  @override
  String get walletSortHighestMonthlyUsage => 'الأعلى في الاستخدام الشهري';

  @override
  String get walletSortHighestLimit => 'أعلى حد';

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
  String get walletCurrentBalance => 'الرصيد الحالي';

  @override
  String get walletTypeLabel => 'نوع المحفظة';

  @override
  String get walletStatusLabel => 'حالة المحفظة';

  @override
  String get dailyLimitLabel => 'الحد اليومي';

  @override
  String get monthlyLimitLabel => 'الحد الشهري';

  @override
  String get selectBranch => 'اختر الفرع';

  @override
  String get selectWalletType => 'اختر نوع المحفظة';

  @override
  String get walletNumberRequired => 'رقم المحفظة مطلوب';

  @override
  String get balanceRequired => 'الرصيد مطلوب';

  @override
  String get validAmountRequired => 'أدخل مبلغًا صحيحًا';

  @override
  String get dailyLimitRequired => 'الحد اليومي مطلوب';

  @override
  String get monthlyLimitRequired => 'الحد الشهري مطلوب';

  @override
  String get validLimitRequired => 'أدخل حدًا صحيحًا';

  @override
  String get branchRequired => 'الفرع مطلوب';

  @override
  String get walletTypeRequired => 'نوع المحفظة مطلوب';

  @override
  String get noWalletTypesAvailable => 'لا توجد أنواع محافظ متاحة';

  @override
  String get failedToLoadBranches => 'تعذر تحميل الفروع';

  @override
  String get failedToLoadWalletTypes => 'تعذر تحميل أنواع المحافظ';

  @override
  String get sessionExpiredLoginAgain => 'انتهت الجلسة، سجّل دخولك مرة تانية';

  @override
  String get invalidSessionLoginAgain =>
      'الجلسة غير صالحة، سجّل دخولك مرة تانية';

  @override
  String get accountDisabledMessage => 'تم تعطيل هذا الحساب';

  @override
  String get walletDailyConsumption => 'الاستهلاك اليومي';

  @override
  String get walletMonthlyConsumption => 'الاستهلاك الشهري';

  @override
  String get walletProfitLabel => 'أرباح المحفظة';

  @override
  String get walletCashProfit => 'الربح النقدي';

  @override
  String get walletTotalLabel => 'الإجمالي';

  @override
  String get totalProfitLabel => 'إجمالي الأرباح';

  @override
  String get noCollectionYet => 'لا يوجد تحصيل بعد';

  @override
  String lastCollectionWithDate(String date) {
    return 'آخر تحصيل: $date';
  }

  @override
  String lastCollectionWithDateByName(String date, String name) {
    return 'آخر تحصيل: $date بواسطة $name';
  }

  @override
  String get collectProfit => 'تحصيل الأرباح';

  @override
  String get currentWalletProfit => 'أرباح المحفظة الحالية';

  @override
  String get currentCashProfit => 'أرباح الكاش الحالية';

  @override
  String get walletProfitAmount => 'مبلغ أرباح المحفظة';

  @override
  String get cashProfitAmount => 'مبلغ أرباح الكاش';

  @override
  String get optionalNote => 'ملاحظة اختيارية';

  @override
  String get collectProfitAmountRequired =>
      'أدخل مبلغًا أكبر من 0 في أرباح المحفظة أو أرباح الكاش.';

  @override
  String get walletProfitAmountExceeds =>
      'لا يمكن أن يتجاوز مبلغ أرباح المحفظة الربح الحالي للمحفظة.';

  @override
  String get cashProfitAmountExceeds =>
      'لا يمكن أن يتجاوز مبلغ أرباح الكاش الربح النقدي الحالي.';

  @override
  String get collectProfitSuccess => 'تم تحصيل الأرباح بنجاح.';

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
  String get transactionsHistory => 'سجل العمليات';

  @override
  String get transactionsHistorySubtitle =>
      'ابحث وراجع عمليات الإيداع والسحب على المحافظ.';

  @override
  String get searchTransactions => 'بحث في العمليات';

  @override
  String get searchTransactionsHint =>
      'ابحث في العمليات المحمّلة بالاسم أو الملاحظة أو منشئ العملية';

  @override
  String get refreshTransactions => 'تحديث العمليات';

  @override
  String get loadMoreTransactions => 'تحميل المزيد';

  @override
  String get loadingMoreTransactions => 'جارٍ تحميل المزيد...';

  @override
  String get loadMoreTransactionsFailed =>
      'تعذر تحميل مزيد من العمليات. حاول مرة أخرى.';

  @override
  String get loadingTransactions => 'جارٍ تحميل العمليات...';

  @override
  String get unableToLoadTransactions => 'تعذر تحميل العمليات حاليًا.';

  @override
  String get noTransactionsAvailable => 'لا توجد عمليات';

  @override
  String get noMatchingTransactions => 'لا توجد عمليات مطابقة';

  @override
  String get transactionsEmptyMessage => 'ستظهر العمليات المسجلة هنا.';

  @override
  String get transactionsSearchEmptyMessage => 'جرّب بحثًا أو تصفية مختلفة.';

  @override
  String get recordTransaction => 'تسجيل عملية';

  @override
  String get recordTransactionSubtitle =>
      'سجّل التفاصيل بعد تنفيذ العملية فعليًا.';

  @override
  String get transactionDetails => 'تفاصيل العملية';

  @override
  String get wallet => 'المحفظة';

  @override
  String get selectWallet => 'اختر محفظة';

  @override
  String get walletRequired => 'المحفظة مطلوبة';

  @override
  String get transactionType => 'نوع العملية';

  @override
  String get selectCreditOrDebit => 'اختر إيداعًا أو سحبًا';

  @override
  String get transactionTypeRequired => 'نوع العملية مطلوب';

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
  String get branchName => 'الفرع';

  @override
  String get description => 'الوصف';

  @override
  String get occurredAt => 'وقت العملية';

  @override
  String get optionalDescription => 'وصف اختياري';

  @override
  String get createdByUser => 'تم الإنشاء بواسطة';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get saveTransaction => 'حفظ العملية';

  @override
  String get loadingWalletOptions => 'جارٍ تحميل خيارات المحافظ...';

  @override
  String get unableToLoadWalletOptions => 'تعذر تحميل خيارات المحافظ.';

  @override
  String savedTransactionForWallet(String type, String walletName) {
    return 'تم حفظ عملية $type لمحفظة $walletName.';
  }

  @override
  String get ownerSettings => 'الإعدادات';

  @override
  String get ownerSettingsSubtitle =>
      'أدر حسابك، الاشتراك، التفضيلات، وأمان الحساب من مكان واحد.';

  @override
  String get account => 'الحساب';

  @override
  String get accountSubtitle => 'بيانات الحساب الحالية ومساحة العمل.';

  @override
  String get ownerName => 'الاسم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get role => 'الدور';

  @override
  String get workspace => 'مساحة العمل';

  @override
  String get ownerWorkspaceFallback => 'مساحة العمل';

  @override
  String get workspaceSubscription => 'مساحة العمل والاشتراك';

  @override
  String get workspaceSubscriptionSubtitle =>
      'ملخص للقراءة فقط عن اشتراك مساحة العمل.';

  @override
  String get loadingWorkspaceSubscription => 'جارٍ تحميل اشتراك مساحة العمل...';

  @override
  String get unableToLoadSubscription => 'تعذر تحميل ملخص الاشتراك حاليًا.';

  @override
  String get currentPlan => 'الباقة الحالية';

  @override
  String get renewalDate => 'تاريخ التجديد';

  @override
  String get subscriptionAndPlans => 'الاشتراك والباقات';

  @override
  String get subscriptionAndPlansSubtitle =>
      'تابع باقتك الحالية، حدود الاستخدام، وطلبات التجديد.';

  @override
  String get browsePlans => 'استعراض الباقات';

  @override
  String get browsePlansSubtitle =>
      'راجع خيارات الباقات والحدود والأسعار المتاحة.';

  @override
  String get openPlans => 'فتح الباقات';

  @override
  String get openPlansSubtitle => 'راجع مستويات الباقات والحدود المتاحة.';

  @override
  String get requestRenewalSubtitle => 'أرسل طلب تجديد أو ترقية.';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get preferencesSubtitle =>
      'اضبط اللغة والإشعارات والمظهر ومعلومات التطبيق.';

  @override
  String get notificationsEnabledSubtitle => 'مفعلة لتنبيهات التطبيق';

  @override
  String get notificationsDisabledSubtitle => 'معطلة لتنبيهات التطبيق';

  @override
  String get theme => 'المظهر';

  @override
  String get systemDefault => 'إعدادات النظام';

  @override
  String get themeComingSoon => 'إعدادات المظهر هتتوفر لاحقًا.';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get versionLabel => 'الإصدار';

  @override
  String get legalInformation => 'معلومات وقانونيات';

  @override
  String get legalInformationSubtitle =>
      'اطلع على معلومات بسيطة عن تفعيلة والخصوصية وشروط استخدام المنصة.';

  @override
  String get aboutTa2feela => 'عن تفعيلة';

  @override
  String get aboutTa2feelaSubtitle =>
      'تعرف على ما تساعدك تفعيلة على إدارته وكيفية الوصول إلى الدعم.';

  @override
  String get aboutOverviewTitle => 'نظرة سريعة';

  @override
  String get aboutOverviewBody =>
      'تفعيلة تطبيق لإدارة المحافظ يساعدك تتابع المحافظ والعمليات والفروع والمستخدمين والأرباح والاستهلاك اليومي أو الشهري من مكان واحد.';

  @override
  String get aboutMissionTitle => 'ما الذي يمكنك إدارته';

  @override
  String get aboutMissionBody =>
      'من خلال تفعيلة تقدر تراجع أرصدة المحافظ، وتسجل حركة العمليات، وتتابع ربط الفروع والمستخدمين، وتراقب الأرباح، وتشوف تفاصيل الاستهلاك داخل مساحة العمل.';

  @override
  String get aboutContactTitle => 'الإصدار والدعم';

  @override
  String aboutContactBody(String version) {
    return 'دعم تفعيلة متاح من خلال صفحة الدعم داخل التطبيق وقت ما تحتاج مساعدة. إصدار التطبيق الحالي: $version. جهة تواصل الدعم المؤقتة: support@ta2feela.example.';
  }

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicySubtitle =>
      'اعرف البيانات اللي ممكن تفعيلة تستخدمها وليه محتاجاها.';

  @override
  String get privacyCollectionTitle => 'البيانات التي قد نجمعها';

  @override
  String get privacyCollectionBody =>
      'قد تجمع تفعيلة بيانات الحساب والاستخدام مثل اسم المستخدم، والدور، وبيانات المحافظ، وبيانات المعاملات، وبيانات ربط الفروع والمستخدمين، وتذاكر الدعم، والسجلات التقنية اللازمة لتشغيل الخدمة.';

  @override
  String get privacyUsageTitle => 'لماذا يتم استخدام البيانات';

  @override
  String get privacyUsageBody =>
      'ممكن نستخدم البيانات دي لتسجيل الدخول، وإدارة المحافظ، وإعداد التقارير، والدعم، والأمان، وتحسين الخدمة عشان التطبيق يشتغل بشكل موثوق لكل مستأجر.';

  @override
  String get privacySecurityTitle => 'الوصول والمشاركة والدعم';

  @override
  String get privacySecurityBody =>
      'لا تبيع تفعيلة بياناتك. الوصول إلى البيانات يعتمد على الدور ومحدود بنطاق المستأجر. جهة تواصل الدعم المؤقتة: support@ta2feela.example.';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get termsAndConditionsSubtitle =>
      'اطلع على القواعد الأساسية لاستخدام منصة تفعيلة.';

  @override
  String get termsAcceptanceTitle => 'قبول الشروط';

  @override
  String get termsAcceptanceBody =>
      'استمرارك في استخدام تفعيلة يعني قبولك لهذه الشروط. يجب عليك الحفاظ على سرية بيانات الدخول وتأمين الوصول إلى حسابك.';

  @override
  String get termsUsageTitle => 'استخدام الخدمة';

  @override
  String get termsUsageBody =>
      'يجب إدخال بيانات المحافظ والمعاملات بشكل صحيح عند استخدام تفعيلة. يُمنع الوصول غير المصرح به أو إساءة الاستخدام أو محاولة استخدام بيانات مستأجر آخر. قد تتوقف الخدمة مؤقتًا أثناء الصيانة.';

  @override
  String get termsResponsibilityTitle => 'مسؤوليات الحساب';

  @override
  String get termsResponsibilityBody =>
      'لا تتحمل تفعيلة المسؤولية عن الخسائر الناتجة عن إدخال بيانات غير صحيح أو إساءة الاستخدام أو النشاط غير المصرح به على الحساب. كل مستخدم مسؤول عن استخدام التطبيق ضمن الصلاحيات المخصصة له.';

  @override
  String get security => 'الأمان';

  @override
  String get securitySubtitle => 'حدّث كلمة المرور وأدر الوصول للحساب.';

  @override
  String get securitySession => 'الأمان والجلسة';

  @override
  String get securitySessionSubtitle =>
      'إجراءات أمان الحساب التجريبية والتحكم في الجلسة.';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordSubtitle => 'حدّث كلمة مرور حسابك بشكل آمن.';

  @override
  String get changePasswordSheetSubtitle =>
      'استخدم كلمة المرور الحالية واختر كلمة جديدة لا تقل عن 8 أحرف.';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get currentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordRequired => 'كلمة المرور الجديدة مطلوبة';

  @override
  String get newPasswordMinLength =>
      'يجب أن تتكون كلمة المرور الجديدة من 8 أحرف على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordRequired => 'أكد كلمة المرور الجديدة';

  @override
  String get confirmPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور بنجاح.';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'ادخل بيانات حسابك لإرسال طلب استعادة كلمة المرور.';

  @override
  String get submitResetRequest => 'إرسال الطلب';

  @override
  String get resetRequestSubmittedFallback =>
      'إذا كان الحساب موجودًا، تم إرسال طلب استعادة كلمة المرور.';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get usernameOrEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get usernameOrEmailRequired =>
      'ادخل اسم المستخدم أو البريد الإلكتروني';

  @override
  String get unableToSubmitResetRequest => 'تعذر إرسال طلب استعادة كلمة المرور';

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
  String get logoutSubtitle => 'تسجيل الخروج من الجلسة الحالية.';

  @override
  String get notificationsComingSoon => 'ستتوفر الإشعارات قريبًا.';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsImportantSection => 'مهم';

  @override
  String get notificationsLowPrioritySection => 'عادي';

  @override
  String get notificationsReadAllLow => 'تحديد الكل كمقروء';

  @override
  String get notificationsReadAll => 'قراءة الكل';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات غير مقروءة';

  @override
  String get notificationsEmptyMessage =>
      'ستظهر الإشعارات غير المقروءة هنا عند الحاجة إلى إجراء.';

  @override
  String get notificationsWalletDailyLimitNearTitle =>
      'الحد اليومي للمحفظة يقترب';

  @override
  String get notificationsWalletDailyLimitNearMessage =>
      'إحدى المحافظ تقترب من حدها اليومي.';

  @override
  String get notificationsWalletDailyLimitExceededTitle =>
      'تم تجاوز الحد اليومي للمحفظة';

  @override
  String get notificationsWalletDailyLimitExceededMessage =>
      'إحدى المحافظ تجاوزت حد الإنفاق اليومي.';

  @override
  String get notificationsWalletMonthlyLimitNearTitle =>
      'الحد الشهري للمحفظة يقترب';

  @override
  String get notificationsWalletMonthlyLimitNearMessage =>
      'إحدى المحافظ تقترب من حدها الشهري.';

  @override
  String get notificationsWalletMonthlyLimitExceededTitle =>
      'تم تجاوز الحد الشهري للمحفظة';

  @override
  String get notificationsWalletMonthlyLimitExceededMessage =>
      'إحدى المحافظ تجاوزت حد الإنفاق الشهري.';

  @override
  String get notificationsTransactionCreatedTitle => 'تم إنشاء معاملة جديدة';

  @override
  String get notificationsTransactionCreatedMessage =>
      'تم تسجيل معاملة جديدة على إحدى المحافظ.';

  @override
  String get notificationsUnableToLoad => 'تعذر تحميل الإشعارات الآن.';

  @override
  String get notificationsUnableToUpdate => 'تعذر تحديث الإشعارات الآن.';

  @override
  String get genericReportsSubtitle =>
      'شغّل تقارير الخادم بفلاتر مرنة وعرض واضح للبيانات.';

  @override
  String get reportsProductionSubtitle =>
      'راجع الحركة المالية والعمليات والأرباح من خلال تقارير جاهزة.';

  @override
  String get selectReport => 'اختر التقرير';

  @override
  String get selectReportSubtitle => 'اختر التقرير الذي تريد مراجعته.';

  @override
  String get filters => 'الفلاتر';

  @override
  String get dynamicFiltersSubtitle =>
      'تظهر فقط المرشحات التي يدعمها التقرير المحدد.';

  @override
  String get reportFiltersSubtitle =>
      'ضيّق النتائج حسب التاريخ والفرع والمحفظة والخيارات المدعومة.';

  @override
  String get loadingReports => 'جار تحميل التقارير...';

  @override
  String get unableToLoadReports => 'تعذر تحميل التقارير الآن.';

  @override
  String get loadingTransactionsSummaryReport => 'جارٍ تحميل ملخص العمليات...';

  @override
  String get unableToLoadTransactionsSummaryReport =>
      'تعذر تحميل ملخص العمليات حاليًا.';

  @override
  String get loadingProfitSummaryReport => 'جارٍ تحميل ملخص الأرباح...';

  @override
  String get unableToLoadProfitSummaryReport =>
      'تعذر تحميل ملخص الأرباح حاليًا.';

  @override
  String get applyFilters => 'تطبيق';

  @override
  String get clearFilters => 'مسح';

  @override
  String get reportResultsSubtitle => 'النتائج بتظهر مباشرة من بيانات الخادم.';

  @override
  String get noReportData => 'لم يُرجع التقرير المحدد صفوفًا أو قيمًا.';

  @override
  String get unsupportedReportData =>
      'تعذر عرض استجابة هذا التقرير في العرض العام الحالي.';

  @override
  String get fromDate => 'من تاريخ';

  @override
  String get toDate => 'إلى تاريخ';

  @override
  String get walletId => 'معرف المحفظة';

  @override
  String get walletIdHint => 'أدخل معرف المحفظة';

  @override
  String get period => 'الفترة';

  @override
  String get reportTypeTransactionSummary => 'ملخص العمليات';

  @override
  String get reportTypeTransactionSummaryDescription =>
      'تابع إجمالي الإيداع والسحب والصافي وعدد العمليات.';

  @override
  String get reportTypeTransactionDetails => 'تفاصيل العمليات';

  @override
  String get reportTypeTransactionDetailsDescription =>
      'راجع العمليات التفصيلية حسب التاريخ والمحفظة والفرع والمنشئ.';

  @override
  String get reportTypeWalletConsumption => 'استهلاك المحافظ';

  @override
  String get reportTypeProfitSummary => 'ملخص الأرباح';

  @override
  String get reportTypeProfitSummaryDescription =>
      'راجع أرباح المحافظ والأرباح النقدية وإجمالي الأرباح في عرض واحد.';

  @override
  String get reportTypeTransactionTimeAggregation => 'تجميع العمليات حسب الوقت';

  @override
  String get noWalletsInBranch => 'لا توجد محافظ في هذا الفرع';

  @override
  String get reportsFieldsTotalCredits => 'إجمالي الإيداع';

  @override
  String get reportsFieldsTotalDebits => 'إجمالي السحب';

  @override
  String get reportsFieldsNetAmount => 'الصافي';

  @override
  String get reportsFieldsTransactionCount => 'عدد العمليات';

  @override
  String get reportsFieldsWalletName => 'اسم المحفظة';

  @override
  String get reportsFieldsBranchName => 'الفرع';

  @override
  String get reportsFieldsTenantName => 'المؤسسة';

  @override
  String get reportsFieldsDailySpent => 'المصروف اليومي';

  @override
  String get reportsFieldsMonthlySpent => 'المصروف الشهري';

  @override
  String get reportsFieldsDailyLimit => 'الحد اليومي';

  @override
  String get reportsFieldsMonthlyLimit => 'الحد الشهري';

  @override
  String get reportsFieldsDailyPercent => 'النسبة اليومية';

  @override
  String get reportsFieldsMonthlyPercent => 'النسبة الشهرية';

  @override
  String get reportsFieldsUpdatedAt => 'آخر تحديث';

  @override
  String get reportsFieldsActive => 'نشط';

  @override
  String get reportsFieldsNearDailyLimit => 'قريب من الحد اليومي';

  @override
  String get reportsFieldsNearMonthlyLimit => 'قريب من الحد الشهري';

  @override
  String get creditCount => 'عدد الإيداعات';

  @override
  String get debitCount => 'عدد السحوبات';

  @override
  String get activeUsers => 'المستخدمون النشطون';

  @override
  String get totalProfits => 'إجمالي الأرباح';

  @override
  String get totalCollectedProfit => 'إجمالي المتحصل';

  @override
  String get totalUncollectedProfit => 'إجمالي غير المتحصل';

  @override
  String get totalAmount => 'إجمالي المبلغ';

  @override
  String get totalUserProfit => 'إجمالي أرباح المستخدمين';

  @override
  String get walletBalance => 'رصيد المحفظة';

  @override
  String get branchWalletsBalance => 'رصيد محافظ الفرع';

  @override
  String get highestTransactionTitle => 'أعلى عملية';

  @override
  String get walletsWithCurrentProfit => 'المحافظ ذات أرباح حالية';

  @override
  String get totalActiveWallets => 'إجمالي المحافظ الشغالة';

  @override
  String get profitSummaryBusinessNote =>
      'المتحصل في الفترة المحددة + غير المتحصل الحالي';

  @override
  String get usersPerformanceSectionTitle => 'أداء المستخدمين';

  @override
  String get userProfit => 'ربح المستخدم';

  @override
  String get loadingUserPerformanceReport => 'جارٍ تحميل أداء المستخدمين...';

  @override
  String get unableToLoadUserPerformanceReport =>
      'تعذر تحميل أداء المستخدمين حاليًا.';

  @override
  String get noUserPerformanceResultsTitle => 'لا يوجد مستخدمون';

  @override
  String get noUserPerformanceResultsMessage =>
      'لم يطابق أي مستخدم فلاتر التقرير الحالية.';

  @override
  String get allTypes => 'كل الأنواع';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get endOfResults => 'نهاية النتائج';

  @override
  String get loadingTransactionDetailsReport => 'جارٍ تحميل تفاصيل العمليات...';

  @override
  String get unableToLoadTransactionDetailsReport =>
      'تعذر تحميل تفاصيل العمليات حاليًا.';

  @override
  String get noTransactionsFound => 'لا توجد عمليات';

  @override
  String get noTransactionsMatchedCurrentFilters =>
      'لم تطابق أي عملية الفلاتر الحالية.';

  @override
  String get noHighestTransactionTitle => 'لا توجد أعلى عملية';

  @override
  String get noHighestTransactionMessage =>
      'لم تطابق أي عملية الفلاتر الحالية.';

  @override
  String get totalTransactions => 'إجمالي العمليات';

  @override
  String get transactionCount => 'عدد العمليات';

  @override
  String get net => 'الصافي';

  @override
  String get netAmount => 'الصافي';

  @override
  String pageSummary(String page, String totalPages, String totalElements) {
    return 'الصفحة $page من $totalPages - $totalElements عنصر';
  }

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInSubtitle => 'استخدم حسابك للوصول للمحافظ والتقارير.';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'ادخل كلمة المرور';

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
      'بيستخدم نقطة المصادقة الحالية وبيحفظ الجلسة محليًا.';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'كلمة المرور قصيرة جدًا';

  @override
  String get loginHeroSubtitle =>
      'وصول من الموبايل لمتابعة المحافظ وتسجيل العمليات والتقارير.';

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
    return 'بواسطة: $name';
  }

  @override
  String transactionSavedRef(String referenceId) {
    return 'تم حفظ العملية بنجاح. المرجع: $referenceId';
  }

  @override
  String get branchDirectory => 'دليل الفروع';

  @override
  String get branchDirectorySubtitle =>
      'راجع الفروع والتغطية وتعيين المحافظ والمستخدمين.';

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
  String get createBranch => 'إنشاء فرع';

  @override
  String get editBranch => 'تعديل فرع';

  @override
  String get deleteBranch => 'حذف فرع';

  @override
  String get branchCreatedSuccessfully => 'تم إنشاء الفرع بنجاح';

  @override
  String get branchUpdatedSuccessfully => 'تم تحديث الفرع بنجاح';

  @override
  String get branchDeletedSuccessfully => 'تم حذف الفرع بنجاح';

  @override
  String get branchNameRequired => 'اسم الفرع مطلوب';

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
      'راجع الحسابات وتعيين الفروع وحالة النشاط.';

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
  String get createUser => 'إنشاء مستخدم';

  @override
  String get editUser => 'تعديل مستخدم';

  @override
  String get deleteUser => 'حذف مستخدم';

  @override
  String get assignBranch => 'تعيين فرع';

  @override
  String get unassignBranch => 'إلغاء تعيين الفرع';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get confirmUnassign => 'تأكيد إلغاء التعيين';

  @override
  String get userCreatedSuccessfully => 'تم إنشاء المستخدم بنجاح';

  @override
  String get userUpdatedSuccessfully => 'تم تحديث المستخدم بنجاح';

  @override
  String get userDeletedSuccessfully => 'تم حذف المستخدم بنجاح';

  @override
  String get userAssignedToBranchSuccessfully =>
      'تم تعيين المستخدم للفرع بنجاح';

  @override
  String get userUnassignedFromBranchSuccessfully =>
      'تم إلغاء تعيين المستخدم من الفرع بنجاح';

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
      'تابع حالة الباقة وحدود مساحة العمل قبل موعد التجديد القادم.';

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
  String get currencyEgp => 'جنيه';

  @override
  String get monthlyBillingPeriod => 'شهريًا';

  @override
  String planPricePerMonth(String currency, String price, String period) {
    return '$price $currency / $period';
  }

  @override
  String get enterpriseUpgradeComingSoon =>
      'مراجعة ترقية Enterprise هتتوصل لاحقًا.';

  @override
  String planSelectionComingSoon(String planName) {
    return 'اختيار $planName هيتوصل لاحقًا.';
  }

  @override
  String get unableToSignIn => 'تعذر تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get unableToSaveTransaction => 'تعذر حفظ العملية. حاول مرة أخرى.';

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get walletLoadError => 'تعذر تحميل المحافظ. حاول مرة أخرى.';

  @override
  String get walletCreateError => 'تعذر إنشاء المحفظة. حاول مرة أخرى.';

  @override
  String get walletUpdateError => 'تعذر تحديث المحفظة. حاول مرة أخرى.';

  @override
  String get walletDeleteError => 'تعذر حذف المحفظة. حاول مرة أخرى.';

  @override
  String get support => 'الدعم الفني';

  @override
  String get supportTickets => 'تذاكر الدعم الفني';

  @override
  String get supportSubtitle => 'هل تحتاج مساعدة؟ أرسل طلب دعم إلى فريقنا.';

  @override
  String get newTicket => 'تذكرة جديدة';

  @override
  String get noSupportTicketsYet => 'لا توجد تذاكر دعم حتى الآن.';

  @override
  String get invalidUsernameOrPassword =>
      'اسم المستخدم أو كلمة المرور غير صحيحة';

  @override
  String get fileTooLarge => 'حجم الملف كبير جدًا';

  @override
  String get unsupportedFileType => 'نوع الملف غير مدعوم';

  @override
  String get validationError => 'يرجى مراجعة البيانات المدخلة';

  @override
  String get forbiddenError => 'لا تملك صلاحية تنفيذ هذا الإجراء';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get branchLimitReachedForCurrentPlan =>
      'تم الوصول للحد الأقصى للفروع في الخطة الحالية';

  @override
  String get userLimitReachedForCurrentPlan =>
      'تم الوصول للحد الأقصى للمستخدمين في الخطة الحالية';

  @override
  String get walletLimitReachedForCurrentPlan =>
      'تم الوصول للحد الأقصى للمحافظ في الخطة الحالية';

  @override
  String get dataConflict => 'يوجد تعارض مع بيانات موجودة';

  @override
  String get unableToSubmitSupportRequest => 'تعذر إرسال طلب الدعم';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get subject => 'الموضوع';

  @override
  String get supportMessage => 'الرسالة';

  @override
  String get subjectRequired => 'الموضوع مطلوب';

  @override
  String get supportMessageRequired => 'الرسالة مطلوبة';

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get descriptionRequired => 'الوصف مطلوب';

  @override
  String get priority => 'الأولوية';

  @override
  String get priorityRequired => 'الأولوية مطلوبة';

  @override
  String get resolvedAt => 'تاريخ الحل';

  @override
  String get sendSupportRequest => 'إرسال طلب الدعم';

  @override
  String get supportRequestSent => 'تم إرسال طلب الدعم بنجاح.';

  @override
  String get unableToSendSupportRequest =>
      'تعذر إرسال طلب الدعم. حاول مرة أخرى.';

  @override
  String get unableToLoadSupportTickets =>
      'تعذر تحميل تذاكر الدعم. حاول مرة أخرى.';

  @override
  String get low => 'منخفضة';

  @override
  String get medium => 'متوسطة';

  @override
  String get high => 'عالية';

  @override
  String get renewalRequest => 'طلب تجديد';

  @override
  String get renewalRequests => 'طلبات التجديد';

  @override
  String get renewalRequestSubtitle =>
      'اطلب تجديد اشتراك مساحة العمل الخاصة بك.';

  @override
  String get newRequest => 'طلب جديد';

  @override
  String get noRenewalRequestsYet => 'لا توجد طلبات تجديد حتى الآن.';

  @override
  String get submitRenewalRequest => 'إرسال طلب التجديد';

  @override
  String get renewalRequestSubmitted => 'تم إرسال طلب التجديد بنجاح.';

  @override
  String get unableToSubmitRenewalRequest => 'تعذر إرسال طلب التجديد';

  @override
  String get unableToLoadRenewalRequests =>
      'تعذر تحميل طلبات التجديد. حاول مرة أخرى.';

  @override
  String get requestedAt => 'تاريخ الطلب';

  @override
  String get reviewedAt => 'تاريخ المراجعة';

  @override
  String get adminNote => 'ملاحظة الإدارة';

  @override
  String get periodMonths => 'المدة (بالشهور)';

  @override
  String get periodMonthsRequired => 'المدة مطلوبة';

  @override
  String get positivePeriodRequired => 'أدخل عدد شهور صحيح';

  @override
  String get password_optional_hint => 'سيبه فاضي لو مش عايز تغيّره';

  @override
  String get today => 'اليوم';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get thisYear => 'هذا العام';

  @override
  String get custom => 'مخصص';

  @override
  String get reportsHomeTitle => 'التقارير';

  @override
  String get reportsHomeSubtitle =>
      'اختر تقرير لمراجعة الحركة المالية والأرباح وأداء المستخدمين.';

  @override
  String get transactionsSummaryReportTitle => 'ملخص العمليات';

  @override
  String get transactionsSummaryReportDescription =>
      'ملخص الإيداعات والسحوبات وعدد العمليات وأعلى عملية حسب الفلاتر.';

  @override
  String get profitSummaryReportTitle => 'ملخص الأرباح';

  @override
  String get profitSummaryReportDescription =>
      'تابع ملخص الأرباح المحصلة وغير المحصلة والأرصدة.';

  @override
  String get userPerformanceReportTitle => 'أداء المستخدمين';

  @override
  String get userPerformanceReportDescription =>
      'حلل أداء المستخدمين وعدد العمليات وإجمالي الأرباح لكل مستخدم.';

  @override
  String get transactionDetailsReportTitle => 'تفاصيل العمليات';

  @override
  String get transactionDetailsReportDescription =>
      'راجع تفاصيل العمليات وابحث وفلتر حسب المحفظة أو الفرع أو المستخدم.';

  @override
  String get reportsPlaceholderMessage => 'شاشة التقرير دي هتتوفر لاحقًا.';
}
