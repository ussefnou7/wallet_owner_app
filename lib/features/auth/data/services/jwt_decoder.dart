import 'dart:convert';

abstract final class JwtDecoder {
  static const Duration defaultClockSkew = Duration(seconds: 30);

  static Map<String, dynamic>? tryDecodePayload(String token) {
    final segments = token.split('.');
    if (segments.length < 2) {
      return null;
    }

    try {
      final normalized = base64.normalize(segments[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(decoded);
      if (payload is Map) {
        return Map<String, dynamic>.from(payload);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  static DateTime? tryReadExpiration(String token) {
    final claims = tryDecodePayload(token);
    if (claims == null) {
      return null;
    }

    return readExpirationFromClaims(claims);
  }

  static DateTime? readExpirationFromClaims(Map<String, dynamic> claims) {
    final rawExp = claims['exp'];
    final int? exp;
    if (rawExp is int) {
      exp = rawExp;
    } else if (rawExp is num) {
      exp = rawExp.toInt();
    } else if (rawExp is String) {
      exp = int.tryParse(rawExp.trim());
    } else {
      exp = null;
    }

    if (exp == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
  }

  static bool isExpiredOrInvalid(
    String token, {
    Duration clockSkew = defaultClockSkew,
    DateTime? now,
  }) {
    final expiresAt = tryReadExpiration(token);
    if (expiresAt == null) {
      return true;
    }

    final effectiveNow = (now ?? DateTime.now()).toUtc().add(clockSkew);
    return !expiresAt.isAfter(effectiveNow);
  }
}
