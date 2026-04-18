import 'package:equatable/equatable.dart';

class ReportOption extends Equatable {
  const ReportOption({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final String icon;

  @override
  List<Object?> get props => [title, description, icon];
}
