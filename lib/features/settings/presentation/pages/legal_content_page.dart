import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_route_back_button.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../widgets/settings_section_card.dart';

class LegalContentPage extends StatelessWidget {
  const LegalContentPage({
    required this.title,
    required this.subtitle,
    required this.sections,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<LegalContentSection> sections;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppRouteBackButton(fallbackRoute: AppRoutes.settings),
            const SizedBox(height: AppSpacing.sm),
            AppSectionHeader(title: title, subtitle: subtitle),
            const SizedBox(height: AppSpacing.md),
            for (var index = 0; index < sections.length; index++) ...[
              SettingsSectionCard(
                title: sections[index].title,
                child: Text(
                  sections[index].body,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              if (index != sections.length - 1)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class LegalContentSection {
  const LegalContentSection({required this.title, required this.body});

  final String title;
  final String body;
}
