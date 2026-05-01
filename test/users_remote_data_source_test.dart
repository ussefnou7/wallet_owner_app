import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_owner_app/core/network/api_client.dart';
import 'package:wallet_owner_app/core/network/api_exception_mapper.dart';
import 'package:wallet_owner_app/features/users/data/models/app_user_model.dart';
import 'package:wallet_owner_app/features/users/data/services/users_remote_data_source.dart';

void main() {
  test(
    'assign user to branch uses assign-branch endpoint with user id',
    () async {
      final apiClient = _FakeApiClient(
        putResponseData: {
          'id': 'user-7',
          'username': 'Mariam Hassan',
          'role': 'USER',
          'tenantName': 'BTC',
          'branchId': 'branch-9',
          'branchName': 'Assigned Branch',
          'active': true,
        },
      );
      final dataSource = DioUsersRemoteDataSource(
        apiClient: apiClient,
        exceptionMapper: const ApiExceptionMapper(),
      );

      await dataSource.assignUserToBranch(
        userId: 'user-7',
        request: const AssignUserBranchRequestModel(branchId: 'branch-9'),
      );

      expect(apiClient.lastPutPath, '/api/v1/users/user-7/assign-branch');
      expect(apiClient.lastPutData, {'branchId': 'branch-9'});
    },
  );

  test(
    'unassign user from branch uses branch delete endpoint with user id',
    () async {
      final apiClient = _FakeApiClient(deleteResponseData: null);
      final dataSource = DioUsersRemoteDataSource(
        apiClient: apiClient,
        exceptionMapper: const ApiExceptionMapper(),
      );

      await dataSource.unassignUserFromBranch('user-7');

      expect(apiClient.lastDeletePath, '/api/v1/users/user-7/branch');
    },
  );
}

class _FakeApiClient implements ApiClient {
  _FakeApiClient({this.putResponseData, this.deleteResponseData});

  final Object? putResponseData;
  final Object? deleteResponseData;
  String? lastPutPath;
  Object? lastPutData;
  String? lastDeletePath;

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastDeletePath = path;
    return Response<T>(
      data: deleteResponseData as T,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastPutPath = path;
    lastPutData = data;
    return Response<T>(
      data: putResponseData as T,
      requestOptions: RequestOptions(path: path),
    );
  }
}
