import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../bigbluebuttonsdk.dart';
import 'Speechtotext.dart';

class Audiowebsocket extends GetxController {
  var _isWebsocketRunning = false.obs; // Status of the WebSocket
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  WebSocketChannel? channel; // Initialize a WebSocket channel
  var retryLimit = 3;
  RTCPeerConnection? _peerConnection;
  var edSet;

  // mediaStream for localPeer
  MediaStream? _localStream;
  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  final _webrtctoken = "".obs;
  set webrtctoken(value) => _webrtctoken.value = value;
  get webrtctoken => _webrtctoken.value;

  final _mediawebsocketurl = "".obs;
  set mediawebsocketurl(value) => _mediawebsocketurl.value = value;
  get mediawebsocketurl => _mediawebsocketurl.value;

  var _meetingdetails = Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  get meetingdetails => _meetingdetails.value;

  var _deviceid = "".obs;
  set deviceid(value) => _deviceid.value = value;
  get deviceid => _deviceid.value;
  var websocket = Get.find<Websocket>();

  Timer? _pingTimer; // Timer to manage pings

  @override
  void onInit() {
    super.onInit();
    mediaDevices.ondevicechange = (event) async {
      getdevices().then((value) {
        // mediaDevicesList = value;
      });
    };
    getdevices().then((value) {
      // mediaDevicesList = value;
      deviceid = value.first.deviceId;
    });
    getaudiospeakerdevices().then((devices) {
      print('Available speakers:');
      devices.forEach((device) {
        print('${device.label} - ${device.deviceId}');
      });
    });
  }

  Future<List<MediaDeviceInfo>> getdevices() async {
    var devices = await mediaDevices.enumerateDevices();
    return devices.where((device) => device.kind == 'audioinput').toList();
  }

  Future<List<MediaDeviceInfo>> getaudiospeakerdevices() async {
    var devices = await mediaDevices.enumerateDevices();
    return devices.where((device) => device.kind == 'audiooutput').toList();
  }

  void switchmicrophone({required String deviceid}) async {
    this.deviceid = deviceid;
    adjustvideo();
  }

  void switchspeaker({required String deviceid}) async {
    // Switch to speaker
    Helper.selectAudioOutput(
        deviceid); // 1 = speaker, 0 = earpiece (Android only)
  }

  void adjustvideo() async {
    // Step 1: Stop the existing video track if it exists
    if (_localStream != null) {
      _localStream?.getTracks().forEach((track) {
        track.stop();
      });
    }

    // Step 2: Create a new video stream with updated quality settings
    _localStream = await createAudioStream(audioDeviceId: deviceid);

    // Step 4: Replace the video track on the peer connection
    if (_peerConnection != null && _localStream != null) {
      // Assuming your local stream has only one video track
      var newVideoTrack = _localStream!.getAudioTracks().first;

      // Get the existing sender for the video track
      var senderlist = await _peerConnection!.getSenders();

      var sender = senderlist.firstWhere((s) => s.track?.kind == 'audio',
          orElse: () => throw Exception("Audio sender not found"));

      // Replace the existing track with the new one
      await sender.replaceTrack(newVideoTrack);

      // Renegotiate the connection if needed
      await negotiate();
    }
  }

  // Example renegotiation function
  Future<void> negotiate() async {
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      rtcIceCadidates.add(candidate);
      sendCandidate(candidate.candidate!);
    };

    _peerConnection?.onIceConnectionState = (state) {
      // if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      //   receiveStart();
      // }
    };

    // Create and set local description
    final offerOptions = {
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': false,
    };
    // Create and set local description
    final offer = await _peerConnection?.createOffer(offerOptions);
    // Check if the offer was created successfully
    if (offer == null) {
      throw Exception('Failed to create offer');
    }
    await _peerConnection?.setLocalDescription(offer);
    final sdpOffer = await _peerConnection?.getLocalDescription();
    sendSDPOffer(sdpOffer!.sdp);

