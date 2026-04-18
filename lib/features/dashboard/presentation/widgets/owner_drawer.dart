import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';

class OwnerDrawer extends StatelessWidget {
  const OwnerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: const [
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Owner Menu'),
              ),
            ),
            _DrawerItem(title: 'Users', route: AppRoutes.users),
            _DrawerItem(title: 'Branches', route: AppRoutes.branches),
            _DrawerItem(title: 'Plans', route: AppRoutes.plans),
            _DrawerItem(
              title: 'Request Renewal',
              route: AppRoutes.requestRenewal,
            ),
            _DrawerItem(title: 'Settings', route: AppRoutes.settings),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.title, required this.route});

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }
}
