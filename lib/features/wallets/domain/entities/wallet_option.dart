import 'package:equatable/equatable.dart';

class WalletOption extends Equatable {
  const WalletOption({
    required this.id,
    required this.name,
    required this.number,
    required this.branchId,
  });

  final String id;
  final String name;
  final String number;
  final String branchId;

  @override
  List<Object?> get props => [id, name, number, branchId];
}
