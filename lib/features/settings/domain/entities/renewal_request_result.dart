import 'package:equatable/equatable.dart';

class RenewalRequestResult extends Equatable {
  const RenewalRequestResult({
    required this.requestId,
    required this.targetPlanName,
  });

  final String requestId;
  final String targetPlanName;

  @override
  List<Object?> get props => [requestId, targetPlanName];
}
