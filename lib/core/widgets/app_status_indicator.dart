import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppStatusIndicator extends StatelessWidget {
  const AppStatusIndicator({
    required this.label,
    required this.isActive,
    this.activeIcon = Icons.check_circle_outline_rounded,
    this.inactiveIcon = Icons.highlight_off_rounded,
    this.activeColor = AppColors.success,
    this.inactiveColor = AppColors.textSecondary,
    this.iconSize = 15,
    super.key,
  });

  final String label;
  final bool isActive;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Color activeColor;
  final Color inactiveColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isActive ? activeIcon : inactiveIcon,
          size: iconSize,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
