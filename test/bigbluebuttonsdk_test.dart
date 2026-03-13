import 'dart:typed_data';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/bigbluebuttonsdk_method_channel.dart';
import 'package:bigbluebuttonsdk/bigbluebuttonsdk_platform_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBigbluebuttonsdkPlatform extends BigbluebuttonsdkPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BigbluebuttonsdkPlatform initialPlatform =
      BigbluebuttonsdkPlatform.instance;

  test('$MethodChannelBigbluebuttonsdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBigbluebuttonsdk>());
  });

  test('getPlatformVersion', () async {
    Bigbluebuttonsdk bigbluebuttonsdkPlugin = Bigbluebuttonsdk();
    MockBigbluebuttonsdkPlatform fakePlatform = MockBigbluebuttonsdkPlatform();
    BigbluebuttonsdkPlatform.instance = fakePlatform;

    expect(await bigbluebuttonsdkPlugin.getPlatformVersion(), '42');
  });
}
