import 'package:equatable/equatable.dart';

sealed class AppFailure extends Equatable {
  const AppFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, {super.statusCode});
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure(super.message, {super.statusCode});
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure(super.message, {super.statusCode});
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, {super.statusCode});
}

class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {super.statusCode});
}

class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message, {super.statusCode});
}

class AppFailureException implements Exception {
  const AppFailureException(this.failure);

  final AppFailure failure;

  @override
  String toString() => failure.message;
}
