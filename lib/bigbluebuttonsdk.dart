import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'bigbluebuttonsdk_platform_interface.dart';
import 'utils/chatmodel.dart';
import 'utils/meetingdetails.dart';
import 'utils/participant.dart';

export 'package:flutter_webrtc/flutter_webrtc.dart';

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
  Future<String?> getPlatformVersion() {
    return BigbluebuttonsdkPlatform.instance.getPlatformVersion();
  }

  startroom() {
    BigbluebuttonsdkPlatform.instance.Startroom();
  }

  initialize(
      {required String baseurl,
      required String webrtctoken,
      required Meetingdetails meetingdetails}) {
    BigbluebuttonsdkPlatform.instance.initialize(
        baseurl: baseurl,
        webrtctoken: webrtctoken,
        meetingdetails: meetingdetails);
  }

  typing({required String chatid}) {
    BigbluebuttonsdkPlatform.instance.typing(chatid: chatid);
  }

  sendmessage({required String message, required String chatid}) {
    BigbluebuttonsdkPlatform.instance
        .sendmessage(chatid: chatid, message: message);
  }

  sendecinema({required String videourl}) {
    BigbluebuttonsdkPlatform.instance.sendecinema(videourl: videourl);
  }

  Widget whiteboard() {
    return BigbluebuttonsdkPlatform.instance.whiteboard();
  }

  endecinema() {
    BigbluebuttonsdkPlatform.instance.endecinema();
  }

  startpoll({required String question, required List options}) {
    BigbluebuttonsdkPlatform.instance
        .startpoll(question: question, options: options);
  }

  votepoll({required String poll_id, required String selectedOptionId}) {
    BigbluebuttonsdkPlatform.instance
        .votepoll(poll_id: poll_id, selectedOptionId: selectedOptionId);
  }

  muteallusers({
    required String userid,
  }) {
    BigbluebuttonsdkPlatform.instance.muteallusers(userid: userid);
  }

  createGroupChat({
    required Participant participant,
  }) {
    BigbluebuttonsdkPlatform.instance.createGroupChat(participant: participant);
  }

  uploadpresenter({
    required PlatformFile filename,
  }) {
    BigbluebuttonsdkPlatform.instance.uploadpresenter(filename: filename);
  }

  raiseHand() {
    BigbluebuttonsdkPlatform.instance.raiseHand();
  }

  lowerHand() {
    BigbluebuttonsdkPlatform.instance.lowerHand();
  }

  switchVideoQuality(
      {required int width, /*int height,*/ required int frameRate}) {
    BigbluebuttonsdkPlatform.instance
        .switchVideoQuality(width: width, frameRate: frameRate);
  }

  switchVideocamera({required String deviceid}) {
    BigbluebuttonsdkPlatform.instance.switchcamera(deviceid: deviceid);
  }

  switchmicrophone({required String deviceid}) {
    BigbluebuttonsdkPlatform.instance.switchmicrophone(deviceid: deviceid);
  }

  removepresentation({required String presentationid}) {
    BigbluebuttonsdkPlatform.instance
        .removepresentation(presentationid: presentationid);
  }

  nextpresentation({required String page}) {
    BigbluebuttonsdkPlatform.instance.nextpresentation(page: page);
  }

  makepresentationdefault({required var presentation}) {
    BigbluebuttonsdkPlatform.instance
        .makepresentationdefault(presentation: presentation);
  }

  mutemyself() {
    BigbluebuttonsdkPlatform.instance.mutemyself();
  }

  stopcamera() {
    BigbluebuttonsdkPlatform.instance.stopcamera();
  }

  startcamera() {
    BigbluebuttonsdkPlatform.instance.startcamera();
  }

  stopscreenshare() {
    BigbluebuttonsdkPlatform.instance.stopscreenshare();
  }

  startscreenshare(bool audio) {
    BigbluebuttonsdkPlatform.instance.startscreenshare(audio);
  }

  changerole({required String userid, required String role}) {
    BigbluebuttonsdkPlatform.instance.changerole(userid: userid, role: role);
  }

  assignpresenter({required String userid}) {
    BigbluebuttonsdkPlatform.instance.assignpresenter(userid: userid);
  }

  removeuser({required String userid, required bool notallowagain}) {
    BigbluebuttonsdkPlatform.instance
        .removeuser(userid: userid, notallowagain: notallowagain);
  }

  leaveroom() {
    BigbluebuttonsdkPlatform.instance.leaveroom();
  }

  toggleRecording() {
    BigbluebuttonsdkPlatform.instance.toggleRecording();
  }

  breakeoutroom() {
    BigbluebuttonsdkPlatform.instance.breakeoutroom();
  }

  stoptyping() {
    BigbluebuttonsdkPlatform.instance.stoptyping();
  }

  endroom() {
    BigbluebuttonsdkPlatform.instance.endroom();
  }

  stopcaption() {
    BigbluebuttonsdkPlatform.instance.stopcaption();
  }

  startcaption() {
    BigbluebuttonsdkPlatform.instance.startcaption();
  }

  starvirtual({required Uint8List backgroundimage}) {
    BigbluebuttonsdkPlatform.instance
        .starvirtual(backgroundimage: backgroundimage);
  }

  List<ChatMessage> getchatMessages({
    required String chatid,
  }) {
    return BigbluebuttonsdkPlatform.instance.getchatMessages(chatid: chatid);
  }

  get participant {
    return BigbluebuttonsdkPlatform.instance.participant;
  }

  get mydetails {
    return BigbluebuttonsdkPlatform.instance.mydetails;
  }

  get isWebsocketRunning {
    return BigbluebuttonsdkPlatform.instance.isWebsocketRunning;
  }

  get polljson {
    return BigbluebuttonsdkPlatform.instance.polljson;
  }

  get ispolling {
    return BigbluebuttonsdkPlatform.instance.ispolling;
  }

  set ispolling(value) {
    return BigbluebuttonsdkPlatform.instance.ispolling = value;
  }

  get isrecording {
    return BigbluebuttonsdkPlatform.instance.isrecording;
  }

  get recordingtime {
    return BigbluebuttonsdkPlatform.instance.recordingtime;
  }

  get pollanalyseparser {
    return BigbluebuttonsdkPlatform.instance.pollanalyseparser;
  }

  get talking {
    return BigbluebuttonsdkPlatform.instance.talking;
  }

  get isvideo {
    return BigbluebuttonsdkPlatform.instance.isvideo;
  }

  get chatMessages {
    return BigbluebuttonsdkPlatform.instance.chatMessages;
  }

  get reason {
    return BigbluebuttonsdkPlatform.instance.reason;
  }

  get ishowecinema {
    return BigbluebuttonsdkPlatform.instance.ishowecinema;
  }

  get presentationmodel {
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
}
