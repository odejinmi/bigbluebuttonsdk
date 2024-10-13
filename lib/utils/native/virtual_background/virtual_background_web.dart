@JS()
library t;

import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dart_webrtc/dart_webrtc.dart' as rtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web/web.dart' as web;

@JS()
external JSObject? enableVirtualBackground(
  String? base64Image,
  String? textureId,
);

@JS()
external void disableVirtualBackground();

Future<MediaStream?> startVirtualBackground({
  required Uint8List backgroundImage,
  String? textureId,
}) async {
  try {
    final String base64String = base64Encode(backgroundImage);
    final JSObject? obj = enableVirtualBackground(base64String, textureId);

    if (obj == null) return null;

    final web.MediaStream jsStream = web.MediaStream(obj);
    return rtc.MediaStreamWeb(jsStream, 'local');
  } catch (error) {
    return null;
  }
}

Future<void> stopVirtualBackground({bool reset = false}) async {
  if (reset) {
    disableVirtualBackground();
  } else {
    enableVirtualBackground(null, null);
  }
}
