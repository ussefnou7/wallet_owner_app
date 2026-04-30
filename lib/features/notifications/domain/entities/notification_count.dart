import 'package:equatable/equatable.dart';

class NotificationCount extends Equatable {
  const NotificationCount({required this.count});

  final int count;

  @override
  List<Object?> get props => [count];
}
