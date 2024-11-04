import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/meetingdetails.dart';
import '../bigbluebuttonsdk.dart';
import 'websocket.dart';

class RemoteScreenShareWebSocket extends GetxController {

  var _isWebsocketRunning = false.obs;
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  WebSocketChannel? channel;
  var retryLimit = 3;
  var websocket = Get.find<Websocket>();
  RTCPeerConnection? peerConnection;
  List<MediaDeviceInfo>? _mediaDevicesList;
  MediaStream? _localStream;
  List<RTCIceCandidate> rtcIceCadidates = [];
  Timer? _pingTimer;

  // Video renderers
  final _localRTCVideoRenderer = RTCVideoRenderer().obs;
  set localRTCVideoRenderer(value) => _localRTCVideoRenderer.value = value;
  get localRTCVideoRenderer => _localRTCVideoRenderer.value;

  final _remoteRTCVideoRenderer = RTCVideoRenderer().obs;
  set remoteRTCVideoRenderer(value) => _remoteRTCVideoRenderer.value = value;
  get remoteRTCVideoRenderer => _remoteRTCVideoRenderer.value;

  final _webrtctoken = "".obs;
  set webrtctoken(value) => _webrtctoken.value = value;
  get webrtctoken => _webrtctoken.value;

  final _mediawebsocketurl = "".obs;
  set mediawebsocketurl(value) => _mediawebsocketurl.value = value;
  get mediawebsocketurl => _mediawebsocketurl.value;

  var _meetingdetails = Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  get meetingdetails => _meetingdetails.value;

  @override
  void onInit() {
    super.onInit();
    localRTCVideoRenderer.initialize();
    remoteRTCVideoRenderer.initialize();

    mediaDevices.ondevicechange = (event) async {
      _mediaDevicesList = await mediaDevices.enumerateDevices();
    };
  }

  @override
  void onClose() {
    stopWebSocketPing();
    super.onClose();
  }

  void startWebSocketPing() {
    _pingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (channel != null && isWebsocketRunning) {
        sendPingMessage();
      } else {
        stopWebSocketPing();
      }
    });
  }

  void stopWebSocketPing() {
    _pingTimer?.cancel();
  }

  void sendPingMessage() {
    var pingPayload = {"id": "ping"};
    websocketsub(pingPayload);
  }

  void initiate(
      {required String webrtctoken,
      required String mediawebsocketurl,
      required Meetingdetails meetingdetails}) {
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
    this.mediawebsocketurl = mediawebsocketurl;
    initViewerStream();
  }


  void receiveViewerSDPAnswer(String answer) async {
    final config = {
      // 'iceServers': [
      //   {'urls': ['stun:stun1.l.google.com:19302', 'stun:stun2.l.google.com:19302']}
      // ],
      "stunServers": [

      ],
      "turnServers": [
        {
          "username": "1729579216:w_u0dqszvdf5p1",
          "password": "cD/KKOjw+rHGgn+iAYaJijcpuPM=",
          "url": "turns:meet1.konn3ct.com:443?transport=tcp",
          "ttl": 86400
        },
        {
          "username": "1729579216:w_u0dqszvdf5p1",
          "password": "cD/KKOjw+rHGgn+iAYaJijcpuPM=",
          "url": "turn:meet1.konn3ct.com:3478",
          "ttl": 86400
        }
      ],
      "remoteIceCandidates": [

      ]
    };

    final constraints = {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': true,
    };

    peerConnection = await createPeerConnection(config);

    // Get local media stream
    _localStream = await mediaDevices.getUserMedia({
      'audio': false,
      'video': {
        'width': 640,
        'frameRate': 15,  // Corrected 'framerate' to 'frameRate'
      },
    });

    // Add local tracks to the peer connection
    _localStream!.getTracks().forEach((track) {
      peerConnection?.addTrack(track, _localStream!);
    });

    // // Render remote video
    // var list = websocket.participant.where((v) {
    //   return v.userId == websocket.mydetails.userId;
    // }).toList();
    // if (list.isNotEmpty) {
    //   list[0].mediaStream = _localStream;
    //   // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
    // }


    // Set the remote description (answer)
    await peerConnection!.setRemoteDescription(RTCSessionDescription(answer, 'offer'));

    // Create and set the local SDP answer
    var newAnswer = await peerConnection!.createAnswer(constraints);
    await peerConnection!.setLocalDescription(newAnswer);

    websocketsub({
          "id":"subscriberAnswer",
          "type":"screenshare",
        "role":"recv",
        "voiceBridge":meetingdetails.voicebridge,
        "callerName":meetingdetails.internalUserId,
        "answer":newAnswer.sdp!
    });

    peerConnection!.onIceCandidate = (candidate) {
      // {"type":"video","role":"share","id":"onIceCandidate","candidate":{"candidate":"candidate:2 2 TCP 2105524478 192.168.127.27 9 typ host tcptype active","sdpMLineIndex":0,"sdpMid":"0","usernameFragment":"2124c5f8"},"cameraId":"w_8mbuxp9jzxuidf4mngvcgm0x1"}
      websocketsub({
        "id": "onIceCandidate",
        "type": "video",
        "role": "share",
        "candidate": candidate.toMap()
      });
    };

    // Handle the reception of remote media streams
    peerConnection!.onTrack = (RTCTrackEvent event) {
      print("stream received");
      if (event.streams.isNotEmpty) {
        remoteRTCVideoRenderer.srcObject = event.streams[0];  // Render remote video
        // var list = websocket.participant.where((v) {
        //   return v.vidieodeviceId == cameraId;
        // }).toList();
        // if (list.isNotEmpty) {
        //   list[0].mediaStream = stream;
        //   // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
        // }
      }
    };
    peerConnection!.onAddStream = (stream) {
      // Handle incoming media stream
      print('stream from pConnect');
    };
  }

  void initViewerStream() {
    if (isWebsocketRunning) return;

    // final url = 'wss://${baseurl}bbb-webrtc-sfu?sessionToken=${webrtctoken}';
    channel = WebSocketChannel.connect(Uri.parse(mediawebsocketurl));

    var payload = {
      "id":"start",
      "type":"screenshare",
      "role":"recv",
      "internalMeetingId":meetingdetails.meetingId,
      "voiceBridge":meetingdetails.voicebridge,
      "userName":meetingdetails.fullname,
      "callerName":meetingdetails.internalUserId,
      "hasAudio":false,
      "contentType":"camera"
    };

    websocketsub(payload);

    channel!.stream.listen(
          (event) {
        var e = jsonDecode(event);
        print("new event");
        print(event);
        switch (e['id']) {
          case 'startResponse':
            receiveViewerSDPAnswer(e['sdpAnswer']);
            break;
          case 'iceCandidate':
            receiveCandidate(e['candidate']['candidate']);
            break;
          case 'playStart':
            break;
          case 'error':
            print('WebSocket error: $e');
            break;
          default:
            print('Unhandled WebSocket event: $e');
        }
      },
      onDone: () {
        print("WebSocket connection closed.");
        isWebsocketRunning = false;
      },
      onError: (err) {
        print("WebSocket error: $err");
        isWebsocketRunning = false;
        if (retryLimit > 0) retryLimit--;
      },
    );
    update();
  }


  void receiveCandidate(String candidate) async {
    var iceCandidate = RTCIceCandidate(candidate, null, 0);
    await peerConnection?.addCandidate(iceCandidate);
  }

  void websocketsub(Map<String, dynamic> json) {
    print("payload");
    print(json);
    channel!.sink.add(jsonEncode(json));
  }

}