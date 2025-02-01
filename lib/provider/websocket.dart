import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../bigbluebuttonsdk.dart';
import '../utils/diorequest.dart';
import '../utils/presentationmodel.dart';
import 'jsondatas/websocketresponse.dart';


class Websocket extends GetxController{

   var _meetingdetails =  Rx<Meetingdetails?>(null);
   set meetingdetails(value) => _meetingdetails.value = value;
   get meetingdetails => _meetingdetails.value;

  var _isWebsocketRunning = false.obs; //status of a websocket
   set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
   get isWebsocketRunning => _isWebsocketRunning.value;


   // var audiowebsocket =Get.put(Audiowebsocket(), permanent: true);

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

   final _remoteRTCVideoRenderer = RTCVideoRenderer().obs;
   set remoteRTCVideoRenderer(value) => _remoteRTCVideoRenderer.value = value;
   RTCVideoRenderer get remoteRTCVideoRenderer => _remoteRTCVideoRenderer.value;

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

  final _platformFile = PlatformFile(name: '', size: 0).obs;
  set platformFile(value)=> _platformFile.value = value;
  get platformFile => _platformFile.value;

  final _presentationmodel = <Presentationmodel>[].obs;
  set presentationmodel(value)=> _presentationmodel.value = value;
  get presentationmodel => _presentationmodel.value;

  final _slideposition = [].obs;
  set slideposition(value)=> _slideposition.value = value;
  get slideposition => _slideposition.value;

  final _slides = [].obs;
  set slides(value)=> _slides.value = value;
  get slides => _slides.value;

   get currentslide {
     var result = slides.where((v) {
       return v["fields"]["current"] == true;
     }).toList();
     if(result.isNotEmpty){
       return result.last;
     }else{
       return null;
     }
   }

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

   final _baseurl = "".obs;
  set baseurl(value)=> _baseurl.value = value;
  get baseurl => _baseurl.value;

   final _mediawebsocketurl = "".obs;
   set mediawebsocketurl(value) => _mediawebsocketurl.value = value;
   get mediawebsocketurl => _mediawebsocketurl.value;

   // final _sturnserver = {
   //   "stunServers": [
   //
   //   ],
   //   "turnServers": [
   //     {
   //       "username": "1731758817:w_zxqy1uynnc4z",
   //       "password": "M9Sxt53uaUzE0GKTv2FAsP/pHgw=",
   //       "url": "turn:meet.konn3ct.ng:3478",
   //       "ttl": 86400
   //     },
   //     {
   //       "username": "1731758817:w_zxqy1uynnc4z",
   //       "password": "M9Sxt53uaUzE0GKTv2FAsP/pHgw=",
   //       "url": "turns:meet.konn3ct.ng:443?transport=tcp",
   //       "ttl": 86400
   //     }
   //   ],
   //   "remoteIceCandidates": [
   //
   //   ]
   // }.obs;
   final _sturnserver = <String, dynamic>{}.obs;
   set sturnserver(value) => _sturnserver.value = value;
   get sturnserver => _sturnserver.value;

   final _chatMessages = <ChatMessage>[].obs;
   set chatMessages(value)=> _chatMessages.value = value;
   List<ChatMessage> get chatMessages => _chatMessages.value;

