import 'package:equatable/equatable.dart';

enum SupportPriority { low, medium, high }

class SupportTicket extends Equatable {
  const SupportTicket({
    required this.subject,
    required this.description,
    required this.priority,
  });

  final String subject;
  final String description;
  final SupportPriority priority;

  @override
  List<Object?> get props => [subject, description, priority];
}
