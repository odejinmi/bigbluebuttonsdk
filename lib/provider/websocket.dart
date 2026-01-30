import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:bigbluebuttonsdk/provider/jsondatas/WebSocketService.dart';
import 'package:bigbluebuttonsdk/utils/call_notification_service.dart';
import 'package:bigbluebuttonsdk/utils/meetingresponse.dart';
import 'package:bigbluebuttonsdk/utils/strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../bigbluebuttonsdk.dart';
import '../utils/diorequest.dart';
import '../utils/presentationmodel.dart';
import 'jsondatas/websocketresponse.dart';

class Websocket extends GetxController implements WebSocketService {
  // Private reactive variables with proper getters/setters
  final _meetingDetails = Rx<Meetingdetails?>(null);
  final _isWebsocketRunning = false.obs;
  final _participant = <Participant>[].obs;
  final _meetingResponse = Rx<MeetingResponse?>(null);
  final _waitingParticipant = <dynamic>[].obs;
  final _talking = <Participant>[].obs;
  final _myDetails = Rx<Participant?>(null);
  final _remoteRTCVideoRenderer = RTCVideoRenderer().obs;
  final _breakoutRoom = <dynamic>[].obs;
  final _pollAnalyseParser = Pollanalyseparser().obs;
  final _isTyping = false.obs;
  final _isMeSharing = false.obs;
  final _platformFile = PlatformFile(name: '', size: 0).obs;
  final _presentationModel = <Presentationmodel>[].obs;
  final _slidePosition = <dynamic>[].obs;
  final _slides = <dynamic>[].obs;
  final _timer = Rx<Timer?>(null);
  final _isPolling = false.obs;
  final _pollJson = <String, dynamic>{}.obs;
  final _isShowECinema = false.obs;
  final _isChat = false.obs;
  final _isRecording = false.obs;
  final _recordingTime = "0".obs;
  final _webrtcToken = "".obs;
  final _mainWebsocketUrl = "".obs;
  final _baseUrl = "".obs;
  final _mediaWebsocketUrl = "".obs;
  final _stunServer = <String, dynamic>{}.obs;
  final _chatMessages = <ChatMessage>[].obs;
  final _reason = "You left the session".obs;
  final _controller = StreamController<String>.broadcast().obs;
  final _isLeave = false.obs;
  final _userId = "".obs;

  // WebSocket related
  WebSocketChannel? channel;
  DateTime? _firstDisconnectionTime;

  bool isLoading = false;
  @override
  late Typing typing;

  // Getters and Setters
  @override
  Meetingdetails? get meetingDetails => _meetingDetails.value;
  @override
  set meetingDetails(Meetingdetails? value) => _meetingDetails.value = value;

  @override
  bool get isWebsocketRunning => _isWebsocketRunning.value;
  @override
  set isWebsocketRunning(bool value) => _isWebsocketRunning.value = value;

  @override
  List<Participant> get participant => _participant.value;
  @override
  set participant(List<Participant> value) => _participant.value = value;

  @override
  MeetingResponse? get meetingResponse => _meetingResponse.value;
  @override
  set meetingResponse(MeetingResponse? value) => _meetingResponse.value = value;

  @override
  List<dynamic> get waitingParticipant => _waitingParticipant.value;
  @override
  set waitingParticipant(List<dynamic> value) =>
      _waitingParticipant.value = value;

  @override
  List<Participant> get talking => _talking.value;
  @override
  set talking(List<Participant> value) => _talking.value = value;

  @override
  Participant? get myDetails => _myDetails.value;
  @override
  set myDetails(Participant? value) => _myDetails.value = value;

  @override
  RTCVideoRenderer get remoteRTCVideoRenderer => _remoteRTCVideoRenderer.value;
  @override
  set remoteRTCVideoRenderer(RTCVideoRenderer value) =>
      _remoteRTCVideoRenderer.value = value;

  @override
  List<dynamic> get breakoutRoom => _breakoutRoom.value;
  @override
  set breakoutRoom(List<dynamic> value) => _breakoutRoom.value = value;

