import '../../domain/entities/renewal_request_payload.dart';

class RenewalRequestPayloadModel extends RenewalRequestPayload {
  const RenewalRequestPayloadModel({
    required super.phoneNumber,
    required super.amount,
    required super.periodMonths,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'amount': amount,
      'periodMonths': periodMonths,
    };
  }
}
