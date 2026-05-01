import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_result.dart';
import '../../domain/entities/session.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

final authMockDataSourceProvider = Provider<AuthMockDataSource>(
  (ref) => const AuthMockDataSource(),
);

class AuthMockDataSource {
  static const _mockOwnerToken =
      'header.'
      'eyJzdWIiOiJtb2NrLW93bmVyIiwicm9sZSI6Ik9XTkVSIiwidGVuYW50SWQiOiJ0ZW5hbnQtZGVtbyIsInVzZXJJZCI6Im1vY2stb3duZXIiLCJleHAiOjI1MjQ2MDgwMDB9.'
      'signature';

  const AuthMockDataSource();

  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return ApiSuccess(
      LoginResponseModel(
        accessToken: _mockOwnerToken,
        refreshToken: 'mock-refresh-token',
        username: request.username,
        role: UserRole.owner,
        backendRole: 'OWNER',
        tenantId: 'tenant-demo',
        tenantName: 'BTC Workspace',
        userId: request.username,
        displayName: 'Owner User',
      ),
    );
  }
}
