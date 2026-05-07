// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui';

void syncLocaleDocument(Locale locale, {required bool isRtl}) {
  final root = html.document.documentElement;
  if (root == null) {
    return;
  }

  root.lang = locale.toLanguageTag();
  root.dir = isRtl ? 'rtl' : 'ltr';
}