  @override
  Pollanalyseparser get pollAnalyseParser => _pollAnalyseParser.value;
  @override
  set pollAnalyseParser(Pollanalyseparser value) =>
      _pollAnalyseParser.value = value;

  @override
  bool get isTypingNow => _isTyping.value;
  @override
  set isTypingNow(bool value) => _isTyping.value = value;

  @override
  bool get isMeSharing => _isMeSharing.value;
  @override
  set isMeSharing(bool value) => _isMeSharing.value = value;

  @override
  PlatformFile get platformFile => _platformFile.value;
  @override
  set platformFile(PlatformFile value) => _platformFile.value = value;

  @override
  List<Presentationmodel> get presentationModel => _presentationModel.value;
  @override
  set presentationModel(List<Presentationmodel> value) =>
      _presentationModel.value = value;

  @override
  List<dynamic> get slidePosition => _slidePosition.value;
  @override
  set slidePosition(List<dynamic> value) => _slidePosition.value = value;

  @override
  List<dynamic> get slides => _slides.value;
  @override
  set slides(List<dynamic> value) => _slides.value = value;

  @override
  Timer? get timer => _timer.value;
  @override
  set timer(Timer? value) => _timer.value = value;

  @override
  bool get isPolling => _isPolling.value;
  @override
  set isPolling(bool value) => _isPolling.value = value;

  @override
  Map<String, dynamic> get pollJson => _pollJson.value;
  @override
  set pollJson(Map<String, dynamic> value) => _pollJson.value = value;

  @override
  bool get isShowECinema => _isShowECinema.value;
  @override
  set isShowECinema(bool value) => _isShowECinema.value = value;

  @override
  bool get isChat => _isChat.value;
  @override
  set isChat(bool value) => _isChat.value = value;

  @override
  bool get isRecording => _isRecording.value;
  @override
  set isRecording(bool value) => _isRecording.value = value;

  @override
  String get recordingTime => _recordingTime.value;
  @override
  set recordingTime(String value) {
    var seconds = int.parse(value);
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final remainingSeconds = seconds % 60;
    _recordingTime.value =
        '${twoDigitString(hours)}:${twoDigitString(minutes)}:${twoDigitString(remainingSeconds)}';
  }

  @override
  String get webrtcToken => _webrtcToken.value;
  @override
  set webrtcToken(String value) => _webrtcToken.value = value;

  @override
  String get mainWebsocketUrl => _mainWebsocketUrl.value;
  @override
  set mainWebsocketUrl(String value) => _mainWebsocketUrl.value = value;

  @override
  String get baseUrl => _baseUrl.value;
  @override
  set baseUrl(String value) => _baseUrl.value = value;

  @override
  String get mediaWebsocketUrl => _mediaWebsocketUrl.value;
  @override
  set mediaWebsocketUrl(String value) => _mediaWebsocketUrl.value = value;

  @override
  Map<String, dynamic> get stunServer => _stunServer.value;
  @override
  set stunServer(Map<String, dynamic> value) => _stunServer.value = value;

  @override
  List<ChatMessage> get chatMessages => _chatMessages.value;
  @override
  set chatMessages(List<ChatMessage> value) => _chatMessages.value = value;

  @override
  String get reason => _reason.value;
  @override
  set reason(String value) => _reason.value = value;

  @override
  StreamController<String> get controller => _controller.value;
  @override
  set controller(StreamController<String> value) => _controller.value = value;

  @override
  bool get isLeave => _isLeave.value;
  @override
  set isLeave(bool value) => _isLeave.value = value;

  @override
  String get userId => _userId.value;
  @override
  set userId(String value) => _userId.value = value;

  // Computed properties
  @override
  dynamic get currentSlide {
    final result = slides.where((v) => v["fields"]["current"] == true).toList();
    return result.isNotEmpty ? result.last : null;
  }

  @override
  Stream<String> get stream => controller.stream;

  // Helper methods
  @override
  String twoDigitString(int value) => value.toString().padLeft(2, '0');

