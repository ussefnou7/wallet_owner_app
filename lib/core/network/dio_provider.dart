import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final authInterceptor = ref.watch(authInterceptorProvider);

  return createDio(config: config, authInterceptor: authInterceptor);
});

Dio createDio({
  required AppConfig config,
  required AuthInterceptor authInterceptor,
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

  if (config.enableNetworkLogs) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  return dio;
}
