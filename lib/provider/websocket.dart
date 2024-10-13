import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/chatmodel.dart';
import '../../utils/meetingdetails.dart';
import '../../utils/participant.dart';
import '../../utils/pollanalyseparser.dart';
import '../../utils/typingmodel.dart';
import 'jsondatas/websocketresponse.dart';


class Websocket extends GetxController{

   var _meetingdetails =  Rx<Meetingdetails?>(null);
   set meetingdetails(value) => _meetingdetails.value = value;
   get meetingdetails => _meetingdetails.value;

  var _isWebsocketRunning = false.obs; //status of a websocket
   set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
   get isWebsocketRunning => _isWebsocketRunning.value;

  WebSocketChannel? channel; //initialize a websocket channel
  var retryLimit = 3;
  var isLoading = false;

  final _participant = <Participant>[].obs;
  set participant(value)=> _participant.value = value;
  List<Participant> get participant => _participant.value;

  final _talking = <Participant>[].obs;
  set talking(value)=> _talking.value = value;
  List<Participant> get talking => _talking.value;

  final _mydetails = Rx<Participant?>(null);
  set mydetails(value)=> _mydetails.value = value;
   Participant? get mydetails => _mydetails.value;


  final _breakoutroom = [].obs;
  set breakoutroom(value)=> _breakoutroom.value = value;
  get breakoutroom => _breakoutroom.value;

  final _pollanalyseparser = Pollanalyseparser().obs;
  set pollanalyseparser(value)=> _pollanalyseparser.value = value;
  get pollanalyseparser => _pollanalyseparser.value;

  late Typing typing;

  final _istyping = false.obs;
  set istypingnow(value)=> _istyping.value = value;
  get istypingnow => _istyping.value;

  final _ispolling = false.obs;
  set ispolling(value)=> _ispolling.value = value;
  get ispolling => _ispolling.value;

  final _polljson = {}.obs;
  set polljson(value)=> _polljson.value = value;
  get polljson => _polljson.value;

  final _ishowecinema = false.obs;
  set ishowecinema(value)=> _ishowecinema.value = value;
  get ishowecinema => _ishowecinema.value;

  final _ischat = false.obs;
  set ischat(value)=> _ischat.value = value;
  get ischat => _ischat.value;

  final _isrecording = false.obs;
  set isrecording(value)=> _isrecording.value = value;
  get isrecording => _isrecording.value;

  final _webrtctoken = "".obs;
  set webrtctoken(value)=> _webrtctoken.value = value;
  get webrtctoken => _webrtctoken.value;

  final _mainwebsocketurl = "".obs;
  set mainwebsocketurl(value)=> _mainwebsocketurl.value = value;
  get mainwebsocketurl => _mainwebsocketurl.value;

   final _chatMessages = <ChatMessage>[].obs;
   set chatMessages(value)=> _chatMessages.value = value;
   List<ChatMessage> get chatMessages => _chatMessages.value;

   List<ChatMessage> getchatMessages(String chatid){
     return chatMessages.where((user) {
       return user.chatId == chatid;
     }).toList();
   }

   var _reason = "You left the session".obs;
   set reason(value)=>_reason.value = value;
   get reason => _reason.value;

   // Create a StreamController
   final  _controller = StreamController<String>().obs;
   set controller(value) => _controller.value = value;
   StreamController<String> get controller => _controller.value;

   // Expose the stream
   Stream<String> get stream => controller.stream;

   // Function to add data to the stream
   void addEvent(String event) {
     controller.sink.add(event);
   }

   // Close the stream controller
   void close() {
     controller.close();
   }


