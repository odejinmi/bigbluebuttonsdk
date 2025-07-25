import 'dart:typed_data';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/bigbluebuttonsdk_method_channel.dart';
import 'package:bigbluebuttonsdk/bigbluebuttonsdk_platform_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBigbluebuttonsdkPlatform
    with MockPlatformInterfaceMixin
    implements BigbluebuttonsdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Startroom() {
    // TODO: implement Startroom
    throw UnimplementedError();
  }

  @override
  initialize(
      {required String baseurl,
      required String webrtctoken,
      required Meetingdetails meetingdetails}) {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  sendmessage({required String message, required String chatid}) {
    // TODO: implement sendmessage
    throw UnimplementedError();
  }

  @override
  typing({required String chatid}) {
    // TODO: implement typing
    throw UnimplementedError();
  }

  @override
  var ispolling;

  @override
  assignpresenter({required String userid}) {
    // TODO: implement assignpresenter
    throw UnimplementedError();
  }

  @override
  changerole({required String userid, required String role}) {
    // TODO: implement changerole
    throw UnimplementedError();
  }

  @override
  createGroupChat({required Participant participant}) {
    // TODO: implement createGroupChat
    throw UnimplementedError();
  }

  @override
  endecinema() {
    // TODO: implement endecinema
    throw UnimplementedError();
  }

  @override
  List<ChatMessage> getchatMessages({required String chatid}) {
    // TODO: implement getchatMessages
    throw UnimplementedError();
  }

  @override
  // TODO: implement isWebsocketRunning
  get isWebsocketRunning => throw UnimplementedError();

  @override
  // TODO: implement isrecording
  get isrecording => throw UnimplementedError();

  @override
  // TODO: implement isscreensharing
  get isscreensharing => throw UnimplementedError();

  @override
  // TODO: implement isvideo
  get isvideo => throw UnimplementedError();

  @override
  leaveroom() {
    // TODO: implement leaveroom
    throw UnimplementedError();
  }

  @override
  muteallusers({required String userid}) {
    // TODO: implement muteallusers
    throw UnimplementedError();
  }

  @override
  mutemyself() {
    // TODO: implement mutemyself
    throw UnimplementedError();
  }

  @override
  // TODO: implement mydetails
  get mydetails => throw UnimplementedError();

  @override
  // TODO: implement participant
  get participant => throw UnimplementedError();

  @override
  // TODO: implement pollanalyseparser
  get pollanalyseparser => throw UnimplementedError();

  @override
  // TODO: implement polljson
  get polljson => throw UnimplementedError();

  @override
  removeuser({required String userid, required bool notallowagain}) {
    // TODO: implement removeuser
    throw UnimplementedError();
  }

  @override
  sendecinema({required String videourl}) {
    // TODO: implement sendecinema
    throw UnimplementedError();
  }

  @override
  setemojistatus() {
    // TODO: implement setemojistatus
    throw UnimplementedError();
  }

  @override
  startcamera() {
    // TODO: implement startcamera
    throw UnimplementedError();
  }

  @override
  startpoll({required String question, required List options}) {
    // TODO: implement startpoll
    throw UnimplementedError();
  }

  @override
  startscreenshare(bool audio) {
    // TODO: implement startscreenshare
    throw UnimplementedError();
  }

  @override
  stopcamera() {
    // TODO: implement stopcamera
    throw UnimplementedError();
  }

  @override
  stopscreenshare() {
    // TODO: implement stopscreenshare
    throw UnimplementedError();
  }

  @override
  // TODO: implement talking
  get talking => throw UnimplementedError();

  @override
  toggleRecording() {
    // TODO: implement toggleRecording
    throw UnimplementedError();
  }

  @override
  uploadpresenter({required PlatformFile filename}) {
    // TODO: implement uploadpresenter
    throw UnimplementedError();
  }

  @override
  votepoll({required String poll_id, required String selectedOptionId}) {
    // TODO: implement votepoll
    throw UnimplementedError();
  }

  @override
  // TODO: implement chatMessages
  get chatMessages => throw UnimplementedError();

  @override
  breakeoutroom() {
    // TODO: implement breakeoutroom
    throw UnimplementedError();
  }

  @override
  // TODO: implement ishowecinema
  get ishowecinema => throw UnimplementedError();

  @override
  // TODO: implement stream
  Stream<String> get stream => throw UnimplementedError();

  @override
  Future<List<MediaDeviceInfo>> getAvailableCameras() {
    // TODO: implement getAvailableCameras
    throw UnimplementedError();
  }

  @override
  Future<List<MediaDeviceInfo>> getAvailableMicrophones() {
    // TODO: implement getAvailableMicrophones
    throw UnimplementedError();
  }

  @override
  stoptyping() {
    // TODO: implement stoptyping
    throw UnimplementedError();
  }

  @override
  switchVideoQuality({required int width, required int frameRate}) {
    // TODO: implement switchVideoQuality
    throw UnimplementedError();
  }

  @override
  switchcamera({required String deviceid}) {
    // TODO: implement switchcamera
    throw UnimplementedError();
  }

  @override
  switchmicrophone({required String deviceid}) {
    // TODO: implement switchmicrophone
    throw UnimplementedError();
  }

  @override
  nextpresentation({required String page}) {
    // TODO: implement nextpresentation
    throw UnimplementedError();
  }

  @override
  // TODO: implement presentationmodel
  get presentationmodel => throw UnimplementedError();

  @override
  removepresentation({required String presentationid}) {
    // TODO: implement removepresentation
    throw UnimplementedError();
  }

  @override
  makepresentationdefault({required presentation}) {
    // TODO: implement makepresentationdefault
    throw UnimplementedError();
  }

  @override
  startcaption() {
    // TODO: implement startcaption
    throw UnimplementedError();
  }

  @override
  starvirtual({required Uint8List backgroundimage}) {
    // TODO: implement starvirtual
    throw UnimplementedError();
  }

  @override
  stopcaption() {
    // TODO: implement stopcaption
    throw UnimplementedError();
  }

  @override
  whiteboard() {
    // TODO: implement whiteboard
    throw UnimplementedError();
  }

  @override
  endroom() {
    // TODO: implement endroom
    throw UnimplementedError();
  }

  @override
  lowerHand() {
    // TODO: implement lowerHand
    throw UnimplementedError();
  }

  @override
  raiseHand() {
    // TODO: implement raiseHand
    throw UnimplementedError();
  }

  @override
  // TODO: implement reason
  get reason => throw UnimplementedError();

  @override
  // TODO: implement recordingtime
  get recordingtime => throw UnimplementedError();
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
