import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

class OwnerTopBar extends StatelessWidget {
  const OwnerTopBar({
    required this.title,
    required this.leading,
    required this.trailing,
    super.key,
  });

  final String title;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final startWidget = isRtl ? trailing : leading;
    final endWidget = isRtl ? leading : trailing;

    return Row(
      children: [
        startWidget,
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        endWidget,
      ],
    );
  }
}
