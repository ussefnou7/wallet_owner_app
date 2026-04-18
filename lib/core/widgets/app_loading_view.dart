import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({this.message = 'Loading...', super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
