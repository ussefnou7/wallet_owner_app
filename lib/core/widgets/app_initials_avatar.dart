import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppInitialsAvatar extends StatelessWidget {
  const AppInitialsAvatar({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts.take(2).map((part) => part[0]).join().toUpperCase();

    return CircleAvatar(
      backgroundColor: AppColors.primarySoft,
      foregroundColor: AppColors.primary,
      child: Text(initials),
    );
  }
}
