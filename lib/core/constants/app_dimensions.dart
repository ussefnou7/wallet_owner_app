import 'package:flutter/widgets.dart';

import 'app_spacing.dart';

abstract final class AppDimensions {
  static const double contentMaxWidth = 640;
  static const double compactContentMaxWidth = 420;
  static const double buttonHeight = 52;
  static const double navigationBarHeight = 72;
  static const double floatingBottomNavHeight = 76;
  static const double floatingBottomNavOffset = 10;
  static const double floatingBottomNavExtraSpacing = AppSpacing.md;
  static const double ownerBottomNavReservedHeight =
      floatingBottomNavHeight +
      floatingBottomNavOffset +
      floatingBottomNavExtraSpacing;
  static const double floatingBottomNavReservedHeight =
      ownerBottomNavReservedHeight;
  static const double floatingBottomNavContentPadding =
      floatingBottomNavReservedHeight;
  static const double iconSm = 18;
  static const double iconMd = 22;
  static const double iconLg = 28;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );
  static const EdgeInsets sectionPadding = EdgeInsets.all(AppSpacing.md);
}
