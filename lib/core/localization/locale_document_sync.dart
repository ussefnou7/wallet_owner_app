import 'dart:ui';

import 'locale_document_sync_stub.dart'
    if (dart.library.html) 'locale_document_sync_web.dart'
    as syncer;

void syncLocaleDocument(Locale locale, {required bool isRtl}) {
  syncer.syncLocaleDocument(locale, isRtl: isRtl);
}
