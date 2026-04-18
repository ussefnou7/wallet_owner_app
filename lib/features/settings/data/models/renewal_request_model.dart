import '../../domain/entities/renewal_request.dart';

class RenewalRequestModel extends RenewalRequest {
  const RenewalRequestModel({
    required super.currentPlanId,
    required super.targetPlanId,
    required super.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPlanId': currentPlanId,
      'targetPlanId': targetPlanId,
      'note': note,
    };
  }
}
