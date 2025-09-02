import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../bigbluebuttonsdk.dart';

class Screensharewebsocket extends GetxController {
  final _isWebsocketRunning = false.obs; //status of a websocket
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;
  var websocket = Get.find<Websocket>();

  WebSocketChannel? channel; //initialize a websocket channel
  var retryLimit = 3;
  RTCPeerConnection? peerConnection;

  // mediaStream for localPeer
  MediaStream? _localStream;

  // list of rtcCandidates to be sent over signaling
  List<RTCIceCandidate> rtcIceCandidates = [];

  // videoRenderer for localPeer
  final _localRTCVideoRenderer = RTCVideoRenderer().obs;
  set localRTCVideoRenderer(value) => _localRTCVideoRenderer.value = value;
  get localRTCVideoRenderer => _localRTCVideoRenderer.value;

  final _webrtctoken = "".obs;
  set webrtctoken(value) => _webrtctoken.value = value;
  get webrtctoken => _webrtctoken.value;

  final _mediawebsocketurl = "".obs;
  set mediawebsocketurl(value) => _mediawebsocketurl.value = value;
  get mediawebsocketurl => _mediawebsocketurl.value;

  var _meetingDetails = Rx<Meetingdetails?>(null);
  set meetingDetails(value) => _meetingDetails.value = value;
  get meetingDetails => _meetingDetails.value;

  @override
  void onInit() {
    // initializing renderers
    localRTCVideoRenderer.initialize();

    super.onInit();
  }

  void initiate({
    required String webrtctoken,
    required String mediawebsocketurl,
    required Meetingdetails meetingDetails,
    required bool audio,
  }) {
    this.webrtctoken = webrtctoken;
    this.meetingDetails = meetingDetails;
    this.mediawebsocketurl = mediawebsocketurl;
    createPeerConnections(audio);
  }

  Future<void> createPeerConnections(bool audio) async {
    // Create the peer connection
    peerConnection = await createPeerConnection(websocket.stunServer);

    // Get local media stream (screen sharing)
    _localStream = await mediaDevices.getDisplayMedia({
      'audio': true,
      'video': {'width': 1920, 'height': 1080, 'frameRate': 30},
    });

    // Add local tracks to the peer connection
    _localStream!.getTracks().forEach((track) {
      peerConnection?.addTrack(track, _localStream!);
    });

    // Set source for local video renderer
    localRTCVideoRenderer.srcObject = _localStream;

    // Handle ICE candidate generation
    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      rtcIceCandidates.add(candidate);
      sendCandidate(candidate.toMap());
    };

    // Create and set local SDP offer
    final offer = await peerConnection?.createOffer({
      'offerToReceiveAudio': audio,
      'offerToReceiveVideo': true,
    });

    if (offer == null) {
      debugPrint("Failed to create SDP offer");
      return;
    }

    await peerConnection?.setLocalDescription(offer);

    // Send the SDP offer via WebSocket or your signaling method
    videoStream(offer.sdp!);
  }

  void receiveCandidate(String candidate) async {
    await peerConnection?.addCandidate(RTCIceCandidate(candidate, '', 0));
  }

  void receiveSDP(String answer) async {
    if (answer.isEmpty) {
      debugPrint("Received SDP answer is null or empty");
      return;
    }
    await peerConnection?.setRemoteDescription(
      RTCSessionDescription(answer, 'answer'),
    );
  }

  void receiveStart() {}

  void sendCandidate(Map<String, dynamic> candidate) {
    // Implement your signaling logic to send candidate to server
  }

  void videoStream(String sdp) {
    if (isWebsocketRunning) return;

    // final url = 'wss://${baseurl}bbb-webrtc-sfu?sessionToken=${webrtctoken}';
    channel = WebSocketChannel.connect(Uri.parse(mediawebsocketurl));

    var payload = {
      "id": "start",
      "type": "screenshare",
      "role": "send",
      "internalMeetingId": meetingDetails?.internalUserId,
      "voiceBridge": meetingDetails.voicebridge,
      "userName": meetingDetails.fullname,
      "callerName": meetingDetails.internalUserId,
      "sdpOffer": sdp,
      "hasAudio": false,
      "contentType": "screenshare",
      "bitrate": 1500,
    };

    websocketsub(payload);
    isWebsocketRunning = true;

    channel!.stream.listen(
      (event) {
        var e = jsonDecode(event);
        print('screen share event');
        print(e);
        switch (e['id']) {
          case 'startResponse':
            receiveSDP(e['sdpAnswer']);
            break;
          case 'iceCandidate':
            receiveCandidate(e['candidate']['candidate']);
            break;
          case 'playStart':
            websocket.isMeSharing = true;
            receiveStart();
            break;
          case 'error':
            if (e['message'] == "MEDIA_SERVER_GENERIC_ERROR") {
              // Handle error
            }
            break;
        }
      },
      onDone: () {
        isWebsocketRunning = false;
      },
      onError: (err) {
        isWebsocketRunning = false;
        if (retryLimit > 0) {
          retryLimit--;
          // Retry stream
        }
      },
    );
  }

  void websocketsub(Map<String, dynamic> json) {
    debugPrint("json");
    debugPrint(json.toString());
    channel!.sink.add(jsonEncode(json));
  }

  void stopScreenSharing() async {
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
    localRTCVideoRenderer.srcObject = null;
    update();
  }

  @override
  void onClose() {
    hangUp();
    peerConnection?.close();
    peerConnection = null;
    super.onClose();
  }

  Future<void> hangUp() async {
    try {
      if (_localStream != null) {
        for (var track in _localStream!.getTracks()) {
          track.stop();
        }
        await _localStream!.dispose();
        _localStream = null;
      }

      // if (remoteStream != null) {
      //   for (var track in remoteStream!.getTracks()) {
      //     track.stop();
      //   }
      //   await remoteStream!.dispose();
      //   remoteStream = null;
      // }

      await peerConnection?.close();
      peerConnection = null;

      // Clear local and remote video renderers
      localRTCVideoRenderer.srcObject = null;
    } catch (e) {
      debugPrint("Error during hangup: $e");
    }
  }
}
