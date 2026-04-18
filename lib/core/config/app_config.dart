import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env.dart';

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnv());

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    required this.requestTimeout,
    required this.enableNetworkLogs,
    required this.useMockAuth,
  });

  factory AppConfig.fromEnv() {
    return const AppConfig(
      appName: Env.appName,
      apiBaseUrl: Env.apiBaseUrl,
      requestTimeout: Duration(seconds: Env.apiTimeoutSeconds),
      enableNetworkLogs: kDebugMode && Env.enableNetworkLogs,
      useMockAuth: Env.useMockAuth,
    );
  }

  final String appName;
  final String apiBaseUrl;
  final Duration requestTimeout;
  final bool enableNetworkLogs;
  final bool useMockAuth;
}
