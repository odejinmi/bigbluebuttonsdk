import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'bigbluebuttonsdk_platform_interface.dart';
import 'utils/chatmodel.dart';
import 'utils/meetingdetails.dart';
import 'utils/meetingresponse.dart';
import 'utils/participant.dart';

export 'package:flutter_webrtc/flutter_webrtc.dart';

export 'provider/DirectSocketIOStreamer.dart';
// import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

export 'provider/audiowebsocket.dart';
export 'provider/remotescreenshare.dart';
export 'provider/remotevideowebsocket.dart';
export 'provider/screensharewebsocket.dart';
export 'provider/videowebsocket.dart';
export 'provider/websocket.dart';
export 'utils/beautyFilters.dart';
export 'utils/chatmodel.dart';
export 'utils/meetingdetails.dart';
export 'utils/native/virtual_background/index.dart';
export 'utils/participant.dart';
export 'utils/pollanalyseparser.dart';
export 'utils/typingmodel.dart';

class Bigbluebuttonsdk {
  static Bigbluebuttonsdk _instance = Bigbluebuttonsdk();

  /// The default instance of [BigbluebuttonsdkPlatform] to use.
  ///
  /// Defaults to [Bigbluebuttonsdk].
  static Bigbluebuttonsdk get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Bigbluebuttonsdk] when
  /// they register themselves.
  static set instance(Bigbluebuttonsdk instance) {
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    return BigbluebuttonsdkPlatform.instance.getPlatformVersion();
  }

  void Startroom(
      {ValueChanged? leavemeeting,
        ValueChanged? externalvideomeetings,
        ValueChanged? polls,
        ValueChanged? breakouts,
        ValueChanged? currentpoll}) {
    BigbluebuttonsdkPlatform.instance.Startroom(
      leavemeeting: leavemeeting,
      externalvideomeetings: externalvideomeetings,
      polls: polls,
      currentpoll: currentpoll,
      breakouts: breakouts,
    );
  }

  void initialize(
      {required String baseurl,
      required String webrtctoken,
      required Meetingdetails meetingdetails}) {
    BigbluebuttonsdkPlatform.instance.initialize(
        baseurl: baseurl,
        webrtctoken: webrtctoken,
        meetingdetails: meetingdetails);
  }

  Future<Map<String, dynamic>> locksettings({
    bool disableCam = false,
    bool disableMic = false,
    bool disableNotes = false,
    bool disablePrivateChat = false,
    bool disablePublicChat = false,
    bool hideUserList = false,
    bool hideViewersAnnotation = false,
    bool hideViewersCursor = false,
    bool lockOnJoinConfigurable = false,
    bool lockOnJoin = false,
  }) {
    return BigbluebuttonsdkPlatform.instance.locksettings(
        disableCam: disableCam,
        disableMic: disableMic,
        disableNotes: disableNotes,
        disablePrivateChat: disablePrivateChat,
        disablePublicChat: disablePublicChat,
        hideUserList: hideUserList,
        hideViewersAnnotation: hideViewersAnnotation,
        hideViewersCursor: hideViewersCursor,
        lockOnJoinConfigurable: lockOnJoinConfigurable,
        lockOnJoin: lockOnJoin);
  }

  Future<Map<String, dynamic>> typing({required String chatid}) {
    return BigbluebuttonsdkPlatform.instance.typing(chatid: chatid);
  }

  Future<Map<String, dynamic>> sendmessage({required String message, required String chatid}) {
    return BigbluebuttonsdkPlatform.instance
        .sendmessage(chatid: chatid, message: message);
  }

  Future<Map<String, dynamic>> sendecinema({required String videourl}) {
    return BigbluebuttonsdkPlatform.instance.sendecinema(videourl: videourl);
  }

  Future<Map<String, dynamic>> allowPendingUsers(List<dynamic> participant, String policy) {
    return BigbluebuttonsdkPlatform.instance.allowPendingUsers(participant, policy);
  }

  Future<Map<String, dynamic>> changeGuestPolicy(String policy) {
    return BigbluebuttonsdkPlatform.instance.changeGuestPolicy(policy);
  }

  Future<void> startScreenCapture() {
    return BigbluebuttonsdkPlatform.instance.startScreenCapture();
  }

  Future<void> stopScreenCapture() {
    return BigbluebuttonsdkPlatform.instance.stopScreenCapture();
  }

  Widget whiteboard() {
    return BigbluebuttonsdkPlatform.instance.whiteboard();
  }

  Future<Map<String, dynamic>> endecinema() {
    return BigbluebuttonsdkPlatform.instance.endecinema();
  }

  Future<Map<String, dynamic>> pauseplayecinema({required String status, required int time}) {
    return BigbluebuttonsdkPlatform.instance.pauseplayecinema(status: status, time: time);
  }
  Future<Map<String, dynamic>> ecinematime({required int rate, required int time}) {
    return BigbluebuttonsdkPlatform.instance.ecinematime(rate: rate, time: time);
  }
  Future<Map<String, dynamic>> startpoll({required String question, required List options}) {
    return BigbluebuttonsdkPlatform.instance
        .startpoll(question: question, options: options);
  }

  Future<Map<String, dynamic>> votepoll({required String poll_id, required String selectedOptionId}) {
    return BigbluebuttonsdkPlatform.instance
        .votepoll(poll_id: poll_id, selectedOptionId: selectedOptionId);
  }

  Future<Map<String, dynamic>> muteallusers() {
    return BigbluebuttonsdkPlatform.instance.muteallusers();
  }

  Future<Map<String, dynamic>> muteauser({
    required String userid,
  }) {
    return BigbluebuttonsdkPlatform.instance.muteauser(userid: userid);
  }

  Future<Map<String, dynamic>> createGroupChat({
    required Participant participant,
  }) {
    return BigbluebuttonsdkPlatform.instance.createGroupChat(participant: participant);
  }

  void uploadpresenter({
    required PlatformFile filename,
  }) {
    BigbluebuttonsdkPlatform.instance.uploadpresenter(filename: filename);
  }

  Future<Map<String, dynamic>> raiseHand() {
    return BigbluebuttonsdkPlatform.instance.raiseHand();
  }

  Future<Map<String, dynamic>> lowerHand() {
    return BigbluebuttonsdkPlatform.instance.lowerHand();
  }

  void switchVideoQuality(
      {required int width, /*int height,*/ required int frameRate}) {
    BigbluebuttonsdkPlatform.instance
        .switchVideoQuality(width: width, frameRate: frameRate);
  }

  void switchVideocamera({required String deviceid}) {
    BigbluebuttonsdkPlatform.instance.switchcamera(deviceid: deviceid);
  }

  void switchmicrophone({required String deviceid}) {
    BigbluebuttonsdkPlatform.instance.switchmicrophone(deviceid: deviceid);
  }

  Future<Map<String, dynamic>> removepresentation({required String presentationid}) {
    return BigbluebuttonsdkPlatform.instance
        .removepresentation(presentationid: presentationid);
  }

  Future<Map<String, dynamic>> nextpresentation({required String page}) {
    return BigbluebuttonsdkPlatform.instance.nextpresentation(page: page);
  }

  void makepresentationdefault({required var presentation}) {
    BigbluebuttonsdkPlatform.instance
        .makepresentationdefault(presentation: presentation);
  }

  Future<Map<String, dynamic>> mutemyself() {
    return BigbluebuttonsdkPlatform.instance.mutemyself();
  }

  void stopcamera() {
    BigbluebuttonsdkPlatform.instance.stopcamera();
  }

  void startcamera() {
    BigbluebuttonsdkPlatform.instance.startcamera();
  }

  void stopscreenshare() {
    BigbluebuttonsdkPlatform.instance.stopscreenshare();
  }

  void startscreenshare(bool audio) {
    BigbluebuttonsdkPlatform.instance.startscreenshare(audio);
  }

  Future<Map<String, dynamic>> changerole({required String userid, required String role}) {
    return BigbluebuttonsdkPlatform.instance.changerole(userid: userid, role: role);
  }

  Future<Map<String, dynamic>> assignpresenter({required String userid}) {
    return BigbluebuttonsdkPlatform.instance.assignpresenter(userid: userid);
  }

  Future<Map<String, dynamic>> removeuser({required String userid, required bool notallowagain}) {
    return BigbluebuttonsdkPlatform.instance
        .removeuser(userid: userid, notallowagain: notallowagain);
  }

  Future<Map<String, dynamic>> leaveroom() {
    return BigbluebuttonsdkPlatform.instance.leaveroom();
  }

  Future<Map<String, dynamic>> muteAllExceptPresenter() {
    return BigbluebuttonsdkPlatform.instance.muteAllExceptPresenter();
  }

  Future<Map<String, dynamic>> toggleRecording() {
    return BigbluebuttonsdkPlatform.instance.toggleRecording();
  }

  Future<Map<String, dynamic>> breakeoutroom() {
    return BigbluebuttonsdkPlatform.instance.breakeoutroom();
  }

  Future<Map<String, dynamic>> stoptyping() {
    return BigbluebuttonsdkPlatform.instance.stoptyping();
  }

  Future<Map<String, dynamic>> endroom() {
    return BigbluebuttonsdkPlatform.instance.endroom();
  }

  void starvirtual({required Uint8List backgroundimage}) {
    BigbluebuttonsdkPlatform.instance
        .starvirtual(backgroundimage: backgroundimage);
  }

  List<ChatMessage> getchatMessages({
    required String chatid,
  }) {
    return BigbluebuttonsdkPlatform.instance.getchatMessages(chatid: chatid);
  }

  dynamic get participant {
    return BigbluebuttonsdkPlatform.instance.participant;
  }

  // get availableLanguages {
  //   return BigbluebuttonsdkPlatform.instance.availableLanguages;
  // }

  dynamic get mydetails {
    return BigbluebuttonsdkPlatform.instance.mydetails;
  }

  dynamic get isWebsocketRunning {
    return BigbluebuttonsdkPlatform.instance.isWebsocketRunning;
  }

  dynamic get polljson {
    return BigbluebuttonsdkPlatform.instance.polljson;
  }

  dynamic get isrecording {
    return BigbluebuttonsdkPlatform.instance.isrecording;
  }

  MeetingResponse? get meetingResponse {
    return BigbluebuttonsdkPlatform.instance.meetingResponse;
  }

  dynamic get recordingtime {
    return BigbluebuttonsdkPlatform.instance.recordingtime;
  }

  dynamic get pollanalyseparser {
    return BigbluebuttonsdkPlatform.instance.pollanalyseparser;
  }

  dynamic get talking {
    return BigbluebuttonsdkPlatform.instance.talking;
  }

  dynamic get isvideo {
    return BigbluebuttonsdkPlatform.instance.isvideo;
  }

  dynamic get chatMessages {
    return BigbluebuttonsdkPlatform.instance.chatMessages;
  }

  dynamic get reason {
    return BigbluebuttonsdkPlatform.instance.reason;
  }

  dynamic get ishowecinema {
    return BigbluebuttonsdkPlatform.instance.ishowecinema;
  }

  dynamic get presentationmodel {
    return BigbluebuttonsdkPlatform.instance.presentationmodel;
  }

  Future<List<MediaDeviceInfo>> getAvailableCameras() {
    return BigbluebuttonsdkPlatform.instance.getAvailableCameras();
  }

  Future<List<MediaDeviceInfo>> getAvailableMicrophones() {
    return BigbluebuttonsdkPlatform.instance.getAvailableMicrophones();
  }

  Future<List<MediaDeviceInfo>> getAvailableSpeakers() {
    return BigbluebuttonsdkPlatform.instance.getAvailableSpeakers();
  }

  Stream<String> get stream {
    return BigbluebuttonsdkPlatform.instance.stream;
  }

  Stream<BigbluebuttonsdkEvent> get events => stream
      .map(BigbluebuttonsdkEvent.tryParse)
      .where((event) => event != null)
      .cast<BigbluebuttonsdkEvent>();

  Stream<BigbluebuttonsdkEvent> get leaveMeetingEvents => events.where((e) {
        if (e.collection == 'current-user') {
          return e.fields?['loggedOut'] == true;
        }
        if (e.collection == 'meetings') {
          return e.fields?['meetingEnded'] == true;
        }
        return false;
      });

  Stream<BigbluebuttonsdkEvent> get externalVideoMeetingEvents =>
      events.where((e) => e.collection == 'external-video-meetings');

  Stream<BigbluebuttonsdkEvent> get pollEvents =>
      events.where((e) => e.collection == 'polls');

  Stream<BigbluebuttonsdkEvent> get currentPollEvents =>
      events.where((e) => e.collection == 'current-poll');

  Stream<BigbluebuttonsdkEvent> get breakoutEvents =>
      events.where((e) => e.collection == 'breakouts');
}

class BigbluebuttonsdkEvent {
  final Map<String, dynamic> raw;

  BigbluebuttonsdkEvent(this.raw);

  String? get msg => raw['msg']?.toString();
  String? get collection => raw['collection']?.toString();
  String? get id => raw['id']?.toString();
  Map<String, dynamic>? get fields {
    final value = raw['fields'];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
    return null;
  }

  static BigbluebuttonsdkEvent? tryParse(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return BigbluebuttonsdkEvent(decoded);
      if (decoded is Map) {
        return BigbluebuttonsdkEvent(
          decoded.map((k, v) => MapEntry(k.toString(), v)),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'msg': msg,
    'collection': collection,
    'id' : id,
    'fields': fields
  };
}
