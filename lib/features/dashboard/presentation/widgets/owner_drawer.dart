import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/owner_app_drawer.dart';

class OwnerDrawer extends StatelessWidget {
  const OwnerDrawer({this.currentRoute = AppRoutes.dashboard, super.key});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return OwnerAppDrawer(currentRoute: currentRoute);
  }
}
