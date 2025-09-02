import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bigbluebuttonsdk/provider/whiteboardcontroller.dart';
import 'package:bigbluebuttonsdk/utils/call_notification_service.dart';
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

  bool _isCallActive = false;
  String _callStatus = 'Tap to return to the call';
  late Timer _notificationWatcher;

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
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      // Initialize the SDK instance for CallNotificationService
      CallNotificationService.initializeSdkInstance(this);

      CallNotificationService.initialize();

      // Watch for notification dismissal and recreate if needed
      _notificationWatcher = Timer.periodic(Duration(seconds: 2), (timer) {
        if (_isCallActive && CallNotificationService.isNotificationActive) {
          CallNotificationService.ensureNotificationExists(
            title: websocket.meetingDetails!.confname,
            status: "Tap to return to the call",
          );
        }
      });

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
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"120\",\"method\":\"startUserTyping\",\"params\":[\"${chatid == 'MAIN-PUBLIC-GROUP-CHAT' ? 'public' : chatid}\"]}",
    ]);
  }

  @override
  Widget whiteboard() {
    return Whiteboard();
  }

  @override
  sendmessage({required String message, required String chatid}) {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"14\",\"method\":\"sendGroupChatMsg\",\"params\":[\"$chatid\",{\"correlationId\":\"${websocket.meetingDetails!.internalUserId}-${DateTime.now()}\",\"sender\":{\"id\":\"${websocket.meetingDetails!.internalUserId}\",\"name\":\"\",\"role\":\"\"},\"chatEmphasizedText\":true,\"message\":\"${message}\"}]}",
    ]);
  }

  @override
  sendecinema({required String videourl}) {
    websocket.isShowECinema = true;
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"317\",\"method\":\"startWatchingExternalVideo\",\"params\":[\"$videourl\"]}",
    ]);
  }

  @override
  endecinema() {
    websocket.isShowECinema = false;
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"940\",\"method\":\"stopWatchingExternalVideo\",\"params\":[]}",
    ]);
  }

  @override
  startpoll({required String question, required List options}) {
    websocket.websocketSub([
      "{\"msg\":\"sub\",\"id\":\"2UY6dlRwTcfS48xlP\",\"name\":\"current-poll\",\"params\":[false,true]}",
    ]);
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"52\",\"method\":\"startPoll\",\"params\":[{\"YesNo\":\"YN\",\"YesNoAbstention\":\"YNA\",\"TrueFalse\":\"TF\",\"Letter\":\"A-\",\"A2\":\"A-2\",\"A3\":\"A-3\",\"A4\":\"A-4\",\"A5\":\"A-5\",\"Custom\":\"CUSTOM\",\"Response\":\"R-\"},\"CUSTOM\",\"${websocket.myDetails!.fields!.userId!}/1\",false,\"${question}\",false,${jsonEncode(options)}]}",
    ]);
  }

  @override
  votepoll({required String poll_id, required String selectedOptionId}) {
    websocket.websocketSub([
      "{\"msg\":\"sub\",\"id\":\"qPaGbQlNXGIYJam7t\",\"name\":\"polls\",\"params\":[false]}",
    ]);
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"136\",\"method\":\"publishVote\",\"params\":[\"$poll_id\",[$selectedOptionId]]}",
    ]);
  }

  @override
  muteallusers({required String userid}) {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"11\",\"method\":\"muteAllUsers\",\"params\":[\"${userid}\"]}",
    ]);
  }

  @override
  createGroupChat({required Participant participant}) {
    // Chats().createGroupChat(participant: participant);
    // "{\"msg\":\"method\",\"id\":\"957\",\"method\":\"createGroupChat\",\"params\":[{\"subscriptionId\":\"wWxgIKTehg5OR6P1A\",\"meetingId\":\"1cbd2cb09db2ac48529827879eaad399f2e11c9f-1749702556588\",\"userId\":\"w_9bhtyhpznvxe\",\"clientType\":\"HTML5\",\"validated\":true,\"left\":false,\"approved\":true,\"authTokenValidatedTime\":1749702604070,\"inactivityCheck\":false,\"loginTime\":1749702602616,\"authed\":true,\"avatar\":\"https://ui-avatars.com/api/?name=videx&bold=true\",\"away\":false,\"breakoutProps\":{\"isBreakoutUser\":false,\"parentId\":\"bbb-none\"},\"color\":\"#4a148c\",\"effectiveConnectionType\":null,\"emoji\":\"none\",\"extId\":\"odejinmiabraham@gmail.com\",\"guest\":false,\"guestStatus\":\"ALLOW\",\"intId\":\"w_9bhtyhpznvxe\",\"locked\":true,\"loggedOut\":false,\"mobile\":false,\"name\":\"videx\",\"pin\":false,\"presenter\":false,\"raiseHand\":false,\"reactionEmoji\":\"none\",\"responseDelay\":0,\"role\":\"VIEWER\",\"sortName\":\"videx\",\"speechLocale\":\"\",\"connection_status\":\"normal\",\"id\":\"Fth2CaBDcLQov9PJm\"}]}"
    var json = [
      // "{\"msg\":\"method\",\"id\":\"900\",\"method\":\"createGroupChat\",\"params\":[{\"subscriptionId\":\"wWxgIKTehg5OR6P1A\",\"meetingId\":\"${_service.meetingdetails.meetingId}\",\"userId\":\"${participant.fields?.userId}\",\"clientType\":\"HTML5\",\"validated\":true,\"left\":false,\"approved\":true,\"authTokenValidatedTime\":1749702604070,\"inactivityCheck\":false,\"loginTime\":1749702602616,\"authed\":true,\"avatar\":\"${participant.fields?.avatar}\",\"away\":false,\"breakoutProps\":${participant.fields?.breakoutProps},\"color\":\"#4a148c\",\"effectiveConnectionType\":null,\"emoji\":\"none\",\"extId\":\"odejinmiabraham@gmail.com\",\"guest\":false,\"guestStatus\":\"ALLOW\",\"intId\":\"w_9bhtyhpznvxe\",\"locked\":true,\"loggedOut\":false,\"mobile\":false,\"name\":\"videx\",\"pin\":false,\"presenter\":false,\"raiseHand\":false,\"reactionEmoji\":\"none\",\"responseDelay\":0,\"role\":\"VIEWER\",\"sortName\":\"videx\",\"speechLocale\":\"\",\"connection_status\":\"normal\",\"id\":\"Fth2CaBDcLQov9PJm\"}]}"
      "{\"msg\":\"method\",\"id\":\"900\",\"method\":\"createGroupChat\",\"params\":[${jsonEncode(participant.fields?.toJson())}]}"
    ];
    websocket.websocketSub(json);
  }

  @override
  uploadpresenter({required PlatformFile filename}) async {
    websocket.platformFile = filename;
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"867\",\"method\":\"requestPresentationUploadToken\",\"params\":[\"DEFAULT_PRESENTATION_POD\",\"${filename.name}\",\"yMbQ5qmTpKOn834EuPwMtvKj\"]}",
    ]);
    websocket.websocketSub([
      "{\"msg\":\"sub\",\"id\":\"PyItdbzmJUeOFfJyn\",\"name\":\"presentation-upload-token\",\"params\":[\"DEFAULT_PRESENTATION_POD\",\"${filename.name}\",\"yMbQ5qmTpKOn834EuPwMtvKj\"]}",
    ]);
  }

  @override
  removepresentation({required String presentationid}) {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"31\",\"method\":\"setPresentation\",\"params\":[\"\",\"DEFAULT_PRESENTATION_POD\"]}",
    ]);
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"32\",\"method\":\"removePresentation\",\"params\":[\"$presentationid\",\"DEFAULT_PRESENTATION_POD\"]}",
    ]);
  }

  @override
  makepresentationdefault({required var presentation}) {
    websocket.makePresentationDefault(presentation: presentation);
  }

  @override
  nextpresentation({required String page}) {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"33\",\"method\":\"switchSlide\",\"params\":[$page,\"DEFAULT_PRESENTATION_POD\"]}",
    ]);
  }

  @override
  raiseHand() {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"643\",\"method\":\"setEmojiStatus\",\"params\":[\"${websocket.myDetails!.fields!.userId}\",\"raiseHand\"]}",
    ]);
  }

  @override
  lowerHand() {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"659\",\"method\":\"changeRaiseHand\",\"params\":[false]}",
    ]);
  }

  @override
  mutemyself() {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"1500\",\"method\":\"toggleVoice\",\"params\":[]}",
    ]);
  }

  @override
  allowPendingUsers(List<dynamic> participant, String policy) {
    // "{\"msg\":\"method\",\"id\":\"499\",\"method\":\"allowPendingUsers\",\"params\":[[{\"name\":\"ODEJINMI TOLULOPE\",\"intId\":\"w_usontnyslc26\",\"role\":\"VIEWER\",\"avatar\":\"https://konn3ct.com/assets/images/konn3ctIcon.png\",\"guest\":false,\"authenticated\":true,\"_id\":\"y7tgajM35toQgB74Q\"}],\"ALLOW\"]}"
    List<dynamic> participants = [];
    participant.forEach((element) {
      participants.add(
        "{\"name\":\"${element["fields"]["name"]}\",\"intId\":\"${element["fields"]["intId"]}\",\"role\":\"${element["fields"]["role"]}\",\"avatar\":\"${element["fields"]["avatar"]}\",\"guest\":${element["fields"]["guest"]},\"authenticated\":${element["fields"]["authenticated"]},\"_id\":\"${element["id"]}\"}",
      );
    });
    var result =
        "{\"msg\":\"method\",\"id\":\"499\",\"method\":\"allowPendingUsers\",\"params\":[$participants,\"$policy\"]}";
    print(result);
    //ALLOW, DENY
    websocket.websocketSub([result]);
  }

  @override
  changeGuestPolicy(String policy) {
    websocket.websocketSub([
      //ASK_MODERATOR, ALWAYS_ACCEPT
      "{\"msg\":\"method\",\"id\":\"540\",\"method\":\"changeGuestPolicy\",\"params\":[\"$policy\"]}",
    ]);
  }

  @override
  stopcamera() {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"100\",\"method\":\"userUnshareWebcam\",\"params\":[\"${videowebsocket.streamID(videowebsocket.edSet.deviceId)}\"]}",
    ]);
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
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"101\",\"method\":\"toggleLockSettings\",\"params\":[{\"disableCam\":${disableCam},\"disableMic\":${disableMic},\"disableNotes\":${disableNotes},\"disablePrivateChat\":${disablePrivateChat},\"disablePublicChat\":${disablePublicChat},\"hideUserList\":${hideUserList},\"hideViewersAnnotation\":${hideViewersAnnotation},\"hideViewersCursor\":${hideViewersCursor},\"lockOnJoin\":${lockOnJoin},\"lockOnJoinConfigurable\":${lockOnJoinConfigurable},\"setBy\":\"${websocket.myDetails!.fields!.userId}\"}]}",
    ]);
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
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"13\",\"method\":\"changeRole\",\"params\":[\"$userid\",\"${role.toUpperCase()}\"]}",
    ]);
  }

  @override
  assignpresenter({required String userid}) {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"27\",\"method\":\"assignPresenter\",\"params\":[\"$userid\"]}",
    ]);
  }

  @override
  removeuser({required String userid, required bool notallowagain}) {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"56\",\"method\":\"removeUser\",\"params\":[\"$userid\",$notallowagain}]}",
    ]);
  }

  @override
  List<ChatMessage> getchatMessages({required String chatid}) {
    return websocket.chatMessages.where((user) {
      return user.chatId == chatid;
    }).toList();
  }

  @override
  leaveroom() {
    if (GetPlatform.isIOS || GetPlatform.isAndroid) {
      CallNotificationService.dismissCallNotification();
    }
    _isCallActive = false;
    websocket.leaveRoom();
  }

  @override
  endroom() {
    if (GetPlatform.isIOS || GetPlatform.isAndroid) {
      CallNotificationService.dismissCallNotification();
    }
    _isCallActive = false;
    websocket.endRoom();
  }

  @override
  toggleRecording() {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"187\",\"method\":\"toggleRecording\",\"params\":[]}",
    ]);
  }

  @override
  stoptyping() {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"57\",\"method\":\"stopUserTyping\",\"params\":[]}",
    ]);
  }

  @override
  breakeoutroom() {
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"376\",\"method\":\"createBreakoutRoom\",\"params\":[[{\"users\":[],\"name\":\"tolu (Room 1)\",\"captureNotesFilename\":\"Room_0_Notes\",\"captureSlidesFilename\":\"Room_0_Whiteboard\",\"shortName\":\"Room 1\",\"isDefaultName\":true,\"freeJoin\":true,\"sequence\":1},{\"users\":[],\"name\":\"tolu (Room 2)\",\"captureNotesFilename\":\"Room_1_Notes\",\"captureSlidesFilename\":\"Room_1_Whiteboard\",\"shortName\":\"Room 2\",\"isDefaultName\":true,\"freeJoin\":true,\"sequence\":2}],15,true,false,false,false]}",
    ]);
  }

  @override
  get participant {
    return websocket.participant;
  }

  @override
  get mydetails {
    return websocket.myDetails;
  }

  @override
  get isWebsocketRunning {
    return websocket.isWebsocketRunning;
  }

  @override
  get polljson {
    return websocket.pollJson;
  }

  @override
  get reason {
    return websocket.reason;
  }

  @override
  get ispolling {
    return websocket.isPolling;
  }

  @override
  set ispolling(value) {
    return websocket.isPolling = value;
  }

  @override
  get isrecording {
    return websocket.isRecording;
  }

  @override
  get recordingtime {
    return websocket.recordingTime;
  }

  @override
  get pollanalyseparser {
    return websocket.pollAnalyseParser;
  }

  @override
  get talking {
    return websocket.talking;
  }

  @override
  get chatMessages {
    return websocket.chatMessages;
  }

  @override
  Stream<String> get stream {
    return websocket.controller.stream;
  }

  @override
  get isvideo {
    return videowebsocket.isvideo;
  }

  @override
  get presentationmodel {
    return websocket.presentationModel;
  }

  @override
  get ishowecinema {
    return websocket.isShowECinema;
  }
}
