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
import 'utils/meetingresponse.dart';

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
  final bool _sdkInitialized = false;

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
        'wss://${baseurl}bbb-webrtc-sfu?sessionToken=$webrtctoken';
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
      {ValueChanged? leavemeeting,
      ValueChanged? externalvideomeetings,
      ValueChanged? polls,
      ValueChanged? breakouts,
      ValueChanged? currentpoll}) {
    websocket = Get.put(Websocket());
    if (leavemeeting != null) websocket.leavemeeting = leavemeeting;
    if (externalvideomeetings != null) {
      websocket.externalvideomeetings = externalvideomeetings;
    }
    if (polls != null) websocket.polls = polls;
    if (currentpoll != null) websocket.currentpoll = currentpoll;
    if (breakouts != null) websocket.breakouts = breakouts;
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
   return websocket.callMethod("startUserTyping", [(chatid == 'MAIN-PUBLIC-GROUP-CHAT' ? 'public' : chatid)]);
  }

  @override
  Widget whiteboard() {
    return Whiteboard();
  }

  @override
  Future<Map<String, dynamic>> sendmessage({required String message, required String chatid}) {
   return websocket.callMethod("sendGroupChatMsg", [chatid,{"correlationId":"${websocket.meetingDetails!.internalUserId}-${DateTime.now()}","sender":{"id":websocket.meetingDetails!.internalUserId,"name":"","role":""},"chatEmphasizedText":true,"message":message}]);

  }

  @override
  Future<Map<String, dynamic>> sendecinema({required String videourl}) {
    websocket.isShowECinema = true;
   return websocket.callMethod("startWatchingExternalVideo", [videourl]);
  }

  @override
  Future<Map<String, dynamic>> endecinema() {
    websocket.isShowECinema = false;
   return websocket.callMethod("stopWatchingExternalVideo", []);
  }

  @override
  Future<Map<String, dynamic>> startpoll({required String question, required List options}) async {
    websocket.websocketSub([
      '{"msg":"sub","id":"2UY6dlRwTcfS48xlP","name":"current-poll","params":[false,true]}',
    ]);
    // Use a collection for to build the list of user IDs from the participants
    var result = websocket.callMethod("startPoll", [
      {"YesNo":"YN","YesNoAbstention":"YNA","TrueFalse":"TF","Letter":"A-","A2":"A-2","A3":"A-3","A4":"A-4","A5":"A-5","Custom":"CUSTOM","Response":"R-"},
      "CUSTOM",
      "${websocket.myDetails!.fields!.userId!}/1",
      false,
      question,
      false,
      options
    ]);
    var response = await result;
    websocket.polls({
      "msg": "added",
      "collection": "polls",
      "id": response["id"],
      "fields": {
        "meetingId": websocket.meetingDetails?.meetingId,
        "requester": websocket.myDetails?.fields?.userId,
        "users": [for (var p in websocket.participant) p.fields?.userId],
        "question": question,
        "pollType": "CUSTOM",
        "secretPoll": false,
        "id": "public/${DateTime.now().millisecondsSinceEpoch}",
        "isMultipleResponse": false,
        "answers": options.asMap().entries.map((e) => {"id": e.key, "key": e.value}).toList(),
      }
    });
    return result;
  }

  @override
  Future<Map<String, dynamic>> votepoll({required String poll_id, required String selectedOptionId}) {
    websocket.websocketSub([
      '{"msg":"sub","id":"qPaGbQlNXGIYJam7t","name":"polls","params":[false]}',
    ]);
    return websocket.callMethod("publishVote", [poll_id,[selectedOptionId]]);
  }

  @override
  Future<Map<String, dynamic>> muteallusers() {
    return websocket.callMethod("muteAllUsers", []);
  }

  @override
  Future<Map<String, dynamic>> muteauser({required String userid}) {
    return websocket.callMethod("toggleVoice", [userid]);
  }

  @override
  Future<Map<String, dynamic>> createGroupChat({required Participant participant}) {
    return websocket.callMethod("createGroupChat", [jsonEncode(participant.fields?.toJson())]);
  }

  @override
  uploadpresenter({required PlatformFile filename}) async {
    websocket.platformFile = filename;
    websocket.callMethod("requestPresentationUploadToken", ["DEFAULT_PRESENTATION_POD",(filename.name),"yMbQ5qmTpKOn834EuPwMtvKj"]);
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
    return websocket.callMethod("removePresentation", [presentationid,"DEFAULT_PRESENTATION_POD"]);
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
    for (var element in participant) {
      var fields = element["fields"];
      participants.add(
        {"approved":fields['approved'],"denied":fields['denied'],"intId":fields["intId"],"name":fields["name"],"role":fields["role"],"guest":fields["guest"],"avatar":fields["avatar"],"color":fields['color'],"authenticated":fields["authenticated"],"registeredOn":fields['registeredOn'],"meetingId": fields['meetingId'],"loginTime":fields['loginTime'],"privateGuestLobbyMessage":"","_id":element["id"]},
      );
    }
    // "{\"msg\":\"method\",\"id\":\"283\",\"method\":\"allowPendingUsers\",
    // \"params\":[[{\"approved\":false,\"denied\":false,\"intId\":\"w_zcldyznmvpnn\",\"name\":\"dadsfasfsf\",\"role\":\"VIEWER\",\"guest\":false,\"avatar\":\"https://ui-avatars.com/api/?name=dadsfasfsf&background=random&color=fff&size=200\",\"color\":\"#5e35b1\",\"authenticated\":true,\"registeredOn\":1770154837269,\"meetingId\":\"61836be70a218223ef793d14ac25f328a2c7a1a5-1770154707461\",\"loginTime\":1770154837269,\"privateGuestLobbyMessage\":\"\",\"_id\":\"sx4mZnWfDoxegWdAh\"}],\"ALLOW\"]}"
    // "{\"msg\":\"method\",\"id\":\"571\",\"method\":\"allowPendingUsers\",
    // \"params\":[[{\"approved\":false,\"denied\":false,\"intId\":\"w_7mstloqtjfpa\",\"name\":\"hbjbkjbzxjk\",\"role\":\"VIEWER\",\"guest\":false,\"avatar\":\"https://ui-avatars.com/api/?name=hbjbkjbzxjk&background=random&color=fff&size=200\",\"color\":\"#4a148c\",\"authenticated\":true,\"registeredOn\":1770188657557,\"meetingId\":\"61836be70a218223ef793d14ac25f328a2c7a1a5-1770188616209\",\"loginTime\":1770188657557,\"privateGuestLobbyMessage\":\"\",\"_id\":\"jt5es9ceTrdNpuqmD\"}],\"DENY\"]}"
    return websocket.callMethod("allowPendingUsers", [participants,policy]);
  }

  @override
  Future<Map<String, dynamic>> changeGuestPolicy(String policy) {
    // "{\"msg\":\"changed\",\"collection\":\"meetings\",\"id\":\"oNauXeTWaWvw5ADD2\",\"fields\":{\"usersProp\":{\"allowModsToEjectCameras\":false,\"allowModsToUnmuteUsers\":false,\"allowPromoteGuestToModerator\":false,\"authenticatedGuest\":true,\"guestPolicy\":\"ASK_MODERATOR\",\"maxUserConcurrentAccesses\":3,\"maxUsers\":250,\"meetingLayout\":\"CUSTOM_LAYOUT\",\"userCameraCap\":3,\"webcamsOnlyForModerator\":false}}}"
    // "{\"msg\":\"changed\",\"collection\":\"meetings\",\"id\":\"oNauXeTWaWvw5ADD2\",\"fields\":{\"usersProp\":{\"allowModsToEjectCameras\":false,\"allowModsToUnmuteUsers\":false,\"allowPromoteGuestToModerator\":false,\"authenticatedGuest\":true,\"guestPolicy\":\"ALWAYS_ACCEPT\",\"maxUserConcurrentAccesses\":3,\"maxUsers\":250,\"meetingLayout\":\"CUSTOM_LAYOUT\",\"userCameraCap\":3,\"webcamsOnlyForModerator\":false}}}"
    return websocket.callMethod("changeGuestPolicy", [policy]);
  }

  @override
  Future<Map<String, dynamic>> stopcamera() async {
    videowebsocket.stopCameraSharing();
    return websocket.callMethod("userUnshareWebcam", [videowebsocket.streamID(videowebsocket.edSet.deviceId)]);
  }

  @override
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


  drawing(){
    var testjson = ["{\"msg\":\"method\",\"id\":\"31.0\",\"method\":\"sendBulkAnnotations\",\"params\":[[{\"id\":\"GJrNhMOvq_uVn6cP6Ocsu\",\"annotationInfo\":{\"id\":\"GJrNhMOvq_uVn6cP6Ocsu\",\"type\":\"draw\",\"name\":\"Highlight\",\"parentId\":\"1\",\"childIndex\":0,\"point\":[110.2696875,101.28125],\"rotation\":0,\"style\":{\"color\":\"black\",\"size\":\"m\",\"isFilled\":false,\"dash\":\"draw\",\"scale\":1,\"textAlign\":\"start\",\"font\":\"script\"},\"points\":[[0.16,0,0.5],[0.16,0.11,0.5],[0.16,0.46,0.5],[0.16,0.99,0.5],[0.16,1.75,0.5],[0.16,2.9,0.5],[0,4.09,0.5],[0.010000000000000009,5.29,0.5],[0.52,6.65,0.5],[0.9600000000000001,7.73,0.5],[1.66,8.85,0.5],[2.6300000000000003,10.44,0.5],[3.5700000000000003,12.08,0.5],[4.69,13.81,0.5],[5.87,15.93,0.5],[7.3,18.21,0.5],[9.23,20.65,0.5],[10.91,22.61,0.5],[12.07,24.16,0.5],[13.38,25.85,0.5],[16.14,29,0.5],[18.13,30.99,0.5],[20.32,33.18,0.5],[22.22,34.91,0.5],[24.13,36.62,0.5],[25.56,37.86,0.5],[27.14,39.24,0.5],[28.88,40.6,0.5],[30.81,41.79,0.5],[32.54,43.13,0.5],[34.209999999999994,44.43,0.5],[36.059999999999995,45.35,0.5],[37.9,46.24,0.5],[39.72,47.25,0.5],[41.93,48.31,0.5],[44.459999999999994,49.35,0.5],[47.18,50.44,0.5],[49.519999999999996,51.46,0.5],[51.73,52.34,0.5],[54.919999999999995,53.52,0.5],[58.31999999999999,54.67,0.5],[60.68,55.34,0.5],[63.66,56.03,0.5],[67.34,56.73,0.5],[70.02,57.14,0.5],[75.09,58.32,0.5],[77.5,58.66,0.5],[80.52,59.09,0.5],[83.61999999999999,59.35,0.5],[90.42999999999999,59.45,0.5],[93.31,59.45,0.5],[97.25999999999999,59.45,0.5],[100.19,59.45,0.5],[103.47,59.45,0.5],[107.46,59.45,0.5],[110.75,59.24,0.5],[113.3,58.76,0.5],[115.96,58.21,0.5],[119.32,57.51,0.5],[122.96,56.82,0.5],[126.72999999999999,56.09,0.5],[130.26,55.39,0.5],[133.79999999999998,54.68,0.5],[137.63,53.95,0.5],[141.14,53.25,0.5],[143.73,52.61,0.5],[147.26,51.9,0.5],[152.41,51.11,0.5],[157.60999999999999,50.29,0.5],[159.60999999999999,49.96,0.5],[164.35,49.25,0.5],[166.28,49.25,0.5],[168.29,49.25,0.5],[170.24,49.25,0.5],[171.96,49.25,0.5],[173.64,49.25,0.5],[175.25,49.25,0.5],[176.60999999999999,49.25,0.5],[177.69,49.25,0.5],[178.78,49.25,0.5],[179.98,49.37,0.5],[181.02,49.64,0.5],[182.19,49.94,0.5],[183.35999999999999,50.27,0.5],[184.4,50.6,0.5],[185.45,51.08,0.5],[186.46,51.72,0.5],[187.45,52.38,0.5],[188.69,53.26,0.5],[189.94,54.32,0.5],[192.25,56.38,0.5],[195.48,59.87,0.5],[196.57,61.11,0.5],[200.12,65.45,0.5],[201.41,67.29,0.5],[203.29999999999998,69.82,0.5],[204.53,71.46,0.5],[205.74,73.07,0.5],[207.69,75.67,0.5],[209.60999999999999,78.25,0.5],[210.89,79.97,0.5],[212.07,82.14,0.5],[213.57999999999998,84.88,0.5],[215.1,87.68,0.5],[216.31,90.75,0.5],[217.26,93.38,0.5],[218.12,95.73,0.5]],\"isComplete\":true,\"size\":[218.12,95.73],\"userId\":\"w_obrre0jfrke4\",\"isModerator\":true,\"meta\":{\"pageId\":\"page:page\",\"pageIndex\":1,\"whiteboardId\":\"unknown-wb\",\"ownerUserId\":\"w_obrre0jfrke4\"},\"label\":\"\",\"labelPoint\":[0.5,0.5]},\"wbId\":\"unknown-wb\",\"userId\":\"w_obrre0jfrke4\"}]]}"];

    return websocket.callMethod("sendBulkAnnotations", [2,10,[],false,false,false,"room-",true,true,[]]);
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
    return websocket.callMethod("changeRole", [userid,role]);
  }

  @override
  Future<Map<String, dynamic>> assignpresenter({required String userid}) {
    return websocket.callMethod("assignPresenter", [userid]);
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
    return websocket.callMethod("removeUser", [userid]);
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

  @override
  // TODO: implement availableLanguages
  MeetingResponse? get meetingResponse => websocket.meetingResponse;

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
