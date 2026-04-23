import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_form_section.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../domain/entities/report_option.dart';
import '../providers/reports_provider.dart';
import '../widgets/report_option_card.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financialReports = ref.watch(financialReportsProvider);
    final operationalReports = ref.watch(operationalReportsProvider);
    final exportReports = ref.watch(exportReportsProvider);
    final l10n = appL10n(context);

    return AppPageScaffold(
      title: l10n.reports,
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
      ],
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.reports),
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: AppRoutes.reports,
        onDestinationSelected: context.go,
      ),
      maxWidth: AppDimensions.contentMaxWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: l10n.reportingWorkspace,
              subtitle: l10n.reportingWorkspaceSubtitle,
            ),
            const SizedBox(height: AppSpacing.md),
            _ReportSection(
              title: l10n.financialReports,
              subtitle: l10n.financialReportsSubtitle,
              options: financialReports,
            ),
            const SizedBox(height: AppSpacing.md),
            _ReportSection(
              title: l10n.operationalReports,
              subtitle: l10n.operationalReportsSubtitle,
              options: operationalReports,
            ),
            const SizedBox(height: AppSpacing.md),
            _ReportSection(
              title: l10n.exportFormats,
              subtitle: l10n.exportFormatsSubtitle,
              options: exportReports,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  const _ReportSection({
    required this.title,
    required this.subtitle,
    required this.options,
  });

  final String title;
  final String subtitle;
  final List<ReportOption> options;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return AppFormSection(
      title: title,
      subtitle: subtitle,
      child: Column(
        children: [
          for (var index = 0; index < options.length; index++) ...[
            ReportOptionCard(
              option: options[index],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.reportAvailableLater(options[index].title),
                    ),
                  ),
                );
              },
            ),
            if (index != options.length - 1)
              const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