  @override
  List<ChatMessage> getChatMessages(String chatId) {
    return chatMessages.where((message) => message.chatId == chatId).toList();
  }

  late final WebSocketResponse _webSocketResponse;

  @override
  void onInit() {
    _webSocketResponse = WebSocketResponse(this);
    super.onInit();
  }

  // WebSocket management
  @override
  void initiate({
    required String webrtcToken,
    required String baseUrl,
    required String mainWebsocketUrl,
    required String mediaWebsocketUrl,
    required Meetingdetails meetingDetails,
  }) {
    this.webrtcToken = webrtcToken;
    this.baseUrl = baseUrl;
    this.meetingDetails = meetingDetails;
    this.mainWebsocketUrl = mainWebsocketUrl;
    this.mediaWebsocketUrl = mediaWebsocketUrl;
    startStream();
  }

  void startStream() {
    if (isWebsocketRunning) return;

    _initializeWebSocket();
    _enableWakelock();
    _resetParticipants();
    _subscribeToWebSocket();
    timer?.cancel();
    startWebSocketPing();
    _listenToWebSocket();
  }

  void _initializeWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse(mainWebsocketUrl));
  }

  void _enableWakelock() {
    WakelockPlus.enable();
  }

  void _resetParticipants() {
    participant = <Participant>[];
  }

  void _subscribeToWebSocket() {
    sub("sub");
  }

  void _listenToWebSocket() {
    channel!.stream.listen(
      _handleWebSocketMessage,
      onDone: _handleWebSocketDone,
      onError: _handleWebSocketError,
    );
    update();
  }

  void _handleWebSocketMessage(dynamic event) async {
    if (!isWebsocketRunning) {
      await _handleFirstConnection();
    }
    _processWebSocketEvent(event);
    update();
  }

  Future<void> _handleFirstConnection() async {
    isWebsocketRunning = true;
    _firstDisconnectionTime = null; // Reset timer on successful connection
    final stunServerData = await Diorequest().get(
      "https://$baseUrl/bigbluebutton/api/stuns?sessionToken=$webrtcToken",
    );
    if (stunServerData == null) return;
    stunServer = formatToIceServers(stunServerData);
    Get.find<Audiowebsocket>().initiate(
      webrtctoken: webrtcToken,
      mediawebsocketurl: mediaWebsocketUrl,
      meetingdetails: meetingDetails!,
    );
  }

  void _processWebSocketEvent(String event) {
    final firstSplit = event.toString().split("a[");
    if (firstSplit.length <= 1) return;

    final secondSplit = firstSplit[1].split("}\"]");
    final result = "${secondSplit[0]}}\"";

    try {
      final json = jsonDecode(jsonDecode(result));
      _handleWebSocketJson(json);
    } catch (e) {
      print("Error processing WebSocket event: $e");
    }
  }

  void _handleWebSocketJson(Map<String, dynamic> json) {
    if (json["msg"] == "changed" && json["collection"] == "current-user") {
      _handleCurrentUserChange(json);
    } else if (json["msg"] == "removed" &&
        json["collection"] == "current-user") {
      _handleCurrentUserRemoval(json);
    }
    _webSocketResponse.response(json);
  }

  void _handleCurrentUserChange(Map<String, dynamic> json) {
    userId = json["id"];
    if (json["fields"].containsKey("loggedOut") &&
        json["fields"]["loggedOut"] == true) {
      isLeave = true;
    }
  }

  void _handleCurrentUserRemoval(Map<String, dynamic> json) {
    userId = json["id"];
    isLeave = true;
  }

  void _handleWebSocketDone() {
    retryConnection();
  }

  void _handleWebSocketError(dynamic error) {
    retryConnection();
  }

  void retryConnection() {
    isWebsocketRunning = false;
    if (isLeave) {
      logoutJson();
      return;
    }

    _firstDisconnectionTime ??= DateTime.now();
    final timeSinceDisconnect = DateTime.now().difference(_firstDisconnectionTime!);

    if (timeSinceDisconnect.inMinutes < 10) {
      Future.delayed(const Duration(seconds: 5), () {
        if (!isLeave) {
          startStream();
        }
      });
    } else {
      logoutJson();
      _firstDisconnectionTime = null; // Reset for the next session
    }
  }

  // WebSocket ping management
  void startWebSocketPing() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (channel != null && isWebsocketRunning) {
        sendPingMessage();
      } else {
        stopWebSocketPing();
      }
    });
  }

  void stopWebSocketPing() {
    timer?.cancel();
  }

  int id = 0;
  @override
  Future<Map<String, dynamic>> callMethod(String method, List<dynamic> params) {
    final completer = Completer<Map<String, dynamic>>();
    id += 1;

    StreamSubscription<String>? subscription;

    subscription = stream.listen((message) {
      try {
        final json = jsonDecode(message);
        bool found = false;


        if (json['msg'] == 'result' && json['id'] == id.toString()) {
          if (!completer.isCompleted) {
            completer.complete(json);
          }
          found = true;
        } else if (json['msg'] == 'updated' &&
            json['methods'] != null &&
            (json['methods'] as List).contains(id.toString())) {
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

    Future.delayed(const Duration(seconds: 30), () {
      if (!completer.isCompleted) {
        completer.completeError(
            TimeoutException("WebSocket response timeout for method $method"));
        subscription?.cancel();
      }
    });

    final List<String> jsonToSend = [
      jsonEncode({
        "msg": "method",
        "id": id.toString(),
        "method": method,
        "params": params,
      })
    ];
    websocketSub(jsonToSend);

    return completer.future;
  }


  @override
  Future<void> setusermobile() async {
    var response = await callMethod("setMobileUser", []);
    print("setMobileUser response ${jsonEncode(response)}");
  }
  void sendPingMessage() {
    final pingPayload = [jsonEncode({"msg":"pong"})];
    websocketSub(pingPayload);
  }

  @override
  void stopWebsocket() {
    channel?.sink.close();
    // leavemeeting(true);
    stopWebSocketPing();
  }

  // WebSocket communication
  @override
  void websocketSub(List<String> json) {
    try {
      channel!.sink.add(jsonEncode(json));
    } catch (e) {
      logoutJson();
    }
  }

  // Utility methods
  void logoutJson() {
    if (!isLeave) {
      if (GetPlatform.isIOS || GetPlatform.isAndroid) {
        CallNotificationService.dismissCallNotification();
      }
      WakelockPlus.disable();
      stopall();
      var json = {
        "msg": "changed",
        "collection": "current-user",
        "id": userId,
        "fields": {"loggedOut": true}
      };
      isLeave = true;
      _webSocketResponse.response(json);
    }
  }

  @override
  var _externalvideomeetings;
  @override
  set externalvideomeetings (value) => _externalvideomeetings = value;
  @override
  get externalvideomeetings => _externalvideomeetings;

 @override
  var _leavemeeting;
 @override
  set leavemeeting (value) => _leavemeeting = value;
 @override
  get leavemeeting => _leavemeeting;

  @override
  var _polls;
  @override
  set polls (value) => _polls = value;
  @override
  get polls => _polls;

  @override
  var _currentpoll;
  @override
  set currentpoll (value) => _currentpoll = value;
  @override
  get currentpoll => _currentpoll;

 @override
  var _breakouts;
  @override
  set breakouts (value) => _breakouts = value;
  @override
  get breakouts => _breakouts;

  Map<String, dynamic> formatToIceServers(Map<String, dynamic> data) {
    return {
      "iceServers": (data["turnServers"] as List<dynamic>)
          .where((server) => !server["url"].toString().contains(":443"))
          .map((server) => {
                "urls": server["url"],
                "username": server["username"],
                "credential": server["password"]
              })
          .toList(),
    };
  }

  @override
  Map<String, dynamic> mergeData(
    Map<String, dynamic> incomingData,
    Map<String, dynamic> existingData,
  ) {
    incomingData.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          existingData[key] is Map<String, dynamic>) {
        existingData[key] = mergeData(value, existingData[key]);
      } else if (key != "id") {
        existingData[key] = value;
      }
    });
    return existingData;
  }

  // Stream management
  @override
  void addEvent(String event) {
    try {
      controller.sink.add(event);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void closeStream() {
    controller.close();
  }

  // Meeting actions
  @override
  void makePresentationDefault({required dynamic presentation}) {
    websocketSub([
      jsonEncode({"msg":"sub","id":"${generateRandomId(17)}","name":"presentation-upload-token","params":["DEFAULT_PRESENTATION_POD","undefined","${presentation["id"]}"]})
    ]);
    websocketSub([
      jsonEncode({"msg":"method","id":"962","method":"setUsedToken","params":["${presentation["fields"]["authzToken"]}"]})
    ]);
  }

  // Subscription methods
  void sub(String type) {
    websocketSub([
      jsonEncode( {"msg":"connect","version":"1","support":["1","pre2","pre1"]})
    ]);
    websocketSub([
     jsonEncode( {"msg":"method","id":"1","method":"userChangedLocalSettings","params":[{"application":{"animations":true,"chatAudioAlerts":false,"chatPushAlerts":false,"userJoinAudioAlerts":false,"userJoinPushAlerts":false,"userLeaveAudioAlerts":false,"userLeavePushAlerts":false,"raiseHandAudioAlerts":true,"raiseHandPushAlerts":true,"guestWaitingAudioAlerts":true,"guestWaitingPushAlerts":true,"paginationEnabled":true,"pushLayoutToEveryone":false,"fallbackLocale":"en","overrideLocale":null,"locale":"en-US"},"audio":{"inputDeviceId":"undefined","outputDeviceId":"undefined"},"dataSaving":{"viewParticipantsWebcams":true,"viewScreenshare":true}}]})
    ]);
    websocketSub([
     jsonEncode({"msg":"method","id":"2","method":"validateAuthToken","params":["${meetingDetails!.meetingId}","${meetingDetails!.internalUserId}","${meetingDetails!.authToken}","${meetingDetails!.externUserId}"]})
    ]);
    mainSub(type);
  }

  void mainSub(String type) {
    final subscriptions = [
      {"msg":"$type","id":"${generateRandomId(17)}","name":"meteor_autoupdate_clientVersions","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"auth-token-validation","params":[{"meetingId":"${meetingDetails!.meetingId}","userId":"${meetingDetails!.internalUserId}"}]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"current-user","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"users","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"meetings","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"polls","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"presentations","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"slides","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"slide-positions","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"captions","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"voiceUsers","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"voiceUsers","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"whiteboard-multi-user","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"screenshare","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"group-chat","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"presentation-pods","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"users-settings","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"guestUser","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"users-infos","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"note","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"meeting-time-remaining","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"local-settings","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"users-typing","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"record-meetings","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"video-streams","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"connection-status","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"voice-call-states","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"external-video-meetings","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"meetings","params":["MODERATOR"]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"users","params":["MODERATOR"]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"breakouts","params":["MODERATOR"]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"guestUser","params":["MODERATOR"]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"annotations","params":[]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"stream-cursor-8d507a70979aefb79db859b2d8cdea86c19ee151-1684392490996","params":["message",{"useCollection":false,"args":[]}]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"stream-annotations-8d507a70979aefb79db859b2d8cdea86c19ee151-1684392490996","params":["removed",{"useCollection":false,"args":[]}]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"stream-annotations-8d507a70979aefb79db859b2d8cdea86c19ee151-1684392490996","params":["added",{"useCollection":false,"args":[]}]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"group-chat-msg","params":[[]]},
      {"msg":"$type","id":"${generateRandomId(17)}","name":"users-persistent-data","params":[]},
    ];

    for (final subscription in subscriptions) {
      websocketSub([jsonEncode(subscription)]);
    }
  }

  @override
  void onClose() {
    stopall();
    closeStream();
    super.onClose();
  }

  void stopall() {
    stopWebSocketPing();
    timer?.cancel();
  }
}
