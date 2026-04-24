import 'package:equatable/equatable.dart';

class ReportColumn extends Equatable {
  const ReportColumn({required this.key, this.labelKey});

  final String key;
  final String? labelKey;

  factory ReportColumn.fromJson(Map<String, dynamic> json) {
    final key =
        json['key'] as String? ??
        json['field'] as String? ??
        json['name'] as String? ??
        json['id'] as String? ??
        '';

    return ReportColumn(
      key: key,
      labelKey: json['labelKey'] as String? ?? json['titleKey'] as String?,
    );
  }

  @override
  List<Object?> get props => [key, labelKey];
}
