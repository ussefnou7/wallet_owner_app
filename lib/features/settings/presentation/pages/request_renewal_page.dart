import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../../core/widgets/placeholder_page_scaffold.dart';

class RequestRenewalPage extends StatelessWidget {
  const RequestRenewalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPageScaffold(
      title: 'Request Renewal',
      label: 'Renewal requests will be added in a later phase.',
      subtitle: 'Prepare and send subscription renewal requests.',
      icon: Icons.autorenew_rounded,
      endDrawer: OwnerAppDrawer(currentRoute: AppRoutes.requestRenewal),
    );
  }
}
