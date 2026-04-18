import 'package:equatable/equatable.dart';

class RenewalRequest extends Equatable {
  const RenewalRequest({
    required this.currentPlanId,
    required this.targetPlanId,
    required this.note,
  });

  final String currentPlanId;
  final String targetPlanId;
  final String note;

  @override
  List<Object?> get props => [currentPlanId, targetPlanId, note];
}
