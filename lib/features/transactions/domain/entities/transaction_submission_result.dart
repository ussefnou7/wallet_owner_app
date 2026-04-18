import 'package:equatable/equatable.dart';

class TransactionSubmissionResult extends Equatable {
  const TransactionSubmissionResult({
    required this.referenceId,
    required this.createdAt,
  });

  final String referenceId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [referenceId, createdAt];
}
