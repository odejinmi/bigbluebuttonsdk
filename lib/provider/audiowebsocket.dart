import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/meetingdetails.dart';
import '../bigbluebuttonsdk.dart';


class Audiowebsocket extends GetxController {
  var _isWebsocketRunning = false.obs; // Status of the WebSocket
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  WebSocketChannel? channel; // Initialize a WebSocket channel
  var retryLimit = 3;
  RTCPeerConnection? _peerConnection;
  var edSet;
  List<MediaDeviceInfo>? _mediaDevicesList;
  // mediaStream for localPeer
  MediaStream? _localStream;
  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  final _webrtctoken = "".obs;
  set webrtctoken(value)=> _webrtctoken.value = value;
  get webrtctoken => _webrtctoken.value;

  final _mediawebsocketurl = "".obs;
  set mediawebsocketurl(value)=> _mediawebsocketurl.value = value;
  get mediawebsocketurl => _mediawebsocketurl.value;

  var _meetingdetails =  Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  get meetingdetails => _meetingdetails.value;


  Timer? _pingTimer;  // Timer to manage pings

  @override
  void onInit() {
    super.onInit();
    mediaDevices.ondevicechange = (event) async {
      // print('++++++ ondevicechange ++++++');
      _mediaDevicesList = await mediaDevices.enumerateDevices();
    };
  }
  @override
  void onClose() {
    stopWebSocketPing();  // Stop the ping timer when the WebSocket is closed
    super.onClose();
  }

  void startWebSocketPing() {
    // If the WebSocket is running, start pinging every 10 seconds
    _pingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (channel != null && isWebsocketRunning) {
        sendPingMessage();
      } else {
        stopWebSocketPing();  // Stop the ping if WebSocket is not connected
      }
    });
  }

  void stopWebSocketPing() {
    _pingTimer?.cancel();  // Cancel the timer
  }

  void sendPingMessage() {
    var pingPayload = {"id":"ping"};
    websocketsub(pingPayload);  // Send the ping over WebSocket
  }
  void receiveCandidate(candidate) async {
    // Exchange ICE candidates with the Kurento server
    // print("candidate recieved");
    await _peerConnection?.addCandidate(RTCIceCandidate(candidate!,'',0));
  }

  void initiate(
      {required String webrtctoken,
      required String mediawebsocketurl,
      required Meetingdetails meetingdetails}){
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
    this.mediawebsocketurl = mediawebsocketurl;
    createPeerConnections();
  }
  Future<void> createPeerConnections() async {
    // print('Creating peer connection');
    final configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    // listen for remotePeer mediaTrack event
    _peerConnection?.onTrack = (event) {
      // print(event.streams);

    };
    // Get audio media stream
    _localStream = await mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    _mediaDevicesList = await mediaDevices.enumerateDevices();

    // Add audio track to the peer connection
    _localStream!.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection!.onIceCandidate =
        (RTCIceCandidate candidate) {
      // print("New ICE Candidate: ${candidate.candidate}");
      rtcIceCadidates.add(candidate);
      sendCandidate(candidate.candidate!);
    };

    // _peerConnection?.onIceConnectionState = (state) {
    //   print("ICE Connection State: $state");
    //   if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
    //     receiveStart();
    //   }
    // };

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
      // print('Stream added: ${stream}');
      // print('Stream added: ${stream.getAudioTracks()}');
      // Handle incoming media stream here if needed
    };
  }

  void sendSDPOffer(String? sdp) {
    if (sdp == null || isWebsocketRunning) return;

    // final url = 'wss://${baseurl}bbb-webrtc-sfu?sessionToken=${webrtctoken}';
    channel = WebSocketChannel.connect(Uri.parse(mediawebsocketurl));
    isWebsocketRunning = true;
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
    startWebSocketPing();  // Start pinging when the WebSocket is initialized

    channel!.stream.listen((event) {
      var response = jsonDecode(event);
      handleWebSocketResponse(response);
    }, onDone: () {
      // print("WebSocket connection closed");
      isWebsocketRunning = false;
    }, onError: (error) {
      // print("WebSocket error: $error");
      isWebsocketRunning = false;
    });

    isWebsocketRunning = true;
  }

  Future<void> handleWebSocketResponse(Map<String, dynamic> response) async {
    switch (response['id']) {
      case 'startResponse':
        // receiveSDP(response['sdpAnswer']);
        if(response['response'] == "accepted"){
          // print("setting remote sdp");
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
        // print('Error: ${response['error']}');
        break;
      default:
        // print('Unhandled response: $response');
    }
  }

  void sendCandidate(String candidate) {
    // print('Sending ICE Candidate: $candidate');
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
    } else {
      // print("WebSocket channel is not connected.");
    }
  }
}