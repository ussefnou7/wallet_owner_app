import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    required this.title,
    required this.child,
    this.leading,
    this.actions,
    this.endDrawer,
    this.bottomNavigationBar,
    this.padding = AppDimensions.screenPadding,
    this.maxWidth = AppDimensions.contentMaxWidth,
    this.embedded = false,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );

    if (embedded) {
      return content;
    }

    return Scaffold(
      endDrawer: endDrawer,
      appBar: AppBar(leading: leading, title: Text(title), actions: actions),
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(child: content),
    );
  }
}
