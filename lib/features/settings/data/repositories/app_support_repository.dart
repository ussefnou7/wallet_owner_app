import '../../../../core/network/api_result.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/support_ticket_item.dart';
import '../../domain/repositories/support_repository.dart';
import '../models/support_ticket_model.dart';
import '../services/support_remote_data_source.dart';

class AppSupportRepository implements SupportRepository {
  const AppSupportRepository({required SupportRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final SupportRemoteDataSource _remoteDataSource;

  @override
  Future<List<SupportTicketItem>> getMyTickets() {
    return _remoteDataSource.getMyTickets().then(_unwrap);
  }

  @override
  Future<void> createTicket(SupportTicket ticket) {
    return _remoteDataSource.createTicket(
      SupportTicketModel(
        subject: ticket.subject,
        description: ticket.description,
        priority: ticket.priority,
      ),
    );
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
