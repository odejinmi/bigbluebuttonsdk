import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/meetingdetails.dart';
import '../bigbluebuttonsdk.dart';


class Screensharewebsocket extends GetxController {

  var _isWebsocketRunning = false.obs; //status of a websocket
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  var _isVideo = false.obs; //status of video sharing
  set isVideo(value) => _isVideo.value = value;
  get isVideo => _isVideo.value;

  WebSocketChannel? channel; //initialize a websocket channel
  var retryLimit = 3;
  RTCPeerConnection? peerConnection;
  List<MediaDeviceInfo>? _mediaDevicesList;

  // mediaStream for localPeer
  MediaStream? _localStream;

  // list of rtcCandidates to be sent over signaling
  List<RTCIceCandidate> rtcIceCandidates = [];

  // videoRenderer for localPeer
  final _localRTCVideoRenderer = RTCVideoRenderer().obs;
  set localRTCVideoRenderer(value) => _localRTCVideoRenderer.value = value;
  get localRTCVideoRenderer => _localRTCVideoRenderer.value;

  // videoRenderer for remotePeer
  final _remoteRTCVideoRenderer = RTCVideoRenderer().obs;
  set remoteRTCVideoRenderer(value) => _remoteRTCVideoRenderer.value = value;
  get remoteRTCVideoRenderer => _remoteRTCVideoRenderer.value;

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
    remoteRTCVideoRenderer.initialize();

    mediaDevices.ondevicechange = (event) async {
      _mediaDevicesList = await mediaDevices.enumerateDevices();
    };

    super.onInit();
  }

  void initiate(
      {required String webrtctoken,
      required String mediawebsocketurl,
      required Meetingdetails meetingDetails}) {
    this.webrtctoken = webrtctoken;
    this.meetingDetails = meetingDetails;
    this.mediawebsocketurl = mediawebsocketurl;
    createPeerConnections();
  }

  Future<void> createPeerConnections() async {
    final configuration = {
      // 'iceServers': [
      //   {
      //     'urls': [
      //       'stun:stun1.l.google.com:19302',
      //       'stun:stun2.l.google.com:19302',
      //     ]
      //   },
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

    // Create the peer connection
    peerConnection = await createPeerConnection(configuration);

    // Get local media stream (screen sharing)
    _localStream = await mediaDevices.getDisplayMedia({
      'audio': true,
      'video': {
        'width': 1920,
        'height': 1080,
        'frameRate': 30,
      },
    });

    // Enumerate media devices
    _mediaDevicesList = await mediaDevices.enumerateDevices();

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
      'offerToReceiveAudio': false,
      'offerToReceiveVideo': true,
    });

    if (offer == null) {
      print("Failed to create SDP offer");
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
      print("Received SDP answer is null or empty");
      return;
    }
    await peerConnection?.setRemoteDescription(RTCSessionDescription(answer, 'answer'));
  }

  void receiveStart() {
    isVideo = true;
  }

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
      "voiceBridge": "14735",
      "userName": "ODEJINMI TOLULOPE",
      "callerName": "w_zkymlvzr3jyv",
      "sdpOffer": sdp,
      "hasAudio": false,
      "contentType": "screenshare",
      "bitrate": 1500
    };

    websocketsub(payload);
    isWebsocketRunning = true;

    channel!.stream.listen(
          (event) {
            print("new event");
            print(event);
        var e = jsonDecode(event);
        switch (e['id']) {
          case 'startResponse':
            receiveSDP(e['sdpAnswer']);
            break;
          case 'iceCandidate':
            receiveCandidate(e['candidate']['candidate']);
            break;
          case 'playStart':
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
    channel!.sink.add(jsonEncode(json));
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
    localRTCVideoRenderer.srcObject = null;
    remoteRTCVideoRenderer.srcObject = null;

    // Reset flags
    isVideo = false;
    update();
  }
}
