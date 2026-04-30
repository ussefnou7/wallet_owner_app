import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../models/notification_count_model.dart';
import '../models/notification_unread_grouped_model.dart';

final notificationsRemoteDataSourceProvider =
    Provider<NotificationsRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      final exceptionMapper = ref.watch(apiExceptionMapperProvider);
      return DioNotificationsRemoteDataSource(
        apiClient: apiClient,
        exceptionMapper: exceptionMapper,
      );
    });

abstract interface class NotificationsRemoteDataSource {
  Future<ApiResult<NotificationUnreadGroupedModel>> getUnreadNotifications({
    int limit = 20,
  });

  Future<ApiResult<NotificationCountModel>> getUnreadCount();

  Future<ApiResult<void>> markOneAsRead(String notificationId);

  Future<ApiResult<void>> markLowAsRead();

  Future<ApiResult<void>> markAllAsRead();
}

class DioNotificationsRemoteDataSource
    implements NotificationsRemoteDataSource {
  DioNotificationsRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<NotificationUnreadGroupedModel>> getUnreadNotifications({
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.notificationsUnreadPath,
        queryParameters: {'limit': limit},
      );
      return ApiSuccess(
        NotificationUnreadGroupedModel.fromJson(
          ApiResponseExtractor.extractObject(response.data),
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<NotificationCountModel>> getUnreadCount() async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.notificationsUnreadCountPath,
      );
      return ApiSuccess(
        NotificationCountModel.fromJson(
          ApiResponseExtractor.extractObject(response.data),
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<void>> markOneAsRead(String notificationId) async {
    return _runPatch(NetworkConstants.notificationReadPath(notificationId));
  }

  @override
  Future<ApiResult<void>> markLowAsRead() async {
    return _runPatch(NetworkConstants.notificationsReadLowPath);
  }

  @override
  Future<ApiResult<void>> markAllAsRead() async {
    return _runPatch(NetworkConstants.notificationsReadAllPath);
  }

  Future<ApiResult<void>> _runPatch(String path) async {
    try {
      final response = await _apiClient.patch<Object?>(path);
      ApiResponseExtractor.validateStatus(response.statusCode);
      return const ApiSuccess(null);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }
}
