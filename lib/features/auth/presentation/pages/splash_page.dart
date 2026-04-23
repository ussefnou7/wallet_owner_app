import 'package:flutter/material.dart';

import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_loading_view.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return Scaffold(
      body: SafeArea(child: AppLoadingView(message: l10n.loadingWorkspace)),
    );
  }
}
