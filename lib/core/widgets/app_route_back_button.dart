import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouteBackButton extends StatelessWidget {
  const AppRouteBackButton({required this.fallbackRoute, super.key});

  final String fallbackRoute;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: IconButton(
        icon: const BackButtonIcon(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
            return;
          }

          context.go(fallbackRoute);
        },
      ),
    );
  }
}
