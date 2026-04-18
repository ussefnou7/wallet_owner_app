import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../../core/widgets/placeholder_page_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPageScaffold(
      title: 'Settings',
      label: 'Settings will be added in a later phase.',
      subtitle: 'Configure workspace preferences and owner-level settings.',
      icon: Icons.settings_outlined,
      endDrawer: OwnerAppDrawer(currentRoute: AppRoutes.settings),
    );
  }
}
