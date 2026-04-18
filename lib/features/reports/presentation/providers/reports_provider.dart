import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/report_option.dart';

final financialReportsProvider = Provider<List<ReportOption>>((ref) {
  return const [
    ReportOption(
      title: 'Wallet Summary',
      description: 'Review balances and recent activity by wallet.',
      icon: 'account_balance_wallet',
    ),
    ReportOption(
      title: 'Credit vs Debit Summary',
      description: 'Compare inflows and outflows across the workspace.',
      icon: 'compare_arrows',
    ),
    ReportOption(
      title: 'Profit Summary',
      description: 'Track recorded profit totals and trends.',
      icon: 'trending_up',
    ),
  ];
});

final operationalReportsProvider = Provider<List<ReportOption>>((ref) {
  return const [
    ReportOption(
      title: 'Transactions Report',
      description: 'Review transaction history, volume, and activity.',
      icon: 'receipt_long',
    ),
    ReportOption(
      title: 'Branch Activity',
      description: 'Understand activity across branch operations.',
      icon: 'storefront',
    ),
    ReportOption(
      title: 'User Activity',
      description: 'Monitor who is recording and updating transactions.',
      icon: 'people',
    ),
  ];
});

final exportReportsProvider = Provider<List<ReportOption>>((ref) {
  return const [
    ReportOption(
      title: 'PDF Export',
      description: 'Prepare report outputs for printable sharing.',
      icon: 'picture_as_pdf',
    ),
    ReportOption(
      title: 'Excel Export',
      description: 'Prepare tabular report exports for spreadsheet use.',
      icon: 'table_view',
    ),
  ];
});
