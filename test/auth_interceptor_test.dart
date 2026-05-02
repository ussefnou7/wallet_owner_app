import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/core/network/auth_interceptor.dart';
import 'package:ta2feela_app/core/network/network_constants.dart';

void main() {
  test('does not attach Authorization header to login endpoint', () async {
    final adapter = _FakeAdapter(
      (options) => ResponseBody.fromString(
        '{}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://example.com',
        responseType: ResponseType.json,
      ),
    );
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(readAccessToken: () async => 'stale-token'),
    );

    await dio.post(NetworkConstants.authLoginPath, data: const {});

    expect(
      adapter.lastRequestOptions?.headers.containsKey(
        NetworkConstants.authorizationHeader,
      ),
      isFalse,
    );
  });

  test('attaches Authorization header to protected endpoints', () async {
    final adapter = _FakeAdapter(
      (options) => ResponseBody.fromString(
        '{}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://example.com',
        responseType: ResponseType.json,
      ),
    );
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(readAccessToken: () async => 'valid-token'),
    );

    await dio.get(NetworkConstants.walletsPath);

    expect(
      adapter.lastRequestOptions?.headers[NetworkConstants.authorizationHeader],
      '${NetworkConstants.bearerPrefix} valid-token',
    );
  });
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final ResponseBody Function(RequestOptions options) _handler;
  RequestOptions? lastRequestOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestOptions = options;
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}
