import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../utils/meetingdetails.dart';
import '../../utils/strings.dart';
import '../bigbluebuttonsdk.dart';
import 'websocket.dart';

class RemoteVideoWebSocket extends GetxController {
  var _isWebsocketRunning = false.obs;
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  WebSocketChannel? channel;
  var retryLimit = 3;
  var websocket = Get.find<Websocket>();
  RTCPeerConnection? peerConnection;
  List<MediaDeviceInfo>? _mediaDevicesList;
  MediaStream? _localStream;
  List<RTCIceCandidate> rtcIceCandidates = [];
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
    _localRTCVideoRenderer.value.dispose();
    _remoteRTCVideoRenderer.value.dispose();
    peerConnection?.close();
    peerConnection = null;
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
      required Meetingdetails meetingdetails,
      required String cameraId}) {
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
    this.mediawebsocketurl = mediawebsocketurl;
    initViewerStream(cameraId);
  }

  void receiveViewerSDPAnswer(String answer, String cameraId) async {
    final config = {
      'iceServers': [
        {
          'urls': ['stun:stun1.l.google.com:19302', 'stun:stun2.l.google.com:19302']
        },
        {
          "username": "1728397897:w_km0obr3wtifm",
          "credential": "674xlGmId+zxxySOF12yjq8Kwy4=",
          "urls": "turns:meet.konn3ct.ng:443?transport=tcp",
          "ttl": 86400
        },
        {
          "username": "1728397897:w_km0obr3wtifm",
          "credential": "674xlGmId+zxxySOF12yjq8Kwy4=",
          "urls": "turn:meet.konn3ct.ng:3478",
          "ttl": 86400
        }
      ],
    };

    final constraints = {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': true,
    };

    peerConnection = await createPeerConnection(config);

    // Set remote description with the received answer
    await peerConnection!.setRemoteDescription(RTCSessionDescription(answer, 'offer'));

    var newAnswer = await peerConnection!.createAnswer(constraints);
    await peerConnection!.setLocalDescription(newAnswer);
    logLongText("newAnswer.toMap()");
    logLongText(jsonEncode(newAnswer.toMap()));

    websocketsub({
      "id": "subscriberAnswer",
      "type": "video",
      "role": "viewer",
      "cameraId": cameraId,
      "answer": newAnswer.sdp!
    });

    // Handle incoming ICE candidates
    peerConnection!.onIceCandidate = (candidate) {
      websocketsub({
        "id": "onIceCandidate",
        "type": "video",
        "role": "viewer",
        "cameraId": cameraId,
        "candidate": candidate.toMap()
      });
    };

    // Properly handle incoming tracks (audio or video)
    peerConnection!.onTrack = (RTCTrackEvent event) async {
      print("onTrack triggered");
      print(event);

      // Attach video stream to the remote renderer if track is video
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        remoteRTCVideoRenderer.srcObject = event.streams[0];
        print("Received remote video track.");
        // Render remote video
        var list = websocket.participant.where((v) {
          return v.vidieodeviceId != null && v.vidieodeviceId! == cameraId;
        }).toList();
        if (list.isNotEmpty) {
          list[0].mediaStream = _localStream;
          list[0].rtcVideoRenderer = RTCVideoRenderer();
          await list[0].rtcVideoRenderer!.initialize();
          list[0].rtcVideoRenderer!.srcObject = _localStream;
          // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
        }
      }
    };

    peerConnection!.onIceConnectionState = (state) {
      print("ICE Connection State: $state");
    };
  }

  void initViewerStream(String cameraId) {
    if (isWebsocketRunning) return;

    // final url = 'wss://${baseurl}bbb-webrtc-sfu?sessionToken=${webrtctoken}';
    channel = WebSocketChannel.connect(Uri.parse(mediawebsocketurl));

    var payload = {
      "id": "start",
      "type": "video",
      "cameraId": cameraId,
      "role": "viewer",
      "bitrate": 200,
      "record": true,
    };

    websocketsub(payload);

    channel!.stream.listen(
          (event) async {
        var e = jsonDecode(event);
        print("New WebSocket event");
        print(e);
        switch (e['id']) {
          case 'playStart':
          // Handle the start of playback
            var result = await peerConnection!.getSenders();
            result.forEach((sender) {
              print("Track sender: ${sender.track}");
            });
            break;

          case 'startResponse':
          // Handle the start response and set SDP answer
            receiveViewerSDPAnswer(e['sdpAnswer'], e['cameraId']);
            break;

          case 'iceCandidate':
          // Handle incoming ICE candidates
            receiveCandidate(e['candidate']['candidate']);
            break;

          default:
            print('Unhandled WebSocket event: $e');
        }
      },
      onDone: () {
        isWebsocketRunning = false;
      },
      onError: (err) {
        print("WebSocket error: $err");
        isWebsocketRunning = false;
        if (retryLimit > 0) retryLimit--;
      },
    );
  }

  void websocketsub(Map<String, dynamic> json) {
    channel?.sink.add(jsonEncode(json));
  }

  void receiveCandidate(String candidate) async {
    // Parse and add ICE candidate to PeerConnection
    var iceCandidate = RTCIceCandidate(candidate, null, 0);
    await peerConnection?.addCandidate(iceCandidate);
  }
}
