class PagedResponse<T> {
  const PagedResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.hasNext,
  });

  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool hasNext;

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromItemJson,
  ) {
    final rawContent = json['content'];
    final content = rawContent is List
        ? rawContent
              .whereType<Map>()
              .map((item) => fromItemJson(Map<String, dynamic>.from(item)))
              .toList(growable: false)
        : <T>[];

    return PagedResponse<T>(
      content: content,
      page: _asInt(json['page']),
      size: _asInt(json['size']),
      totalElements: _asInt(json['totalElements']),
      totalPages: _asInt(json['totalPages']),
      last: _asBool(json['last']),
      hasNext: _asBool(json['hasNext']),
    );
  }

  static int _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static bool _asBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return false;
  }
}