   List<ChatMessage> getchatMessages(String chatid){
     return chatMessages.where((user) {
       return user.chatId == chatid;
     }).toList();
   }
   // for konnect doc
   // wss://meet1.konn3ct.com/pad/socket.io/?sessionToken=pzmd9ngiscb7jz7y&padId=g.1k96eXNh2r71eXGG$notes&EIO=3&transport=websocket&sid=tiGrtKFCmtp4L-9bAAAA
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
      {required String webrtctoken,required String baseurl,
      required String mainwebsocketurl,required String mediawebsocketurl,
      required Meetingdetails meetingdetails}){
    this.webrtctoken = webrtctoken;
    this.baseurl = baseurl;
    this.meetingdetails = meetingdetails;
    this.mainwebsocketurl = mainwebsocketurl;
    this.mediawebsocketurl = mediawebsocketurl;
    startStream();
  }

  void startStream() {
    if (isWebsocketRunning) return; //chaech if its already running
    // final url = 'wss://$wsurl';
    channel = WebSocketChannel.connect(
      Uri.parse(mainwebsocketurl), //connect to a websocket
    );
    participant = <Participant>[];
    sub("sub");
    startWebSocketPing();  // Start pinging when the WebSocket is initialized
    channel!.stream.listen(
          (event) async {
            if (!isWebsocketRunning) {
              isWebsocketRunning = true;
              var sturnserv = await Diorequest().get("https://${baseurl}/bigbluebutton/api/stuns?sessionToken=$webrtctoken");
              print("sturnserv");
              print(sturnserv);
              sturnserver = formatToIceServers(sturnserv);
              Get.find<Audiowebsocket>().initiate( webrtctoken: webrtctoken, mediawebsocketurl: mediawebsocketurl, meetingdetails: meetingdetails!);
            }
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

   Map<String, dynamic> replacePasswordWithCredential(Map<String, dynamic> data) {
     // Replace 'password' with 'credential' recursively in the map
     data = data.map((key, value) {
       if (value is Map<String, dynamic>) {
         return MapEntry(key, replacePasswordWithCredential(value));
       } else if (value is List) {
         return MapEntry(key, value.map((e) {
           return e is Map<String, dynamic> ? replacePasswordWithCredential(e) : e;
         }).toList());
       }
       return MapEntry(key == 'password' ? 'credential' : key, value);
     });
     return data;
   }

   Map<String, dynamic> formatToIceServers(Map<String, dynamic> data) {
     var maindata = data["turnServers"];
     var list = maindata.where((v) {
       return !v["url"].toString().contains(":443");
     }).toList();
     return {
       "iceServers": (data["turnServers"] as List<dynamic>).map((server) {
         return {
           "urls": server["url"],
           "username": server["username"],
           "credential": server["password"]
         };
       }).toList(),

       // "iceServers": [
       //   {
       //     'urls': 'stun:stun.l.google.com:19302',
       //   },
       //   {
       //     "urls": list[0]["url"],
       //     "username": list[0]["username"],
       //     "credential": list[0]["password"]
       //   }],
       // "iceTransportPolicy": "relay"
     };
   }

   void websocketsub(json) {
   
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

   endroom(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"653\",\"method\":\"endMeeting\",\"params\":[]}"]);
    websocketsub(["{\"msg\":\"method\",\"id\":\"654\",\"method\":\"setExitReason\",\"params\":[\"meetingEnded\"]}"]);
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

  raisehand(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"51\",\"method\":\"setEmojiStatus\",\"params\":[\"w_vb2mu96l9r0c\",\"raiseHand\"]}"]);
  }

  clearemojis(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"51\",\"method\":\"setEmojiStatus\",\"params\":[\"w_vb2mu96l9r0c\",\"none\"]}"]);
  }

  muteallexceptpresenter(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"27\",\"method\":\"muteAllExceptPresenter\",\"params\":[\"w_kvz0eh5afurv\"]}"]);
  }

  sendcursorposition(){
    websocketsub(['{"msg":"method","id":"22","method":"stream-cursor-d54ad009d179ae346683cfc3603979bc99339ef7-1730813701243","params":["publish",{"xPercent":1417.2460496613994,"yPercent":581.2821670428893,"whiteboardId":"e77ad8a2f55834ec9396f2c3410fed061ff4c3b2-1730813701246/1"}]}']);
  }

   sendBulkAnnotations(){
    websocketsub(["{\"msg\":\"method\",\"id\":\"107\",\"method\":\"sendBulkAnnotations\",\"params\":[[{\"id\":\"c53efdee-bf79-4bd3-31b4-07176e768b12\",\"annotationInfo\":{\"id\":\"c53efdee-bf79-4bd3-31b4-07176e768b12\",\"type\":\"draw\",\"name\":\"Draw\",\"parentId\":\"1\",\"childIndex\":0,\"point\":[204.79,454.54],\"rotation\":0,\"style\":{\"color\":\"black\",\"size\":\"small\",\"isFilled\":false,\"dash\":\"draw\",\"scale\":1,\"textAlign\":\"start\",\"font\":\"script\"},\"points\":[[0,0,0.5],[0,0,0.5],[0,3.25,0.5],[0,6.5,0.5],[3.25,6.5,0.5],[3.25,9.75,0.5],[3.25,16.25,0.5],[6.5,22.75,0.5],[13,35.76,0.5],[16.25,45.51,0.5],[19.5,55.26,0.5],[22.75,68.26,0.5],[29.26,81.26,0.5],[32.51,91.02,0.5],[52.01,133.27,0.5],[55.26,139.77,0.5],[65.01,156.03,0.5],[71.51,169.03,0.5],[81.26,182.03,0.5],[84.51,185.28,0.5],[91.02,191.78,0.5],[104.02,198.28,0.5],[107.27,201.53,0.5],[117.02,204.79,0.5],[117.02,208.04,0.5],[130.02,211.29,0.5],[149.53,214.54,0.5],[152.78,214.54,0.5],[162.53,214.54,0.5],[165.78,214.54,0.5],[175.53,214.54,0.5],[198.28,214.54,0.5],[208.04,214.54,0.5],[221.04,214.54,0.5],[230.79,214.54,0.5],[243.79,211.29,0.5],[256.79,211.29,0.5],[260.05,211.29,0.5],[289.3,204.79,0.5],[302.3,204.79,0.5],[315.3,204.79,0.5],[328.31,201.53,0.5],[334.81,201.53,0.5],[351.06,201.53,0.5],[354.31,198.28,0.5],[360.81,198.28,0.5],[364.06,195.03,0.5],[373.81,195.03,0.5],[383.57,195.03,0.5],[393.32,191.78,0.5],[412.82,185.28,0.5],[435.58,178.78,0.5],[451.83,172.28,0.5],[468.08,165.78,0.5],[484.33,159.28,0.5],[497.34,152.78,0.5],[516.84,146.28,0.5],[529.84,139.77,0.5],[546.09,130.02,0.5],[559.1,123.52,0.5],[572.1,117.02,0.5],[578.6,110.52,0.5],[591.6,104.02,0.5],[594.85,97.52,0.5],[601.35,94.27,0.5],[604.6,91.02,0.5],[607.86,91.02,0.5]],\"isComplete\":true,\"size\":[607.86,214.54],\"userId\":\"w_bajpiy8r8fvd\",\"isModerator\":true},\"wbId\":\"e77ad8a2f55834ec9396f2c3410fed061ff4c3b2-1730813701246/1\",\"userId\":\"w_bajpiy8r8fvd\"}]]}"]);
  }

   makepresentationdefault({required var presentation}){
     websocketsub(["{\"msg\":\"sub\",\"id\":\"VyaqqPosf1nkir9mV\",\"name\":\"presentation-upload-token\",\"params\":[\"DEFAULT_PRESENTATION_POD\",\"undefined\",\"${presentation["id"]}\"]}"]);
     websocketsub(["{\"msg\":\"method\",\"id\":\"962\",\"method\":\"setUsedToken\",\"params\":[\"${presentation["fields"]["authzToken"]}\"]}"]);
   }

   Map<String, dynamic> mergeData(Map<String, dynamic> incomingData, Map<String, dynamic> existingData) {
     incomingData.forEach((key, value) {
       if (value is Map<String, dynamic> && existingData[key] is Map<String, dynamic>) {
         // Recursively merge if both are maps
         existingData[key] = mergeData(value, existingData[key]);
       } else {
         // Add or replace the value
         existingData[key] = value;
       }
     });
     return existingData;
   }


}