// websocket_service.dart
import 'dart:async';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/utils/meetingresponse.dart';
import 'package:bigbluebuttonsdk/utils/presentationmodel.dart';
import 'package:file_picker/file_picker.dart';

abstract class WebSocketService {
  // Properties

  bool get isWebsocketRunning;
  set isWebsocketRunning(bool value);
  Meetingdetails? get meetingDetails;
  set meetingDetails(Meetingdetails? value);
  String get webrtcToken;
  set webrtcToken(String value);
  String get baseUrl;
  set baseUrl(String value);
  String get mediaWebsocketUrl;
  set mediaWebsocketUrl(String value);
  String get mainWebsocketUrl;
  set mainWebsocketUrl(String value);
  List<Participant> get participant;
  set participant(List<Participant> value);
  List<dynamic> get waitingParticipant;
  set waitingParticipant(List<dynamic> value);
  PlatformFile get platformFile;
  set platformFile(PlatformFile value);
  List<Presentationmodel> get presentationModel;
  set presentationModel(List<Presentationmodel> value);
  List<dynamic> get slidePosition;
  set slidePosition(List<dynamic> value);
  List<dynamic> get slides;
  set slides(List<dynamic> value);
  Timer? get timer;
  set timer(Timer? value);
  bool get isPolling;
  set isPolling(bool value);
  Map<String, dynamic> get pollJson;
  set pollJson(Map<String, dynamic> value);
  Pollanalyseparser get pollAnalyseParser;
  set pollAnalyseParser(Pollanalyseparser value);
  bool get isShowECinema;
  set isShowECinema(bool value);
  bool get isRecording;
  set isRecording(bool value);
  String get recordingTime;
  set recordingTime(String value);
  List<dynamic> get breakoutRoom;
  set breakoutRoom(List<dynamic> value);
  MeetingResponse? get meetingResponse;
  set meetingResponse(MeetingResponse? value);

  List<Participant> get talking;
  set talking(List<Participant> value);

  Participant? get myDetails;
  set myDetails(Participant? value);

  RTCVideoRenderer get remoteRTCVideoRenderer;
  set remoteRTCVideoRenderer(RTCVideoRenderer value);

  bool get isTypingNow;
  set isTypingNow(bool value);

  bool get isMeSharing;
  set isMeSharing(bool value);

  bool get isChat;
  set isChat(bool value);

  Map<String, dynamic> get stunServer;
  set stunServer(Map<String, dynamic> value);

  List<ChatMessage> get chatMessages;
  set chatMessages(List<ChatMessage> value);

  String get reason;
  set reason(String value);

  StreamController<String> get controller;
  set controller(StreamController<String> value);

  bool get isLeave;
  set isLeave(bool value);

  String get userId;
  set userId(String value);

  dynamic get currentSlide;
  // set currentSlide(dynamic value);

  Stream<String> get stream;
  // set stream(Stream<String> value);

  late Typing typing;

  String twoDigitString(int value);
  List<ChatMessage> getChatMessages(String chatId);

  void initiate({
    required String webrtcToken,
    required String baseUrl,
    required String mainWebsocketUrl,
    required String mediaWebsocketUrl,
    required Meetingdetails meetingDetails,
  });

  void websocketSub(List<String> json);
  // Methods
  void addEvent(String event);
  Map<String, dynamic> mergeData(
      Map<String, dynamic> incomingData, Map<String, dynamic> existingData);
  void makePresentationDefault({required dynamic presentation});

  void leaveRoom();

  void endRoom();
  void raiseHand();
  void clearEmojis();
  void muteAllExceptPresenter();
  void stopWebsocket();
}
