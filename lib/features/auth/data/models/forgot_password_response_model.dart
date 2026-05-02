class ForgotPasswordResponseModel {
  const ForgotPasswordResponseModel({this.responseMessage});

  final String? responseMessage;

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrapPayload(json);

    return ForgotPasswordResponseModel(
      responseMessage: _readString(payload, const ['responseMsg', 'message']),
    );
  }

  static Map<String, dynamic> _unwrapPayload(Map<String, dynamic> json) {
    final nested = json['data'];
    if (nested is Map<String, dynamic>) {
      return nested;
    }

    return json;
  }

  static String? _readString(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return null;
  }
}
