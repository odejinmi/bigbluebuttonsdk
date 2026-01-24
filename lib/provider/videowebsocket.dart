import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../bigbluebuttonsdk.dart';

class Videowebsocket extends GetxController {
  final _isWebsocketRunning = false.obs; //status of a websocket
  set isWebsocketRunning(value) => _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  final _isvideo = false.obs; //status of a websocket
  set isvideo(value) => _isvideo.value = value;
  get isvideo => _isvideo.value;

  WebSocketChannel? channel; //initialize a websocket channel
  var retryLimit = 3;
  RTCPeerConnection? peerConnection;

  final _edSet =
      MediaDeviceInfo(label: '', deviceId: '1').obs; //status of a websocket
  set edSet(value) => _edSet.value = value;
  get edSet => _edSet.value;

  // mediaStream for localPeer
  MediaStream? _localStream;
  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  var _width = 640.obs;
  set width(value) => _width.value = value;
  get width => _width.value;

  var _frameRate = 15.obs;
  set frameRate(value) => _frameRate.value = value;
  get frameRate => _frameRate.value;

  var websocket = Get.find<Websocket>();

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
    // createPeerconnect();
    // getdevices().then((value) {
    //   edSet = value.first;
    // });
    getedSet();
  }

  getedSet() async {
    var value = await getdevices();
    edSet = value.first;
  }

  Future<List<MediaDeviceInfo>> getdevices() async {
    try {
      // Enumerate media devices
      var devices = await mediaDevices.enumerateDevices();
      print('Available media devices:');
      devices.forEach((device) => print(
          'Device: ${device.label}, Kind: ${device.kind}, ID: ${device.deviceId}'));
      return devices.where((device) => device.kind == 'videoinput').toList();
    } catch (e) {
      print('Error enumerating devices: ${e}');
      rethrow;
    }
  }

  void initiate(
      {required String webrtctoken,
      required String mediawebsocketurl,
      required Meetingdetails meetingdetails}) {
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
    this.mediawebsocketurl = mediawebsocketurl;
    createPeerconnect();
  }

  Future<MediaStream> createVideoStream({
    required int width,
    required int frameRate,
    required String videoDeviceId,
  }) async {
    final Map<String, dynamic> constraints = {
      'video': {
        'deviceId': videoDeviceId,
        'width': width,
        'frameRate': frameRate,
      },
      'audio': false,
    };
    try {
      final stream = await mediaDevices.getUserMedia(constraints);
      print('Local video stream created: ${stream.id}');
      return stream;
    } catch (e) {
      print('Error creating local video stream: ${e}');
      rethrow;
    }
  }

  Future<void> createPeerconnect() async {
    try {
      // Create the peer connection
      peerConnection = await createPeerConnection(websocket.stunServer);
      print('PeerConnection created: ${peerConnection != null}');

      _localStream = await createVideoStream(
        width: width,
        frameRate: frameRate,
        videoDeviceId: edSet.deviceId,
      );
      print('_localStream: ${_localStream != null}');

      // Add local tracks to the peer connection
      _localStream!.getTracks().forEach((track) {
        print('Adding track: ${track.kind}');
        peerConnection?.addTrack(track, _localStream!);
      });
      negotiate();
    } catch (e) {
      print('Error in createPeerconnect: ${e}');
      rethrow;
    }
  }

  void switchVideoQuality(
      {required int width, /*int height,*/ required int frameRate}) async {
    this.frameRate = frameRate;
    this.width = width;
    adjustvideo();
  }

  void switchcamera({required String deviceid}) async {
    edSet = MediaDeviceInfo(
      deviceId: deviceid,
      label: 'new camera',
    );
    var list = websocket.participant.where((v) {
      return v.fields!.userId == websocket.myDetails!.fields!.userId;
    }).toList();
    if (list.isNotEmpty && list.first.rtcVideoRenderer != null) {
      adjustvideo();
      // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
    }
  }

  void adjustvideo() async {
    try {
      // Step 1: Stop the existing video track if it exists
      if (_localStream != null) {
        _localStream?.getTracks().forEach((track) {
          print('Stopping track: ${track.kind}');
          track.stop();
        });
      }

      // Step 2: Create a new video stream with updated quality settings
      _localStream = await createVideoStream(
        width: width,
        frameRate: frameRate,
        videoDeviceId: edSet.deviceId,
      );
      print('New _localStream created: ${_localStream != null}');

      // Step 4: Replace the video track on the peer connection
      if (peerConnection != null && _localStream != null) {
        // Assuming your local stream has only one video track
        var newVideoTrack = _localStream!.getVideoTracks().first;
        print('New video track: ${newVideoTrack.id}');

        // Get the existing sender for the video track
        var senderlist = await peerConnection!.getSenders();
        print('Sender list length: ${senderlist.length}');

        var sender = senderlist.firstWhere(
          (s) => s.track?.kind == 'video',
          orElse: () {
            print('Video sender not found');
            throw Exception('Video sender not found');
          },
        );

        // Replace the existing track with the new one
        await sender.replaceTrack(newVideoTrack);
        print('Replaced video track');

        // Renegotiate the connection if needed
        await negotiate();
      }
    } catch (e) {
      print('Error adjusting video: ${e}');
    }
  }

  void starvirtual({required Uint8List backgroundimage}) async {
    // Step 1: Stop the existing video track if it exists
    if (_localStream != null) {
      _localStream?.getTracks().forEach((track) {
        track.stop();
      });
    }

    // Step 2: Create a new video stream with updated quality settings
    _localStream = await startVirtualBackground(
      backgroundImage: backgroundimage,
    );

    // Step 4: Replace the video track on the peer connection
    if (peerConnection != null && _localStream != null) {
      // Assuming your local stream has only one video track
      var newVideoTrack = _localStream!.getVideoTracks().first;

      // Get the existing sender for the video track
      var senderlist = await peerConnection!.getSenders();

      var sender = senderlist.firstWhere((s) => s.track?.kind == 'video',
          orElse: () => throw Exception("Video sender not found"));

      // Replace the existing track with the new one
      await sender.replaceTrack(newVideoTrack);

      // Renegotiate the connection if needed
      await negotiate();
    }
  }

  Future<void> negotiate() async {
    try {
      // Render remote video
      var list = websocket.participant.where((v) {
        return v.fields!.userId == websocket.myDetails!.fields!.userId;
      }).toList();
      if (list.isNotEmpty) {
        list[0].mediaStream = _localStream;
        list[0].rtcVideoRenderer = RTCVideoRenderer();
        await list[0].rtcVideoRenderer!.initialize();
        list[0].rtcVideoRenderer!.srcObject = _localStream;
        print('RTCVideoRenderer initialized and srcObject set');
      }

      peerConnection!.onIceCandidate =
          (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

      final offerOptions = {
        'offerToReceiveAudio': false,
        'offerToReceiveVideo': true,
      };
      final offer = await peerConnection?.createOffer(offerOptions);
      if (offer == null) {
        print('Failed to create SDP offer');
        return;
      }

      await peerConnection?.setLocalDescription(offer);
      print('Set local description');

      // Send the offer via WebSocket or your signaling method
      videoStream(offer.sdp);

      peerConnection?.onIceCandidate = (candidate) {
        print('ICE candidate: ${candidate.toMap()}');
        sendCandidate(candidate.toMap());
      };

      peerConnection?.onAddStream = (stream) {
        print('Remote stream added: ${stream.id}');
      };

      if (peerConnection?.connectionState ==
          "RTCPeerConnectionStateConnected") {
        print('Connection state: RTCPeerConnectionStateConnected');
        receiveStart();
      }
    } catch (e) {
      print('Error in negotiate: ${e}');
    }
  }

  void receiveCandidate(candidate) async {
    try {
      // Exchange ICE candidates with the Kurento server
      await peerConnection?.addCandidate(RTCIceCandidate(candidate!, '', 0));
      print('Received and added ICE candidate: ${candidate}');
    } catch (e) {
      print('Error in receiveCandidate: ${e}');
    }
  }

  void receiveSDP(answer) async {
    try {
      if (answer == null || answer.isEmpty) {
        print('Received SDP answer is null or empty');
        return;
      }
      await peerConnection
          ?.setRemoteDescription(RTCSessionDescription(answer, 'answer'));
      print('Set remote description');
    } catch (e) {
      print('Error in receiveSDP: ${e}');
    }
  }

  void receiveStart() async {
    // Receive start answer from the Kurento server
    websocket.websocketSub([
      "{\"msg\":\"method\",\"id\":\"100\",\"method\":\"userShareWebcam\",\"params\":[\"${streamID(edSet.deviceId)}\"]}"
    ]);
    isvideo = true;
  }

  void sendCandidate(candidate) {
    // print('sending candidate out');
    var payload = {
      "type": "video",
      "role": "share",
      "id": "onIceCandidate",
      "candidate": candidate,
      "cameraId": streamID(edSet.deviceId)
    };
    // print('payload:${payload}');
    websocketsub(payload);
  }

  void videoStream(sdp) {
    if (isWebsocketRunning) return; //chaech if its already running
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(mediawebsocketurl), //connect to a websocket
      );
      print('WebSocketChannel connected to: ${mediawebsocketurl}');
      var payload = {
        "id": "start",
        "type": "video",
        "cameraId": streamID(edSet.deviceId),
        "role": "share",
        "sdpOffer": sdp,
        "bitrate": 200,
        "record": true
      };
      websocketsub(payload);
      isWebsocketRunning = true;
      channel!.stream.listen(
        (event) {
          print('WebSocket event: ${event}');
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
              print('WebSocket error: ${e['message']}');
              if (e['message'] == "MEDIA_SERVER_GENERIC_ERROR") {
                // websocketsub(payload);
              }
              break;
            default:
              print('WebSocket event not handled: ${e}');
          }
        },
        onDone: () {
          print('WebSocket onDone');
          isWebsocketRunning = false;
        },
        onError: (err) {
          print('WebSocket onError: ${err}');
          isWebsocketRunning = false;
          if (retryLimit > 0) {
            retryLimit--;
          }
        },
      );
      update();
    } catch (e) {
      print('Error in videoStream: ${e}');
    }
  }

  // --- UI WIDGET HINT ---
  // Ensure you are rendering the video like this in your widget tree:
  // RTCVideoView(list[0].rtcVideoRenderer!)
  // where list[0] is the local participant.

  void websocketsub(json) {
    channel!.sink.add(
      jsonEncode(json),
    );
  }

  void stopCameraSharing() async {
    // 1. Send a stop signal to the server if needed
    if (isWebsocketRunning) {
      var stopPayload = {
        "id": "stop",
        "type": "video",
        "cameraId": streamID(edSet.deviceId),
        "role": "share"
      };
      print(stopPayload);
      websocketsub(stopPayload);
    }

    // 2. Close the WebSocket connection if it's open
    if (channel != null) {
      await channel?.sink.close();
      channel = null;
      isWebsocketRunning = false;
      print('hello $isWebsocketRunning');
    }

    // 3. Close the peer connection if it's active
    if (peerConnection != null) {
      await peerConnection?.close();
      peerConnection = null;
      print('object $peerConnection');
    }

    // 4. Stop the local media stream (camera)
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        track.stop(); // Stop each track
      });
      _localStream = null;
      print('Hello1 $_localStream');
    }
    // Render remote video
    var list = websocket.participant.where((v) {
      return v.fields!.userId == websocket.myDetails!.fields!.userId;
    }).toList();
    if (list.isNotEmpty) {
      list[0].mediaStream = null;
      list[0].rtcVideoRenderer = null;
    }
    // 7. Reset flags
    isvideo = false;
    update();
  }

  String streamID(id) =>
      "${meetingdetails.internalUserId}${meetingdetails.authToken}${id}";

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
    } catch (e) {
      print("Error during hangup: $e");
    }
  }
}
