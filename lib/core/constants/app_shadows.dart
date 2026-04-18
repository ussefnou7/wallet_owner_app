import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0A17202A), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1217202A), blurRadius: 20, offset: Offset(0, 10)),
  ];

  static final List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}
