import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/strings.dart';
import '../bigbluebuttonsdk.dart';

class RemoteVideoWebSocket extends GetxController {
  var _isWebsocketRunning = false.obs;
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  WebSocketChannel? channel;
  var retryLimit = 3;
  var websocket = Get.find<Websocket>();
  RTCPeerConnection? peerConnection;
  Timer? _pingTimer;

  final _remoteRTCVideoRenderer = RTCVideoRenderer().obs;
  set remoteRTCVideoRenderer(value) => _remoteRTCVideoRenderer.value = value;
  get remoteRTCVideoRenderer => _remoteRTCVideoRenderer.value;

  // Video renderers
  final _localRTCVideoRenderer = RTCVideoRenderer().obs;
  set localRTCVideoRenderer(value) => _localRTCVideoRenderer.value = value;
  get localRTCVideoRenderer => _localRTCVideoRenderer.value;

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
    remoteRTCVideoRenderer.initialize();
  }

  @override
  void onClose() {
    stopWebSocketPing();
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

  void initiate({
    required String webrtctoken,
    required String mediawebsocketurl,
    required Meetingdetails meetingdetails,
    required String cameraId,
  }) {
    this.webrtctoken = webrtctoken;
    this.mediawebsocketurl = mediawebsocketurl;
    initViewerStream(cameraId);
  }

  Future<void> receiveViewerSDPAnswer(String answer, String cameraId) async {
    final config = {
      "stunServers": [],
      "turnServers": [
        {
          "username": "example_user",
          "password": "example_pass",
          "url": "turn:your.turn.server:3478",
          "ttl": 86400
        }
      ]
    };

    final constraints = {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': true,
    };

    peerConnection = await createPeerConnection(websocket.stunServer);

    // Set remote description with the received answer
    await peerConnection!
        .setRemoteDescription(RTCSessionDescription(answer, 'offer'));

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

    peerConnection!.onIceCandidate = (candidate) {
      websocketsub({
        "id": "onIceCandidate",
        "type": "video",
        "role": "viewer",
        "cameraId": cameraId,
        "candidate": candidate.toMap()
      });
    };

    // Handle the reception of remote media streams
    // Properly handle incoming tracks (audio or video)
    peerConnection!.onTrack = (RTCTrackEvent event) async {

      // Attach video stream to the remote renderer if track is video
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        remoteRTCVideoRenderer.srcObject = event.streams[0];
        // Render remote video
        var list = websocket.participant.where((v) {
          return v.videodeviceId != null && v.videodeviceId! == cameraId;
        }).toList();
        if (list.isNotEmpty) {
          list[0].mediaStream = event.streams[0];
          list[0].rtcVideoRenderer = RTCVideoRenderer();
          await list[0].rtcVideoRenderer!.initialize();
          list[0].rtcVideoRenderer!.srcObject = event.streams[0];
          // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
        }
      }
    };

// Handle the reception of remote media streams
    // Properly handle incoming tracks (audio or video)
    var result2 = await peerConnection!.getRemoteStreams();
    if (result2.isNotEmpty && result2[0]?.getTracks().first.kind == 'video') {
      remoteRTCVideoRenderer.srcObject = result2[0];
      // Render remote video
      var list = websocket.participant.where((v) {
        return v.videodeviceId != null && v.videodeviceId! == cameraId;
      }).toList();
      if (list.isNotEmpty) {
        list[0].mediaStream = result2[0];
        list[0].rtcVideoRenderer = RTCVideoRenderer();
        await list[0].rtcVideoRenderer!.initialize();
        list[0].rtcVideoRenderer!.srcObject = result2[0];
        // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
      }
    }

    peerConnection!.onIceConnectionState = (state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        reconnectWebSocket(cameraId);
      }
    };
  }

  void initViewerStream(String cameraId) {
    if (isWebsocketRunning) return;
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
        switch (e['id']) {
          case 'startResponse':
            receiveViewerSDPAnswer(e['sdpAnswer'], e['cameraId']);
            break;
          case 'playStart':
            var result = await peerConnection!.getSenders();
            var result2 = await peerConnection!.getRemoteStreams();
            break;
          case 'iceCandidate':
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
        reconnectWebSocket(cameraId);
      },
    );
  }

  MediaStream? _localStream;

  void reconnectWebSocket(String cameraId) {
    if (retryLimit > 0) {
      retryLimit--;
      Future.delayed(Duration(seconds: 5), () {
        initViewerStream(cameraId);
      });
    } else {
      print("Reached retry limit. Failed to reconnect WebSocket.");
    }
  }

  void websocketsub(Map<String, dynamic> json) {
    channel?.sink.add(jsonEncode(json));
  }

  void receiveCandidate(String candidate) async {
    var iceCandidate = RTCIceCandidate(candidate, null, 0);
    await peerConnection?.addCandidate(iceCandidate);
  }

  void stopCameraSharing() async {
    if (isWebsocketRunning) {
      // Send stop signal to server if needed
    }

    // Close WebSocket connection if open
    if (channel != null) {
      await channel?.sink.close();
      channel = null;
      isWebsocketRunning = false;
    }

    // Close peer connection if active
    if (peerConnection != null) {
      await peerConnection?.close();
      peerConnection = null;
    }

    // Stop local media stream
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        track.stop();
      });
      _localStream = null;
    }

    // Clear local and remote video renderers
    // localRTCVideoRenderer.srcObject = null;
    // remoteRTCVideoRenderer.srcObject = null;

    update();
  }
}
