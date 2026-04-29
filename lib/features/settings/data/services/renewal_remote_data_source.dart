import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../models/renewal_request_item_model.dart';
import '../models/renewal_request_payload_model.dart';

abstract interface class RenewalRemoteDataSource {
  Future<ApiResult<List<RenewalRequestItemModel>>> getMyRenewalRequests();

  Future<void> createRenewalRequest(RenewalRequestPayloadModel request);
}

class DioRenewalRemoteDataSource implements RenewalRemoteDataSource {
  const DioRenewalRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<List<RenewalRequestItemModel>>>
  getMyRenewalRequests() async {
    try {
      final response = await _apiClient.get<Object?>(
        '${NetworkConstants.renewalRequestsPath}/my',
      );
      final items = ApiResponseExtractor.extractList(
        response.data,
      ).map(RenewalRequestItemModel.fromJson).toList();
      return ApiSuccess(items);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<void> createRenewalRequest(RenewalRequestPayloadModel request) async {
    try {
      await _apiClient.post(
        NetworkConstants.renewalRequestsPath,
        data: request.toJson(),
      );
    } catch (e) {
      throw _exceptionMapper.map(e);
    }
  }
}
