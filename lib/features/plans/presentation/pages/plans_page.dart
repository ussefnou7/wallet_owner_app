import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../../core/widgets/placeholder_page_scaffold.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPageScaffold(
      title: 'Plans',
      label: 'Plan management will be added in a later phase.',
      subtitle: 'Review subscription plans and workspace entitlements.',
      icon: Icons.workspace_premium_outlined,
      endDrawer: OwnerAppDrawer(currentRoute: AppRoutes.plans),
    );
  }
}