   Timer? _pingTimer;  // Timer to manage pings
   void startWebSocketPing() {
     // If the WebSocket is running, start pinging every 10 seconds
     _pingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
       if (channel != null && isWebsocketRunning) {
         sendPingMessage();
       } else {
         print("WebSocket is not connected, stopping ping.");
         stopWebSocketPing();  // Stop the ping if WebSocket is not connected
       }
     });
   }

   void stopWebSocketPing() {
     _pingTimer?.cancel();  // Cancel the timer
   }

   void sendPingMessage() {
     print("Sending ping message");
     var pingPayload = ["{\"msg\":\"pong\"}"];
     websocketsub(pingPayload);  // Send the ping over WebSocket
   }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

   @override
   void onClose() {
     stopWebSocketPing();  // Stop the ping timer when the WebSocket is closed
     super.onClose();
   }

  void initiate(
      {required String webrtctoken,
      required String mainwebsocketurl,
      required Meetingdetails meetingdetails}){
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
    this.mainwebsocketurl = mainwebsocketurl;
    startStream();
  }

  void startStream() {
    if (isWebsocketRunning) return; //chaech if its already running
    // final url = 'wss://$wsurl';
    channel = WebSocketChannel.connect(
      Uri.parse(mainwebsocketurl), //connect to a websocket
    );
    isWebsocketRunning = true;
    participant = <Participant>[];
    sub("sub");
    startWebSocketPing();  // Start pinging when the WebSocket is initialized
    channel!.stream.listen(
          (event) async {
            Websocketresponse().reseponse(event);
            update();
      },
      onDone: () {
        print("ondone");
        startStream();
        isWebsocketRunning = false;
      },
      onError: (err) {
        isWebsocketRunning = false;
        if (retryLimit > 0) {
          retryLimit--;
          // startStream();

        }
      },
    );
    update();
  }


   void websocketsub(json) {
     print("i got here");
     print(json.toString());
    channel!.sink.add(jsonEncode(json),);
  }

  void closeFoodStream() {
    //disposes of the stream
    channel!.sink.close();
    isWebsocketRunning = false;
  }

  leaveroom(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"380\",\"method\":\"userLeftMeeting\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"method\",\"id\":\"380\",\"method\":\"setExitReason\",\"params\":[\"logout\"]}"]);
    mainsub("unsub");
  }

  sub(String type){
    websocketsub(["{\"msg\":\"connect\",\"version\":\"1\",\"support\":[\"1\",\"pre2\",\"pre1\"]}"]);
    websocketsub(["{\"msg\":\"method\",\"id\":\"1\",\"method\":\"userChangedLocalSettings\",\"params\":[{\"application\":{\"animations\":true,\"chatAudioAlerts\":false,\"chatPushAlerts\":false,\"userJoinAudioAlerts\":false,\"userJoinPushAlerts\":false,\"userLeaveAudioAlerts\":false,\"userLeavePushAlerts\":false,\"raiseHandAudioAlerts\":true,\"raiseHandPushAlerts\":true,\"guestWaitingAudioAlerts\":true,\"guestWaitingPushAlerts\":true,\"paginationEnabled\":true,\"pushLayoutToEveryone\":false,\"fallbackLocale\":\"en\",\"overrideLocale\":null,\"locale\":\"en-US\"},\"audio\":{\"inputDeviceId\":\"undefined\",\"outputDeviceId\":\"undefined\"},\"dataSaving\":{\"viewParticipantsWebcams\":true,\"viewScreenshare\":true}}]}"]);
    websocketsub(["{\"msg\":\"method\",\"id\":\"2\",\"method\":\"validateAuthToken\",\"params\":[\"${meetingdetails.meetingId}\",\"${meetingdetails.internalUserId}\",\"${meetingdetails.authToken}\",\"${meetingdetails.externUserId}\"]}"]);
    mainsub(type);
  }

  mainsub(String type){
    websocketsub(["{\"msg\":\"$type\",\"id\":\"sCChYLTr2PwGBoCTz\",\"name\":\"meteor_autoupdate_clientVersions\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"Rxc87B5BHrDo4teDB\",\"name\":\"auth-token-validation\",\"params\":[{\"meetingId\":\"${meetingdetails.meetingId}\",\"userId\":\"${meetingdetails.internalUserId}\"}]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"GrzXtmmd2xZMqQHiq\",\"name\":\"current-user\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"dniJfvPpCcxQ2qm4f\",\"name\":\"users\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"KYE6a3qd4tNwNjoND\",\"name\":\"meetings\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"7zejoYww9GPhtLJxQ\",\"name\":\"polls\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"8F6XpqQBwDrAHBGtL\",\"name\":\"presentations\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"g2QE6xhHM6S8Xp7Q4\",\"name\":\"slides\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"N8sMPgHmLTXvYPxdb\",\"name\":\"slide-positions\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"WGaXxbjrefCNF8aoR\",\"name\":\"captions\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"efTZ2HZ34fyH7A4m2\",\"name\":\"voiceUsers\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"7F9qjiRxZuq8s2jww\",\"name\":\"whiteboard-multi-user\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"C92qF3DSQuJPQ3Khz\",\"name\":\"screenshare\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"ARXr9XG7ivFzNciZH\",\"name\":\"group-chat\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"MrdTEYjGj47B3hP7h\",\"name\":\"presentation-pods\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"ZGnLqQf6qf9fagxGt\",\"name\":\"users-settings\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"xh7BMxu2PzaYDZNA8\",\"name\":\"guestUser\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"GcsEudeq3REZ52nvR\",\"name\":\"users-infos\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"jXzXfsXwuT4vqnCMQ\",\"name\":\"note\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"upFmPa7LviR28pgKB\",\"name\":\"meeting-time-remaining\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"HXMqjHdZbXx58evdQ\",\"name\":\"local-settings\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"TNqZwbhwvGiv2Hxjx\",\"name\":\"users-typing\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"QmD2NHcomy27LHDyc\",\"name\":\"record-meetings\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"BMSzYbfFBisY85hRw\",\"name\":\"video-streams\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"pKjwX5n9ospfwXRro\",\"name\":\"connection-status\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"rxffSQazoac8tyjC9\",\"name\":\"voice-call-states\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"6qjAGwkRWDMtLBHFz\",\"name\":\"external-video-meetings\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"HKaQ8RWYqdbyaNNeN\",\"name\":\"meetings\",\"params\":[\"MODERATOR\"]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"7nZPTNKSNnsZQCAtR\",\"name\":\"users\",\"params\":[\"MODERATOR\"]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"Xzp9p44xtpwAoytmN\",\"name\":\"breakouts\",\"params\":[\"MODERATOR\"]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"SBKGrLuT7mnxvzn2J\",\"name\":\"guestUser\",\"params\":[\"MODERATOR\"]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"9JufFR8xgDgMeAQtL\",\"name\":\"annotations\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"wJGKEXoZ5NuDeNfp6\",\"name\":\"stream-cursor-8d507a70979aefb79db859b2d8cdea86c19ee151-1684392490996\",\"params\":[\"message\",{\"useCollection\":false,\"args\":[]}]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"d9gbwCg7yFx4NzbpY\",\"name\":\"stream-annotations-8d507a70979aefb79db859b2d8cdea86c19ee151-1684392490996\",\"params\":[\"removed\",{\"useCollection\":false,\"args\":[]}]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"h3WDbaWpAtgqSj5zB\",\"name\":\"stream-annotations-8d507a70979aefb79db859b2d8cdea86c19ee151-1684392490996\",\"params\":[\"added\",{\"useCollection\":false,\"args\":[]}]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"x4Snpk6xctKC23hPc\",\"name\":\"group-chat-msg\",\"params\":[[]]}"]);
    websocketsub(["{\"msg\":\"$type\",\"id\":\"azHBtJorAvXd6FiBq\",\"name\":\"users-persistent-data\",\"params\":[]}"]);
  }


  stoptyping(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"57\",\"method\":\"stopUserTyping\",\"params\":[]}"]);
  }

  raisehand(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"51\",\"method\":\"setEmojiStatus\",\"params\":[\"w_vb2mu96l9r0c\",\"raiseHand\"]}"]);
  }

  clearemojis(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"51\",\"method\":\"setEmojiStatus\",\"params\":[\"w_vb2mu96l9r0c\",\"none\"]}"]);
  }

  muteallexceptpresenter(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"27\",\"method\":\"muteAllExceptPresenter\",\"params\":[\"w_kvz0eh5afurv\"]}"]);
  }

   Map<String, dynamic> mergeData(Map<String, dynamic> incomingData, Map<String, dynamic> existingData) {
     incomingData.forEach((key, value) {
       if (value is Map<String, dynamic> && existingData[key] is Map<String, dynamic>) {
         // Recursively merge if the value is a nested map
         mergeData(value, existingData[key]);
       } else {
         // Otherwise, simply replace the value
         existingData[key] = value;
       }
     });
     return existingData;
   }

}