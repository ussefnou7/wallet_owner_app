import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../models/support_ticket_item_model.dart';
import '../models/support_ticket_model.dart';

abstract interface class SupportRemoteDataSource {
  Future<ApiResult<List<SupportTicketItemModel>>> getMyTickets();

  Future<void> createTicket(SupportTicketModel ticket);
}

class DioSupportRemoteDataSource implements SupportRemoteDataSource {
  const DioSupportRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<List<SupportTicketItemModel>>> getMyTickets() async {
    try {
      final response = await _apiClient.get<Object?>(
        '${NetworkConstants.supportTicketsPath}/my',
      );
      final items = ApiResponseExtractor.extractList(response.data)
          .map(SupportTicketItemModel.fromJson)
          .toList();
      return ApiSuccess(items);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<void> createTicket(SupportTicketModel ticket) async {
    try {
      await _apiClient.post(
        NetworkConstants.supportTicketsPath,
        data: ticket.toJson(),
      );
    } catch (e) {
      throw _exceptionMapper.map(e);
    }
  }
}
