import 'package:equatable/equatable.dart';

class RenewalRequestPayload extends Equatable {
  const RenewalRequestPayload({
    required this.phoneNumber,
    required this.amount,
    required this.periodMonths,
  });

  final String phoneNumber;
  final double amount;
  final int periodMonths;

  @override
  List<Object?> get props => [phoneNumber, amount, periodMonths];
}
