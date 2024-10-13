import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../beautyfilters.dart';

Future<MediaStream?> startVirtualBackground({
  required Uint8List backgroundImage,
  String? textureId,
}) async {
  // await Helper.enableVirtualBackground(
  //   backgroundImage: backgroundImage,
  // );
  return null;
}

Future<void> stopVirtualBackground({bool reset = false}) async {
  // await Helper.disableVirtualBackground();
}


// MARK: private
void _adjustValue(BeautyFilters newValue) {
  // if (_filters.smoothValue != newValue.smoothValue) {
  //   Helper.setSmoothValue(newValue.smoothValue);
  // }
  // if (_filters.whiteValue != newValue.whiteValue) {
  //   Helper.setWhiteValue(newValue.whiteValue);
  // }
  // if (_filters.bigEyeValue != newValue.bigEyeValue) {
  //   Helper.setBigEyeValue(newValue.bigEyeValue);
  // }
  // if (_filters.thinFaceValue != newValue.thinFaceValue) {
  //   Helper.setThinFaceValue(newValue.thinFaceValue);
  // }
  // if (_filters.lipstickValue != newValue.lipstickValue) {
  //   Helper.setLipstickValue(newValue.lipstickValue);
  // }
  // if (_filters.blusherValue != newValue.blusherValue) {
  //   Helper.setBlusherValue(newValue.blusherValue);
  // }

  // _filters = newValue.copyWith();
}