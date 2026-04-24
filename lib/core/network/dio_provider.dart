import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'safe_log_interceptor.dart';
import 'session_error_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final authInterceptor = ref.watch(authInterceptorProvider);
  final sessionErrorInterceptor = ref.watch(sessionErrorInterceptorProvider);

  return createDio(
    config: config,
    authInterceptor: authInterceptor,
    sessionErrorInterceptor: sessionErrorInterceptor,
  );
});

Dio createDio({
  required AppConfig config,
  required AuthInterceptor authInterceptor,
  required SessionErrorInterceptor? sessionErrorInterceptor,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.requestTimeout,
      receiveTimeout: config.requestTimeout,
      sendTimeout: config.requestTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: const {
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    ),
  );

  dio.interceptors.add(authInterceptor);
  if (sessionErrorInterceptor != null) {
    dio.interceptors.add(sessionErrorInterceptor);
  }

  if (config.enableNetworkLogs) {
    dio.interceptors.add(
      SafeLogInterceptor(
        logRequestBody: true,
        logResponseBody: true,
      ),
    );
  }

  return dio;
}
