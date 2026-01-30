import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bigbluebuttonsdk/provider/whiteboardcontroller.dart';
import 'package:bigbluebuttonsdk/utils/call_notification_service.dart';
import 'package:bigbluebuttonsdk/utils/strings.dart';
import 'package:bigbluebuttonsdk/view/whiteboard.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'bigbluebuttonsdk.dart' as navigator;
import 'bigbluebuttonsdk.dart';
import 'bigbluebuttonsdk_platform_interface.dart';
import 'exceptions.dart';

/// An implementation of [BigbluebuttonsdkPlatform] that uses method channels.
class MethodChannelBigbluebuttonsdk extends BigbluebuttonsdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bigbluebuttonsdk');

  String mediawebsocketurl = '';
  String mainwebsocketurl = '';
  String webrtctoken = '';
  String baseurl = '';
  Meetingdetails? meetingdetails;
  bool _sdkInitialized = false;

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }


  Future<void> switchToEarpiece() async {
    await methodChannel.invokeMethod('earpiece');
  }

  Future<void> switchToSpeaker() async {
    await methodChannel.invokeMethod('speaker');
  }

  Future<void> startScreenCapture() async {
    try {
      final result = await methodChannel.invokeMethod('startForegroundService');
      if (result == 'Permission granted and service started') {
        // Screen capture started successfully
        print('Screen capture started successfully');
      } else {
        print('Failed to start screen capture: $result');
      }
    } catch (e) {
      print('Error starting screen capture: $e');
    }
  }

  Future<void> stopScreenCapture() async {
    try {
      await methodChannel.invokeMethod('stopForegroundService');
    } catch (e) {
      print('Error stopping screen capture: $e');
    }
  }

  Future<void> switchToBluetooth() async {
    await methodChannel.invokeMethod('bluetooth');
  }

  Future<void> switchToWiredHeadset() async {
    await methodChannel.invokeMethod('headset');
  }

  @override
  initialize({
    required String baseurl,
    required String webrtctoken,
    required Meetingdetails meetingdetails,
  }) {
    assert(() {
      if (baseurl.isEmpty) {
        throw DuploException('baseurl cannot be null or empty');
        // } else if (!publicKey.startsWith("pk_")) {
        //   throw DuploException(Utils.getKeyErrorMsg('public'));
        // } else if (mainwebsocketur.isEmpty) {
        //   throw DuploException('secretKey cannot be null or empty');
        // } else if (!secretKey.startsWith("sk_")) {
        //   throw DuploException(Utils.getKeyErrorMsg('secret'));
      } else if (webrtctoken.isEmpty) {
        throw DuploException('webrtctoken cannot be null or empty');
        // } else if (!secretKey.startsWith("sk_")) {
        //   throw DuploException(Utils.getKeyErrorMsg('secret'));
      } else {
        return true;
      }
    }());

    if (sdkInitialized) return;

    mediawebsocketurl =
        'wss://${baseurl}bbb-webrtc-sfu?sessionToken=${webrtctoken}';
    mainwebsocketurl =
        "wss://${baseurl}html5client/sockjs/180/uspuwwsd/websocket";
    this.baseurl = baseurl;
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
  }

  bool get sdkInitialized => _sdkInitialized;

  var websocket = Get.put(Websocket());
  var texttospeech = Get.put(DirectSocketIOStreamer());
  var audiowebsocket = Get.put(Audiowebsocket());
  var videowebsocket = Get.put(Videowebsocket());
  var screensharewebsocket = Get.put(Screensharewebsocket());
  var remotevideowebsocket = Get.put(RemoteVideoWebSocket());
  var remotescreensharewebsocket = Get.put(RemoteScreenShareWebSocket());
  // var texttospeech = Get.put(Texttospeech());
  var whiteboardcontrolle = Get.put(Whiteboardcontroller());

  var isLeave = false;

  @override
  Future<Map<String, dynamic>>  clearEmojis() {
    return websocket.callMethod("setEmojiStatus", ["${websocket.myDetails!.fields!.userId}","none"]);
  }

  @override
  Future<Map<String, dynamic>>  muteAllExceptPresenter() {
    // toggleVoice
    return websocket.callMethod("muteAllExceptPresenter", ["${websocket.myDetails!.fields!.userId}"]);
  }

  @override
  Startroom(
      {required ValueChanged leavemeeting,
      required ValueChanged externalvideomeetings,
      required ValueChanged polls,
      required ValueChanged breakouts,
      required ValueChanged currentpoll}) {
    websocket = Get.put(Websocket());
    websocket.leavemeeting = leavemeeting;
    websocket.externalvideomeetings = externalvideomeetings;
    websocket.polls = polls;
    websocket.currentpoll = currentpoll;
    texttospeech = Get.put(DirectSocketIOStreamer());
    audiowebsocket = Get.put(Audiowebsocket());
    videowebsocket = Get.put(Videowebsocket());
    screensharewebsocket = Get.put(Screensharewebsocket());
    remotevideowebsocket = Get.put(RemoteVideoWebSocket());
    remotescreensharewebsocket = Get.put(RemoteScreenShareWebSocket());
    // texttospeech = Get.put(Texttospeech());
    whiteboardcontrolle = Get.put(Whiteboardcontroller());
    if (GetPlatform.isAndroid) {
      // Initialize the SDK instance for CallNotificationService
      CallNotificationService.initializeSdkInstance(this);

      CallNotificationService.initialize();

      CallNotificationService.showCallNotification(
        title: meetingdetails!.confname,
        status: 'Tap to return to the call',
      );

      // await startForegroundService();
      // initializeService();
    }
    websocket.initiate(
      webrtcToken: webrtctoken,
      baseUrl: baseurl,
      mainWebsocketUrl: mainwebsocketurl,
      mediaWebsocketUrl: mediawebsocketurl,
      meetingDetails: meetingdetails!,
    );
  }

  @override
  Future<Map<String, dynamic>>  typing({required String chatid}) {
   return websocket.callMethod("startUserTyping", ["${chatid == 'MAIN-PUBLIC-GROUP-CHAT' ? 'public' : chatid}"]);
  }

  @override
  Widget whiteboard() {
    return Whiteboard();
  }

  @override
  Future<Map<String, dynamic>> sendmessage({required String message, required String chatid}) {
   return websocket.callMethod("sendGroupChatMsg", ["$chatid",{"correlationId":"${websocket.meetingDetails!.internalUserId}-${DateTime.now()}","sender":{"id":"${websocket.meetingDetails!.internalUserId}","name":"","role":""},"chatEmphasizedText":true,"message":"${message}"}]);

  }

  @override
  Future<Map<String, dynamic>> sendecinema({required String videourl}) {
    websocket.isShowECinema = true;
   return websocket.callMethod("startWatchingExternalVideo", ["$videourl"]);
  }

  @override
  Future<Map<String, dynamic>> endecinema() {
    websocket.isShowECinema = false;
   return websocket.callMethod("stopWatchingExternalVideo", []);
  }

  @override
  Future<Map<String, dynamic>> startpoll({required String question, required List options}) {
    websocket.websocketSub([
      '{"msg":"sub","id":"2UY6dlRwTcfS48xlP","name":"current-poll","params":[false,true]}',
    ]);
    return websocket.callMethod("startPoll", [{"YesNo":"YN","YesNoAbstention":"YNA","TrueFalse":"TF","Letter":"A-","A2":"A-2","A3":"A-3","A4":"A-4","A5":"A-5","Custom":"CUSTOM","Response":"R-"},"CUSTOM","${websocket.myDetails!.fields!.userId!}/1",false,"${question}",false,jsonEncode(options)]);
  }

  @override
  Future<Map<String, dynamic>> votepoll({required String poll_id, required String selectedOptionId}) {
    websocket.websocketSub([
      '{"msg":"sub","id":"qPaGbQlNXGIYJam7t","name":"polls","params":[false]}',
    ]);
    return websocket.callMethod("publishVote", ["$poll_id",[selectedOptionId]]);
  }

  @override
  Future<Map<String, dynamic>> muteallusers() {
    return websocket.callMethod("muteAllUsers", []);
  }

  @override
  Future<Map<String, dynamic>> muteauser({required String userid}) {
    return websocket.callMethod("toggleVoice", ["$userid"]);
  }

  @override
  Future<Map<String, dynamic>> createGroupChat({required Participant participant}) {
    return websocket.callMethod("createGroupChat", [jsonEncode(participant.fields?.toJson())]);
  }

  @override
  uploadpresenter({required PlatformFile filename}) async {
    websocket.platformFile = filename;
    websocket.callMethod("requestPresentationUploadToken", ["DEFAULT_PRESENTATION_POD","${filename.name}","yMbQ5qmTpKOn834EuPwMtvKj"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"867","method":"requestPresentationUploadToken","params":["DEFAULT_PRESENTATION_POD","${filename.name}","yMbQ5qmTpKOn834EuPwMtvKj"]}",
    // ]);
    websocket.websocketSub([
      '{"msg":"sub","id":"PyItdbzmJUeOFfJyn","name":"presentation-upload-token","params":["DEFAULT_PRESENTATION_POD","${filename.name}","yMbQ5qmTpKOn834EuPwMtvKj"]}',
    ]);
  }

  @override
  Future<Map<String, dynamic>> removepresentation({required String presentationid}) async {
   var result = await websocket.callMethod("setPresentation", ["","DEFAULT_PRESENTATION_POD"]);
   // if (result != null) {
    return websocket.callMethod("removePresentation", ["$presentationid","DEFAULT_PRESENTATION_POD"]);
  }

  @override
  makepresentationdefault({required var presentation}) {
    websocket.makePresentationDefault(presentation: presentation);
  }

  @override
  Future<Map<String, dynamic>> nextpresentation({required String page}) {
    return websocket.callMethod("switchSlide", [page,"DEFAULT_PRESENTATION_POD"]);
  }

  @override
  Future<Map<String, dynamic>> raiseHand() {
    return websocket.callMethod("setEmojiStatus", ["${websocket.myDetails!.fields!.userId}","raiseHand"]);
  }

  @override
  Future<Map<String, dynamic>> lowerHand() {
    return websocket.callMethod("changeRaiseHand", [false]);
  }

  @override
  Future<Map<String, dynamic>> mutemyself() {
    return websocket.callMethod('toggleVoice', []);
  }

  @override
  Future<Map<String, dynamic>> allowPendingUsers(List<dynamic> participant, String policy) {
    // "{"msg":"method","id":"499","method":"allowPendingUsers","params":[[{"name":"ODEJINMI TOLULOPE","intId":"w_usontnyslc26","role":"VIEWER","avatar":"https://konn3ct.com/assets/images/konn3ctIcon.png","guest":false,"authenticated":true,"_id":"y7tgajM35toQgB74Q"}],"ALLOW"]}"
    List<dynamic> participants = [];
    participant.forEach((element) {
      participants.add(
        '{"name":"${element["fields"]["name"]}","intId":"${element["fields"]["intId"]}","role":"${element["fields"]["role"]}","avatar":"${element["fields"]["avatar"]}","guest":${element["fields"]["guest"]},"authenticated":${element["fields"]["authenticated"]},"_id":"${element["id"]}"}',
      );
    });
    return websocket.callMethod("allowPendingUsers", [participants,"$policy"]);
  }

  @override
  Future<Map<String, dynamic>> changeGuestPolicy(String policy) {
    return websocket.callMethod("changeGuestPolicy", [policy]);
  }

  @override
  Future<Map<String, dynamic>> stopcamera() async {
    videowebsocket.stopCameraSharing();
    return websocket.callMethod("userUnshareWebcam", [videowebsocket.streamID(videowebsocket.edSet.deviceId)]);
  }

  Future<Map<String, dynamic>> locksettings({
    required bool disableCam,
    required bool disableMic,
    required bool disableNotes,
    required bool disablePrivateChat,
    required bool disablePublicChat,
    required bool hideUserList,
    required bool hideViewersAnnotation,
    required bool hideViewersCursor,
    required bool lockOnJoinConfigurable,
    required bool lockOnJoin,
  }) {
   return websocket.callMethod("toggleLockSettings", [{"disableCam":disableCam,"disableMic":disableMic,"disableNotes":disableNotes,"disablePrivateChat":disablePrivateChat,"disablePublicChat":disablePublicChat,"hideUserList":hideUserList,"hideViewersAnnotation":hideViewersAnnotation,"hideViewersCursor":hideViewersCursor,"lockOnJoin":lockOnJoin,"lockOnJoinConfigurable":lockOnJoinConfigurable,"setBy":websocket.myDetails!.fields!.userId}]);
  }

  @override
  startcamera() {
    videowebsocket.initiate(
      webrtctoken: webrtctoken,
      mediawebsocketurl: mediawebsocketurl,
      meetingdetails: meetingdetails!,
    );
  }

  @override
  switchVideoQuality({
    required int width,
    /*int height,*/ required int frameRate,
  }) {
    videowebsocket.switchVideoQuality(width: width, frameRate: frameRate);
  }

  @override
  switchcamera({required String deviceid}) {
    videowebsocket.switchcamera(deviceid: deviceid);
  }

  @override
  starvirtual({required Uint8List backgroundimage}) {
    videowebsocket.starvirtual(backgroundimage: backgroundimage);
  }

  @override
  switchmicrophone({required String deviceid}) {
    audiowebsocket.switchmicrophone(deviceid: deviceid);
  }

  @override
  stopscreenshare() async {
    await stopScreenCapture();
    screensharewebsocket.stopScreenSharing();
  }

  @override
  startscreenshare(bool audio) async {
    // if (await isAndroidBelow13()) {
    var result = await startScreenCapture();
    // var result = await startForegroundService();
    // Get.back();
    //   if (result) {
    screensharewebsocket.initiate(
      webrtctoken: webrtctoken,
      mediawebsocketurl: mediawebsocketurl,
      meetingDetails: meetingdetails!,
      audio: audio,
    );
    // }
    // } else {
    //   Toast.show(
    //     "Android 13 or above screen sharing is coming soon",
    //     duration: Toast.lengthShort,
    //     gravity: Toast.bottom,
    //   );
    // }
  }

  Future<bool> isAndroidBelow13() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt < 33; // 33 is Android 13
    }
    return false; // Not Android
  }

  @override
  Future<List<navigator.MediaDeviceInfo>> getAvailableCameras() async {
    return videowebsocket.getdevices();
  }

  @override
  Future<List<navigator.MediaDeviceInfo>> getAvailableMicrophones() {
    return audiowebsocket.getdevices();
  }

  @override
  Future<List<navigator.MediaDeviceInfo>> getAvailableSpeakers() {
    return audiowebsocket.getaudiospeakerdevices();
  }

  @override
  Future<Map<String, dynamic>> changerole({required String userid, required String role}) {
    return websocket.callMethod("changeRole", ["$userid","$role"]);
  }

  @override
  Future<Map<String, dynamic>> assignpresenter({required String userid}) {
    return websocket.callMethod("assignPresenter", ["$userid"]);
  }

  @override
  Future<Map<String, dynamic>> leaveroom() async {
    // logoutJson();
    isLeave = true;
    await websocket.callMethod("userLeftMeeting", []);
    return websocket.callMethod("setExitReason", ["logout"]);
    // mainSub("unsub");
  }

  @override
  Future<Map<String, dynamic>> endroom() async {
    // logoutJson();
    isLeave = true;
    await websocket.callMethod("endMeeting", []);
    return websocket.callMethod("setExitReason", ["meetingEnded"]);
    // mainSub("unsub");
  }

  @override
  Future<Map<String, dynamic>> removeuser({required String userid, required bool notallowagain}) {
    return websocket.callMethod("removeUser", ["$userid"]);
  }

  @override
  List<ChatMessage> getchatMessages({required String chatid}) {
    return websocket.getChatMessages(chatid);
  }

  @override
  Future<Map<String, dynamic>> toggleRecording() {
    return websocket.callMethod("toggleRecording", []);
  }

  @override
  Future<Map<String, dynamic>> breakeoutroom() {
    return websocket.callMethod("createBreakoutRoom", [2,10,[],false,false,false,"room-",true,true,[]]);
  }

  @override
  Future<Map<String, dynamic>> stoptyping() {
    return websocket.callMethod("stopUserTyping", []);
  }

  // @override
  // // TODO: implement availableLanguages
  // get availableLanguages => websocket.meetingResponse!.fields.meetingProp.metadata!.availableLanguages;

  @override
  // TODO: implement mydetails
  get mydetails => websocket.myDetails;
  @override
  // TODO: implement isWebsocketRunning
  get isWebsocketRunning => websocket.isWebsocketRunning;
  @override
  // TODO: implement participant
  get participant => websocket.participant;
  @override
  // TODO: implement reason
  get reason => websocket.reason;
  @override
  // TODO: implement ispolling
  get ispolling => websocket.isPolling;

  @override
  // TODO: implement isrecording
  get isrecording => websocket.isRecording;

  @override
  // TODO: implement recordingtime
  get recordingtime => websocket.recordingTime;

  @override
  // TODO: implement pollanalyseparser
  get pollanalyseparser => websocket.pollAnalyseParser;
  @override
  // TODO: implement polljson
  get polljson => websocket.pollJson;
  @override
  // TODO: implement talking
  get talking => websocket.talking;

  @override
  // TODO: implement isvideo
  get isvideo => videowebsocket.isvideo;

  @override
  // TODO: implement chatMessages
  get chatMessages => websocket.chatMessages;
  @override
  // TODO: implement presentationmodel
  get presentationmodel => websocket.presentationModel;
  @override
  // TODO: implement ishowecinema
  get ishowecinema => websocket.isShowECinema;

  @override
  // TODO: implement stream
  Stream<String> get stream => websocket.stream;
}