    _peerConnection?.onAddStream = (stream) {
      // Handle incoming media stream here if needed
    };
  }

  @override
  void onClose() {
    stopWebSocketPing(); // Stop the ping timer when the WebSocket is closed
    hangUp();
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

      await _peerConnection?.close();
      _peerConnection = null;
    } catch (e) {
      print("Error during hangup: $e");
    }
  }

  void startWebSocketPing() {
    // If the WebSocket is running, start pinging every 10 seconds
    _pingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (channel != null && isWebsocketRunning) {
        sendPingMessage();
      } else {
        stopWebSocketPing(); // Stop the ping if WebSocket is not connected
      }
    });
  }

  void stopWebSocketPing() {
    _pingTimer?.cancel(); // Cancel the timer
  }

  void sendPingMessage() {
    var pingPayload = {"id": "ping"};
    websocketsub(pingPayload); // Send the ping over WebSocket
  }

  void receiveCandidate(candidate) async {
    // Exchange ICE candidates with the Kurento server
    await _peerConnection?.addCandidate(RTCIceCandidate(candidate!, '', 0));
  }

  void initiate(
      {required String webrtctoken,
      required String mediawebsocketurl,
      required Meetingdetails meetingdetails}) {
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
    this.mediawebsocketurl = mediawebsocketurl;
    createPeerConnections();
  }

  Future<MediaStream> createAudioStream({required String audioDeviceId}) async {
    final Map<String, dynamic> constraints = {
      'audio': {
        'deviceId': audioDeviceId ?? '',
      },
      'video': false,
    };

    return await mediaDevices.getUserMedia(constraints);
  }

  Future<void> createPeerConnections() async {
    final configuration = {
      "iceServers": [
        {
          "urls": "turn:meet.konn3ct.ng:3478",
          "username": "1734371473:w_3ljtaffhxtcn",
          "credential": "h43KnBujHdFH3tGrqxbduv/KAxQ="
        }
      ],
      "iceTransportPolicy": "relay"
    };
    _peerConnection = await createPeerConnection(websocket.sturnserver);

    // listen for remotePeer mediaTrack event
    _peerConnection?.onTrack = (event) {};

    // Get audio media stream
    _localStream = await createAudioStream(audioDeviceId: deviceid);

    // Add audio track to the peer connection
    _localStream!.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    negotiate();
  }

  void sendSDPOffer(String? sdp) {
    if (sdp == null || isWebsocketRunning) return;

    // final url = 'wss://${baseurl}bbb-webrtc-sfu?sessionToken=${webrtctoken}';
    channel = WebSocketChannel.connect(Uri.parse(mediawebsocketurl));
    var payload = {
      "id": "start",
      "type": "audio",
      "role": "sendrecv",
      "clientSessionNumber": 2,
      "sdpOffer": sdp,
      "extension": null,
      "transparentListenOnly": false
    };
    websocketsub(payload);
    startWebSocketPing(); // Start pinging when the WebSocket is initialized

    channel!.stream.listen((event) {
      if (!isWebsocketRunning) {
        isWebsocketRunning = true;
        Get.find<Texttospeech>().start(meetingdetails: meetingdetails!);
      }
      var response = jsonDecode(event);
      handleWebSocketResponse(response);
    }, onDone: () {
      isWebsocketRunning = false;
    }, onError: (error) {
      isWebsocketRunning = false;
    });

    isWebsocketRunning = true;
  }

  Future<void> handleWebSocketResponse(Map<String, dynamic> response) async {
    switch (response['id']) {
      case 'startResponse':
        // receiveSDP(response['sdpAnswer']);
        if (response['response'] == "accepted") {
          // set SDP offer as remoteDescription for peerConnection
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(response['sdpAnswer'], "answer"),
          );
        }
        break;
      case 'onIceCandidate':
        receiveCandidate(response['candidate']);
        break;
      case 'playStart':
        // receiveStart();
        break;
      case 'webRTCAudioSuccess':
        stopWebSocketPing();
        break;
      case 'error':
        break;
      default:
    }
  }

  void sendCandidate(String candidate) {
    var payload = {
      "type": "audio",
      "role": "share",
      "id": "onIceCandidate",
      "candidate": candidate,
    };
    websocketsub(payload);
  }

  void websocketsub(Map<String, dynamic> json) {
    if (channel != null) {
      channel!.sink.add(jsonEncode(json));
    } else {}
  }
}
