import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/report_navigation_card.dart';

class ReportsHomePage extends StatelessWidget {
  const ReportsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final bottomContentPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight;
    final reports = _buildReports(l10n);

    return AppPageScaffold(
      title: l10n.reports,
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: ListView.separated(
        padding: EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: bottomContentPadding,
        ),
        itemCount: reports.length + 1,
        separatorBuilder: (context, index) =>
            SizedBox(height: index == 0 ? AppSpacing.md : AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _ReportsHomeHeader(
              title: l10n.reportsHomeTitle,
              subtitle: l10n.reportsHomeSubtitle,
            );
          }

          final report = reports[index - 1];
          return ReportNavigationCard(
            icon: report.icon,
            title: report.title,
            description: report.description,
            onTap: () => context.push(report.route),
          );
        },
      ),
    );
  }

  List<_ReportHomeItem> _buildReports(AppLocalizations l10n) {
    return [
      _ReportHomeItem(
        icon: Icons.summarize_outlined,
        title: l10n.transactionsSummaryReportTitle,
        description: l10n.transactionsSummaryReportDescription,
        route: AppRoutes.transactionsSummaryReport,
      ),
      _ReportHomeItem(
        icon: Icons.account_balance_wallet_outlined,
        title: l10n.profitSummaryReportTitle,
        description: l10n.profitSummaryReportDescription,
        route: AppRoutes.profitSummaryReport,
      ),
      _ReportHomeItem(
        icon: Icons.insights_outlined,
        title: l10n.userPerformanceReportTitle,
        description: l10n.userPerformanceReportDescription,
        route: AppRoutes.userPerformanceReport,
      ),
      _ReportHomeItem(
        icon: Icons.receipt_long_outlined,
        title: l10n.transactionDetailsReportTitle,
        description: l10n.transactionDetailsReportDescription,
        route: AppRoutes.transactionDetailsReport,
      ),
    ];
  }
}

class _ReportsHomeHeader extends StatelessWidget {
  const _ReportsHomeHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportHomeItem {
  const _ReportHomeItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String description;
  final String route;
}
