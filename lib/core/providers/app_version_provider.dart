import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appVersionProvider = FutureProvider<String>((ref) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version.trim();
    if (version.isNotEmpty) {
      return version;
    }
  } catch (_) {
    // Keep a stable fallback for tests or environments without plugin support.
  }

  return '1.0.0';
});
