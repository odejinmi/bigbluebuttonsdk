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

  @override
  Future<Map<String, dynamic>> callMethod(String method, List<dynamic> params) {
    final completer = Completer<Map<String, dynamic>>();
    final id = generateRandomId(17);

    StreamSubscription<String>? subscription;

    subscription = websocket.stream.listen((message) {
      try {
        final json = jsonDecode(message);
        bool found = false;

        if (json['msg'] == 'result' && json['id'] == id) {
          if (!completer.isCompleted) {
            completer.complete(json);
          }
          found = true;
        } else if (json['msg'] == 'updated' &&
            json['methods'] != null &&
            (json['methods'] as List).contains(id)) {
          if (!completer.isCompleted) {
            completer.complete(json);
          }
          found = true;
        }

        if (found) {
          subscription?.cancel();
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
        subscription?.cancel();
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.completeError(
            TimeoutException("WebSocket response timeout for method $method"));
        subscription?.cancel();
      }
    });

    final List<String> jsonToSend = [
      jsonEncode({
        "msg": "method",
        "id": id,
        "method": method,
        "params": params,
      })
    ];

    websocket.websocketSub(jsonToSend);

    return completer.future;
  }

  bool _isCallActive = false;
  String _callStatus = 'Tap to return to the call';
  late Timer? _notificationWatcher = null;

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
        throw DuploException('publicKey cannot be null or empty');
        // } else if (!publicKey.startsWith("pk_")) {
        //   throw DuploException(Utils.getKeyErrorMsg('public'));
        // } else if (mainwebsocketur.isEmpty) {
        //   throw DuploException('secretKey cannot be null or empty');
        // } else if (!secretKey.startsWith("sk_")) {
        //   throw DuploException(Utils.getKeyErrorMsg('secret'));
      } else if (webrtctoken.isEmpty) {
        throw DuploException('secretKey cannot be null or empty');
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

  @override
  Startroom() {
    websocket = Get.put(Websocket());
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

      // setState(() {
      _isCallActive = true;
      _callStatus = 'Connected';
      // });

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
  typing({required String chatid}) {
    callMethod("startUserTyping", ["${chatid == 'MAIN-PUBLIC-GROUP-CHAT' ? 'public' : chatid}"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"120","method":"startUserTyping","params":["${chatid == 'MAIN-PUBLIC-GROUP-CHAT' ? 'public' : chatid}"]}",
    // ]);
  }

  @override
  Widget whiteboard() {
    return Whiteboard();
  }

  @override
  sendmessage({required String message, required String chatid}) {
    callMethod("sendGroupChatMsg", ["$chatid",{"correlationId":"${websocket.meetingDetails!.internalUserId}-${DateTime.now()}","sender":{"id":"${websocket.meetingDetails!.internalUserId}","name":"","role":""},"chatEmphasizedText":true,"message":"${message}"}]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"14","method":"sendGroupChatMsg","params":["$chatid",{"correlationId":"${websocket.meetingDetails!.internalUserId}-${DateTime.now()}","sender":{"id":"${websocket.meetingDetails!.internalUserId}","name":"","role":""},"chatEmphasizedText":true,"message":"${message}"}]}",
    // ]);
  }

  @override
  sendecinema({required String videourl}) {
    websocket.isShowECinema = true;
    callMethod("startWatchingExternalVideo", ["$videourl"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"317","method":"startWatchingExternalVideo","params":["$videourl"]}",
    // ]);
  }

  @override
  endecinema() {
    websocket.isShowECinema = false;
    callMethod("stopWatchingExternalVideo", []);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"940","method":"stopWatchingExternalVideo","params":[]}",
    // ]);
  }

  @override
  startpoll({required String question, required List options}) {
    websocket.websocketSub([
      '{"msg":"sub","id":"2UY6dlRwTcfS48xlP","name":"current-poll","params":[false,true]}',
    ]);
    callMethod("startPoll", [{"YesNo":"YN","YesNoAbstention":"YNA","TrueFalse":"TF","Letter":"A-","A2":"A-2","A3":"A-3","A4":"A-4","A5":"A-5","Custom":"CUSTOM","Response":"R-"},"CUSTOM","${websocket.myDetails!.fields!.userId!}/1",false,"${question}",false,jsonEncode(options)]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"52","method":"startPoll","params":[{"YesNo":"YN","YesNoAbstention":"YNA","TrueFalse":"TF","Letter":"A-","A2":"A-2","A3":"A-3","A4":"A-4","A5":"A-5","Custom":"CUSTOM","Response":"R-"},"CUSTOM","${websocket.myDetails!.fields!.userId!}/1",false,"${question}",false,${jsonEncode(options)}]}",
    // ]);
  }

  @override
  votepoll({required String poll_id, required String selectedOptionId}) {
    websocket.websocketSub([
      '{"msg":"sub","id":"qPaGbQlNXGIYJam7t","name":"polls","params":[false]}',
    ]);
    callMethod("publishVote", ["$poll_id",[selectedOptionId]]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"136","method":"publishVote","params":["$poll_id",[$selectedOptionId]]}",
    // ]);
  }

  @override
  Future<Map<String, dynamic>> muteallusers() {
    return callMethod("muteAllUsers", []);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"11","method":"muteAllUsers","params":[""]}",
    // ]);
  }

  @override
  muteauser({required String userid}) {
    callMethod("toggleVoice", ["$userid"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"44","method":"toggleVoice","params":["$userid"]}",
    // ]);
  }

  @override
  createGroupChat({required Participant participant}) {
    // Chats().createGroupChat(participant: participant);
    // "{"msg":"method","id":"957","method":"createGroupChat","params":[{"subscriptionId":"wWxgIKTehg5OR6P1A","meetingId":"1cbd2cb09db2ac48529827879eaad399f2e11c9f-1749702556588","userId":"w_9bhtyhpznvxe","clientType":"HTML5","validated":true,"left":false,"approved":true,"authTokenValidatedTime":1749702604070,"inactivityCheck":false,"loginTime":1749702602616,"authed":true,"avatar":"https://ui-avatars.com/api/?name=videx&bold=true","away":false,"breakoutProps":{"isBreakoutUser":false,"parentId":"bbb-none"},"color":"#4a148c","effectiveConnectionType":null,"emoji":"none","extId":"odejinmiabraham@gmail.com","guest":false,"guestStatus":"ALLOW","intId":"w_9bhtyhpznvxe","locked":true,"loggedOut":false,"mobile":false,"name":"videx","pin":false,"presenter":false,"raiseHand":false,"reactionEmoji":"none","responseDelay":0,"role":"VIEWER","sortName":"videx","speechLocale":"","connection_status":"normal","id":"Fth2CaBDcLQov9PJm"}]}"
    // var json = [
    //   // "{"msg":"method","id":"900","method":"createGroupChat","params":[{"subscriptionId":"wWxgIKTehg5OR6P1A","meetingId":"${_service.meetingdetails.meetingId}","userId":"${participant.fields?.userId}","clientType":"HTML5","validated":true,"left":false,"approved":true,"authTokenValidatedTime":1749702604070,"inactivityCheck":false,"loginTime":1749702602616,"authed":true,"avatar":"${participant.fields?.avatar}","away":false,"breakoutProps":${participant.fields?.breakoutProps},"color":"#4a148c","effectiveConnectionType":null,"emoji":"none","extId":"odejinmiabraham@gmail.com","guest":false,"guestStatus":"ALLOW","intId":"w_9bhtyhpznvxe","locked":true,"loggedOut":false,"mobile":false,"name":"videx","pin":false,"presenter":false,"raiseHand":false,"reactionEmoji":"none","responseDelay":0,"role":"VIEWER","sortName":"videx","speechLocale":"","connection_status":"normal","id":"Fth2CaBDcLQov9PJm"}]}"
    //   "{"msg":"method","id":"900","method":"createGroupChat","params":[${jsonEncode(participant.fields?.toJson())}]}"
    // ];
    // websocket.websocketSub(json);
    callMethod("createGroupChat", [jsonEncode(participant.fields?.toJson())]);
  }

  @override
  uploadpresenter({required PlatformFile filename}) async {
    websocket.platformFile = filename;
    callMethod("requestPresentationUploadToken", ["DEFAULT_PRESENTATION_POD","${filename.name}","yMbQ5qmTpKOn834EuPwMtvKj"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"867","method":"requestPresentationUploadToken","params":["DEFAULT_PRESENTATION_POD","${filename.name}","yMbQ5qmTpKOn834EuPwMtvKj"]}",
    // ]);
    websocket.websocketSub([
      '{"msg":"sub","id":"PyItdbzmJUeOFfJyn","name":"presentation-upload-token","params":["DEFAULT_PRESENTATION_POD","${filename.name}","yMbQ5qmTpKOn834EuPwMtvKj"]}',
    ]);
  }

  @override
  removepresentation({required String presentationid}) {
    callMethod("setPresentation", ["","DEFAULT_PRESENTATION_POD"]);
    callMethod("removePresentation", ["$presentationid","DEFAULT_PRESENTATION_POD"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"31","method":"setPresentation","params":["","DEFAULT_PRESENTATION_POD"]}",
    // ]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"32","method":"removePresentation","params":["$presentationid","DEFAULT_PRESENTATION_POD"]}",
    // ]);
  }

  @override
  makepresentationdefault({required var presentation}) {
    websocket.makePresentationDefault(presentation: presentation);
  }

  @override
  nextpresentation({required String page}) {
    callMethod("switchSlide", [page,"DEFAULT_PRESENTATION_POD"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"33","method":"switchSlide","params":[$page,"DEFAULT_PRESENTATION_POD"]}",
    // ]);
  }

  @override
  raiseHand() {
    callMethod("setEmojiStatus", ["${websocket.myDetails!.fields!.userId}","raiseHand"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"643","method":"setEmojiStatus","params":["${websocket.myDetails!.fields!.userId}","raiseHand"]}",
    // ]);
  }

  @override
  lowerHand() {
    callMethod("changeRaiseHand", [false]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"659","method":"changeRaiseHand","params":[false]}",
    // ]);
  }

  @override
  Future<Map<String, dynamic>> mutemyself() {
    return callMethod('toggleVoice', []);
  }

  @override
  allowPendingUsers(List<dynamic> participant, String policy) {
    // "{"msg":"method","id":"499","method":"allowPendingUsers","params":[[{"name":"ODEJINMI TOLULOPE","intId":"w_usontnyslc26","role":"VIEWER","avatar":"https://konn3ct.com/assets/images/konn3ctIcon.png","guest":false,"authenticated":true,"_id":"y7tgajM35toQgB74Q"}],"ALLOW"]}"
    List<dynamic> participants = [];
    participant.forEach((element) {
      participants.add(
        '{"name":"${element["fields"]["name"]}","intId":"${element["fields"]["intId"]}","role":"${element["fields"]["role"]}","avatar":"${element["fields"]["avatar"]}","guest":${element["fields"]["guest"]},"authenticated":${element["fields"]["authenticated"]},"_id":"${element["id"]}"}',
      );
    });
    callMethod("allowPendingUsers", [participants,"$policy"]);
    // var result =
    //     "{"msg":"method","id":"499","method":"allowPendingUsers","params":[$participants,"$policy"]}";
    // print(result);
    // //ALLOW, DENY
    // websocket.websocketSub([result]);
  }

  @override
  changeGuestPolicy(String policy) {
    callMethod("changeGuestPolicy", [policy]);
    // websocket.websocketSub([
    //   //ASK_MODERATOR, ALWAYS_ACCEPT
    //   "{"msg":"method","id":"540","method":"changeGuestPolicy","params":["$policy"]}",
    // ]);
  }

  @override
  stopcamera() {
    callMethod("userUnshareWebcam", [videowebsocket.streamID(videowebsocket.edSet.deviceId)]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"100","method":"userUnshareWebcam","params":["${videowebsocket.streamID(videowebsocket.edSet.deviceId)}"]}",
    // ]);
    videowebsocket.stopCameraSharing();
  }

  locksettings({
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
    print("disableCam call $disableCam");
    callMethod("toggleLockSettings", [{"disableCam":disableCam,"disableMic":disableMic,"disableNotes":disableNotes,"disablePrivateChat":disablePrivateChat,"disablePublicChat":disablePublicChat,"hideUserList":hideUserList,"hideViewersAnnotation":hideViewersAnnotation,"hideViewersCursor":hideViewersCursor,"lockOnJoin":lockOnJoin,"lockOnJoinConfigurable":lockOnJoinConfigurable,"setBy":"websocket.myDetails!.fields!.userId"}]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"101","method":"toggleLockSettings","params":[{"disableCam":${disableCam},"disableMic":${disableMic},"disableNotes":${disableNotes},"disablePrivateChat":${disablePrivateChat},"disablePublicChat":${disablePublicChat},"hideUserList":${hideUserList},"hideViewersAnnotation":${hideViewersAnnotation},"hideViewersCursor":${hideViewersCursor},"lockOnJoin":${lockOnJoin},"lockOnJoinConfigurable":${lockOnJoinConfigurable},"setBy":"${websocket.myDetails!.fields!.userId}"}]}",
    // ]);
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
  changerole({required String userid, required String role}) {
    callMethod("changeRole", ["$userid","$role"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"13","method":"changeRole","params":["$userid","$role"]}",
    // ]);
  }

  @override
  assignpresenter({required String userid}) {
    callMethod("assignPresenter", ["$userid"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"19","method":"assignPresenter","params":["$userid"]}",
    // ]);
  }

  @override
  leaveroom() {
    websocket.leaveRoom();
  }

  @override
  endroom() {
    websocket.endRoom();
  }

  @override
  removeuser({required String userid, required bool notallowagain}) {
    callMethod("removeUser", ["$userid"]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"20","method":"removeUser","params":["$userid"]}",
    // ]);
  }

  @override
  List<ChatMessage> getchatMessages({required String chatid}) {
    return websocket.getChatMessages(chatid);
  }

  @override
  toggleRecording() {
    callMethod("toggleRecording", []);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"${generateRandomId(17)}","method":"toggleRecording","params":[]}",
    // ]);
  }

  @override
  breakeoutroom() {
    callMethod("createBreakoutRoom", [2,10,[],false,false,false,"room-",true,true,[]]);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"17","method":"createBreakoutRoom","params":[2,10,[],false,false,false,"room-",true,true,[]]}",
    // ]);
  }

  @override
  stoptyping() {
    callMethod("stopUserTyping", []);
    // websocket.websocketSub([
    //   "{"msg":"method","id":"336","method":"stopUserTyping","params":[]}",
    // ]);
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
