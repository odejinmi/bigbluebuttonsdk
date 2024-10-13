import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'bigbluebuttonsdk_platform_interface.dart';
import 'exceptions.dart';
import 'provider/audiowebsocket.dart';
import 'provider/remotescreenshare.dart';
import 'provider/remotevideowebsocket.dart';
import 'provider/screensharewebsocket.dart';
import 'provider/videowebsocket.dart';
import 'provider/websocket.dart';
import 'utils/chatmodel.dart';
import 'utils/meetingdetails.dart';
import 'utils/participant.dart';
import 'utils/strings.dart';

/// An implementation of [BigbluebuttonsdkPlatform] that uses method channels.
class MethodChannelBigbluebuttonsdk extends BigbluebuttonsdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bigbluebuttonsdk');


  String mediawebsocketurl = '';
  String mainwebsocketurl = '';
  String webrtctoken = '';
  Meetingdetails? meetingdetails;
  bool _sdkInitialized = false;

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  initialize(
      {required String mediawebsocketur, required String mainwebsocketur,required String webrtctoken, required Meetingdetails meetingdetails}){
    assert(() {
      if (mediawebsocketur.isEmpty) {
        throw DuploException('publicKey cannot be null or empty');
      // } else if (!publicKey.startsWith("pk_")) {
      //   throw DuploException(Utils.getKeyErrorMsg('public'));
      } else if (mainwebsocketur.isEmpty) {
        throw DuploException('secretKey cannot be null or empty');
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

    mediawebsocketurl = mediawebsocketur;
    mainwebsocketurl = mainwebsocketur;
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;

  }

  bool get sdkInitialized => _sdkInitialized;

  var websocket =Get.put(Websocket(), permanent: true);
  var videowebsocket =Get.put(Videowebsocket(), permanent: true);
  var screensharewebsocket =Get.put(Screensharewebsocket(), permanent: true);
  var remotevideowebsocket =Get.put(RemoteVideoWebSocket(), permanent: true);
  var remotescreensharewebsocket =Get.put(RemoteScreenShareWebSocket(), permanent: true);

  @override
  Startroom(){
    var sola2 =Get.put(Audiowebsocket(), permanent: true);
    websocket.initiate( webrtctoken: webrtctoken, mainwebsocketurl: mainwebsocketurl, meetingdetails: meetingdetails!);
    sola2.initiate( webrtctoken: webrtctoken, mediawebsocketurl: mediawebsocketurl, meetingdetails: meetingdetails!);
    if(GetPlatform.isAndroid || GetPlatform.isIOS) {
      startForegroundService();
    }
  }

  @override
  typing({required String chatid,}){
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"120\",\"method\":\"startUserTyping\",\"params\":[\"${chatid== 'MAIN-PUBLIC-GROUP-CHAT'?'public':chatid}\"]}"]);
  }

  @override
  sendmessage({required String message,required String chatid}){
    websocket.websocketsub([
      "{\"msg\":\"method\",\"id\":\"14\",\"method\":\"sendGroupChatMsg\",\"params\":[\"$chatid\",{\"correlationId\":\"${websocket
          .meetingdetails
          .internalUserId}-${DateTime
          .now()}\",\"sender\":{\"id\":\"${websocket
          .meetingdetails
          .internalUserId}\",\"name\":\"\",\"role\":\"\"},\"chatEmphasizedText\":true,\"message\":\"${message}\"}]}"
    ]);
  }

  @override
  sendecinema({required String videourl}){
    websocket.ishowecinema = true;
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"317\",\"method\":\"startWatchingExternalVideo\",\"params\":[\"$videourl\"]}"]);

  }

  @override
  endecinema(){
    websocket.ishowecinema = false;
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"940\",\"method\":\"stopWatchingExternalVideo\",\"params\":[]}"]);

  }

  @override
  startpoll({required String question, required List options}) {
    websocket.websocketsub(
        [
          "{\"msg\":\"sub\",\"id\":\"2UY6dlRwTcfS48xlP\",\"name\":\"current-poll\",\"params\":[false,true]}"
        ]);
    websocket.websocketsub(
        [
          "{\"msg\":\"method\",\"id\":\"52\",\"method\":\"startPoll\",\"params\":[{\"YesNo\":\"YN\",\"YesNoAbstention\":\"YNA\",\"TrueFalse\":\"TF\",\"Letter\":\"A-\",\"A2\":\"A-2\",\"A3\":\"A-3\",\"A4\":\"A-4\",\"A5\":\"A-5\",\"Custom\":\"CUSTOM\",\"Response\":\"R-\"},\"CUSTOM\",\"${websocket
              .mydetails!.fields!.userId!}/1\",false,\"${question}\",false,${jsonEncode(options)}]}"
        ]);

  }



  @override
  votepoll({required String poll_id, required String selectedOptionId}) {
    websocket.websocketsub(["{\"msg\":\"sub\",\"id\":\"qPaGbQlNXGIYJam7t\",\"name\":\"polls\",\"params\":[false]}"]);
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"136\",\"method\":\"publishVote\",\"params\":[\"$poll_id\",[$selectedOptionId]]}"]);


  }

  @override
  muteallusers({required String userid,}){
    websocket.websocketsub([
      "{\"msg\":\"method\",\"id\":\"11\",\"method\":\"muteAllUsers\",\"params\":[\"${userid}\"]}"
    ]);
  }

  @override
  createGroupChat({required Participant participant,}){
    websocket.websocketsub([
      "{\"msg\":\"method\",\"id\":\"900\",\"method\":\"createGroupChat\",\"params\":[${jsonEncode(participant.toJson())}]}"
    ]);
  }

  @override
  uploadpresenter({required String filename,}){
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"867\",\"method\":\"requestPresentationUploadToken\",\"params\":[\"DEFAULT_PRESENTATION_POD\",\"$filename\",\"yMbQ5qmTpKOn834EuPwMtvKj\"]}"]);
    websocket.websocketsub(["{\"msg\":\"sub\",\"id\":\"PyItdbzmJUeOFfJyn\",\"name\":\"presentation-upload-token\",\"params\":[\"DEFAULT_PRESENTATION_POD\",\"$filename\",\"yMbQ5qmTpKOn834EuPwMtvKj\"]}"]);
  }

  @override
  setemojistatus(){
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"643\",\"method\":\"setEmojiStatus\",\"params\":[\"${websocket.mydetails!.fields!.userId}\",\"raiseHand\"]}"]);
  }

  @override
  mutemyself(){
    websocket.websocketsub([
      "{\"msg\":\"method\",\"id\":\"1500\",\"method\":\"toggleVoice\",\"params\":[]}"
    ]);
  }

  @override
  stopcamera(){
    websocket.websocketsub([
      "{\"msg\":\"method\",\"id\":\"100\",\"method\":\"userUnshareWebcam\",\"params\":[\"${videowebsocket.streamID(videowebsocket.edSet.deviceId)}\"]}"
    ]);
    videowebsocket.stopCameraSharing();
  }


  @override
  startcamera(){
    videowebsocket.initiate(webrtctoken: webrtctoken, mediawebsocketurl: mediawebsocketurl, meetingdetails: meetingdetails!,);
  }

  @override
  stopscreenshare(){
    screensharewebsocket.stopCameraSharing();
  }


  @override
  startscreenshare(){
    screensharewebsocket.initiate( webrtctoken: webrtctoken, mediawebsocketurl: mediawebsocketurl, meetingDetails: meetingdetails!,);
  }

  @override
  changerole({required String userid, required String role}){
    websocket.websocketsub([
      "{\"msg\":\"method\",\"id\":\"13\",\"method\":\"changeRole\",\"params\":[\"$userid\",\"${role.toUpperCase()}\"]}"
    ]);
  }

  @override
  assignpresenter({required String userid}){
    websocket.websocketsub([
      "{\"msg\":\"method\",\"id\":\"27\",\"method\":\"assignPresenter\",\"params\":[\"$userid\"]}"
    ]);
  }

  @override
  removeuser({required String userid,required bool notallowagain}){
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"56\",\"method\":\"removeUser\",\"params\":[\"$userid\",$notallowagain}]}"]);
  }

  @override
  List<ChatMessage> getchatMessages({required String chatid,}){
    return websocket.chatMessages.where((user) {
      return user.chatId == chatid;
    }).toList();
  }

  @override
  leaveroom(){
    websocket.leaveroom();
  }

  @override
  toggleRecording(){
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"187\",\"method\":\"toggleRecording\",\"params\":[]}"]);
  }



  @override
  breakeoutroom(){
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"376\",\"method\":\"createBreakoutRoom\",\"params\":[[{\"users\":[],\"name\":\"tolu (Room 1)\",\"captureNotesFilename\":\"Room_0_Notes\",\"captureSlidesFilename\":\"Room_0_Whiteboard\",\"shortName\":\"Room 1\",\"isDefaultName\":true,\"freeJoin\":true,\"sequence\":1},{\"users\":[],\"name\":\"tolu (Room 2)\",\"captureNotesFilename\":\"Room_1_Notes\",\"captureSlidesFilename\":\"Room_1_Whiteboard\",\"shortName\":\"Room 2\",\"isDefaultName\":true,\"freeJoin\":true,\"sequence\":2}],15,true,false,false,false]}"]);
  }

  @override
  get participant {
    return websocket.participant;
  }

  @override
  get mydetails {
    return websocket.mydetails;
  }

  @override
  get isWebsocketRunning {

    return websocket.isWebsocketRunning;
  }
  @override
  get polljson {
    return websocket.polljson;
  }
  @override
  get ispolling {
    return websocket.ispolling;
  }

  @override
  set ispolling (value) {
    return websocket.ispolling = value;
  }

  @override
  get isrecording {
    return websocket.isrecording;
  }

  @override
  get pollanalyseparser {
    return websocket.pollanalyseparser;
  }

  @override
  get isscreensharing {
    return screensharewebsocket.isVideo;
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
  get ishowecinema {
    return websocket.ishowecinema;
  }

}
