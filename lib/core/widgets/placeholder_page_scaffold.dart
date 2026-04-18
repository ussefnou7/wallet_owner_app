import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_spacing.dart';
import 'app_empty_state.dart';
import 'app_page_scaffold.dart';

class PlaceholderPageScaffold extends StatelessWidget {
  const PlaceholderPageScaffold({
    required this.title,
    required this.label,
    this.subtitle,
    this.icon = Icons.construction_outlined,
    this.endDrawer,
    this.bottomNavigationBar,
    this.currentRoute,
    super.key,
  });

  final String title;
  final String label;
  final String? subtitle;
  final IconData icon;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle ?? 'This area is part of the owner workspace shell.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: AppEmptyState(title: title, message: label, icon: icon),
            ),
          ),
        ],
      ),
    );
  }
}
