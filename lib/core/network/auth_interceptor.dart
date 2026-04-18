import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/services/session_local_data_source.dart';
import 'network_constants.dart';

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  final sessionLocalDataSource = ref.watch(sessionLocalDataSourceProvider);
  return AuthInterceptor(
    readAccessToken: sessionLocalDataSource.readAccessToken,
  );
});

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required Future<String?> Function() readAccessToken})
    : _readAccessToken = readAccessToken;

  final Future<String?> Function() _readAccessToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers[NetworkConstants.acceptHeader] = Headers.jsonContentType;
    options.headers[Headers.contentTypeHeader] = Headers.jsonContentType;

    final accessToken = await _readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[NetworkConstants.authorizationHeader] =
          '${NetworkConstants.bearerPrefix} $accessToken';
    }

    handler.next(options);
  }
}
