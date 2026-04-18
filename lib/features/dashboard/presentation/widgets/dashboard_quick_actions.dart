import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_section_header.dart';
import 'dashboard_action_card.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({
    required this.onCreateTransaction,
    required this.onViewReports,
    super.key,
  });

  final VoidCallback onCreateTransaction;
  final VoidCallback onViewReports;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Quick Actions',
          subtitle: 'Common owner actions for daily operations.',
        ),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: [
            DashboardActionCard(
              title: 'Create Transaction',
              subtitle: 'Record a new transaction after it happens.',
              icon: Icons.add_circle_outline,
              onTap: onCreateTransaction,
            ),
            const SizedBox(height: AppSpacing.md),
            DashboardActionCard(
              title: 'View Reports',
              subtitle: 'Review wallet activity and performance.',
              icon: Icons.bar_chart_outlined,
              onTap: onViewReports,
            ),
          ],
        ),
      ],
    );
  }
}
