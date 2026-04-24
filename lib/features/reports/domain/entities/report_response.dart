import 'package:equatable/equatable.dart';

import 'report_column.dart';

class ReportResponse extends Equatable {
  const ReportResponse({
    required this.titleKey,
    required this.columns,
    required this.data,
  });

  final String? titleKey;
  final List<ReportColumn> columns;
  final Object? data;

  bool get isEmpty {
    final normalized = data;
    if (normalized == null) {
      return true;
    }
    if (normalized is List) {
      return normalized.isEmpty;
    }
    if (normalized is Map<String, dynamic>) {
      if (normalized.isEmpty) {
        return true;
      }
      final content = normalized['content'];
      if (content is List) {
        return content.isEmpty;
      }
    }
    return false;
  }

  @override
  List<Object?> get props => [titleKey, columns, data];
}
