import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../utils/meetingdetails.dart';
import '../bigbluebuttonsdk.dart';
import 'websocket.dart';


class Videowebsocket extends GetxController{

  var _isWebsocketRunning = false.obs; //status of a websocket
  set isWebsocketRunning(value)=> _isWebsocketRunning.value = value;
  get isWebsocketRunning => _isWebsocketRunning.value;

  var _isvideo = false.obs; //status of a websocket
  set isvideo(value)=> _isvideo.value = value;
  get isvideo => _isvideo.value;

  WebSocketChannel? channel; //initialize a websocket channel
  var retryLimit = 3;
  RTCPeerConnection? peerConnection ;
  var edSet;

  var _mediaDevicesList = <MediaDeviceInfo>[].obs;
  set mediaDevicesList (value) => _mediaDevicesList.value = value;
  get mediaDevicesList => _mediaDevicesList.value;

  // mediaStream for localPeer
  MediaStream? _localStream;
  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  var _deviceid = "".obs;
  set deviceid (value) => _deviceid.value = value;
  get deviceid => _deviceid.value;

  var _width = 640.obs;
  set width (value) => _width.value = value;
  get width => _width.value;

  var _frameRate = 15.obs;
  set frameRate (value) => _frameRate.value = value;
  get frameRate => _frameRate.value;

  var websocket = Get.find<Websocket>();

  final _webrtctoken = "".obs;
  set webrtctoken(value)=> _webrtctoken.value = value;
  get webrtctoken => _webrtctoken.value;

  final _mediawebsocketurl = "".obs;
  set mediawebsocketurl(value)=> _mediawebsocketurl.value = value;
  get mediawebsocketurl => _mediawebsocketurl.value;

  var _meetingdetails =  Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  get meetingdetails => _meetingdetails.value;

  @override
  void onInit() {
    super.onInit();
    // createPeerconnect();
    mediaDevices.ondevicechange = (event) async {
      // print('++++++ ondevicechange ++++++');
      getdevices().then((value){
        mediaDevicesList =value;
      });
    };
    getdevices().then((value){
      mediaDevicesList =value;
      if (mediaDevicesList.length > 1) {
        deviceid = mediaDevicesList.last.deviceId;
      }else {
        deviceid = mediaDevicesList.first.deviceId;
      }
    });
  }

  Future<List<MediaDeviceInfo>> getdevices() async {
    // Enumerate media devices
    var devices = await mediaDevices.enumerateDevices();
    return devices.where((device) => device.kind == 'videoinput').toList();

  }

  void initiate(
      {required String webrtctoken,
        required String mediawebsocketurl,
        required Meetingdetails meetingdetails}){
    this.webrtctoken = webrtctoken;
    this.meetingdetails = meetingdetails;
    this.mediawebsocketurl = mediawebsocketurl;
    createPeerconnect();
  }

  Future<MediaStream> createVideoStream({required int width, required int frameRate,required String videoDeviceId}) async {
    final Map<String, dynamic> constraints = {
      'video': {
        'deviceId': videoDeviceId,
        'width':  width,
        // 'height': {'ideal': height},
        'frameRate': frameRate,
      },
      'audio': false, // include audio if needed
    };

    return await mediaDevices.getUserMedia(constraints);
  }

  Future<void> createPeerconnect() async {
    // print('createPeerConnect');

    // Fetch device ID (ensure this function works as intended)
    getDeviceID('videoinput');

    final configuration = {
      // 'iceServers': [
      //   {
      //     'urls': [
      //       'stun:stun1.l.google.com:19302',
      //       'stun:stun2.l.google.com:19302'
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

    _localStream = await createVideoStream(width: width, frameRate: frameRate, videoDeviceId: deviceid);

    // Enumerate media devices
    getdevices().then((value){
      mediaDevicesList =value;
      deviceid = mediaDevicesList.first.deviceId;
    });

    // Add local tracks to the peer connection
    _localStream!.getTracks().forEach((track) {
      peerConnection?.addTrack(track, _localStream!);
    });
    negotiate();
  }

  void switchVideoQuality({required int width, /*int height,*/ required int frameRate}) async {
    this.frameRate = frameRate;
    this.width = width;
    adjustvideo();
  }

  void switchcamera({required String deviceid}) async {
    this.deviceid = deviceid;
    adjustvideo();
  }

  void adjustvideo() async {
    // Step 1: Stop the existing video track if it exists
    if (_localStream != null) {
      _localStream?.getTracks().forEach((track) {
        track.stop();
      });
    }

    // Step 2: Create a new video stream with updated quality settings
    _localStream = await createVideoStream(
        width: width, /*height: height,*/ frameRate: frameRate, videoDeviceId: deviceid);

    // Step 4: Replace the video track on the peer connection
    if (peerConnection != null && _localStream != null) {
      // Assuming your local stream has only one video track
      var newVideoTrack = _localStream!.getVideoTracks().first;

      // Get the existing sender for the video track
      var senderlist = await peerConnection!.getSenders();

      var sender = senderlist.firstWhere(
              (s) => s.track?.kind == 'video',
          orElse: () => throw Exception("Video sender not found"));

      // Replace the existing track with the new one
      await sender.replaceTrack(newVideoTrack);

      // Renegotiate the connection if needed
      await negotiate();
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

      var sender = senderlist.firstWhere(
              (s) => s.track?.kind == 'video',
          orElse: () => throw Exception("Video sender not found"));

      // Replace the existing track with the new one
      await sender.replaceTrack(newVideoTrack);

      // Renegotiate the connection if needed
      await negotiate();
    }
  }

  // Example renegotiation function
  Future<void> negotiate() async {
    // Render remote video
    var list = websocket.participant.where((v) {
      return v.fields!.userId == websocket.mydetails!.fields!.userId;
    }).toList();
    if (list.isNotEmpty) {
      list[0].mediaStream = _localStream;
      list[0].rtcVideoRenderer = RTCVideoRenderer();
      await list[0].rtcVideoRenderer!.initialize();
      list[0].rtcVideoRenderer!.srcObject = _localStream;
      // 4a52e9693531407dfa0b6471e3a22ce0a6f0ee64b2f4c1af256b4a6cb8c35418
    }

    peerConnection!.onIceCandidate =
        (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

    // peerConnection?.onIceConnectionState = (state) {
    //   print("ICE Connection State: $state");
    //   if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
    //     receiveStart();
    //   }
    // };
    // Create and set local description
    final offerOptions = {
      'offerToReceiveAudio': false,
      'offerToReceiveVideo': true,
    };
    final offer = await peerConnection?.createOffer(offerOptions);
    if (offer == null) {
      print("Failed to create SDP offer");
      return;
    }

    await peerConnection?.setLocalDescription(offer);

// Send the offer via WebSocket or your signaling method
    videoStream(offer.sdp);



    peerConnection?.onIceCandidate = (candidate) {
      sendCandidate(candidate.toMap());
      // Handle ICE candidate
    };

    peerConnection?.onAddStream = (stream) {
      // Handle incoming media stream
      // print('stream from pConnect');
    };

    if(peerConnection?.connectionState == "RTCPeerConnectionStateConnected"){
      // print('connection state is RTCPeerConnectionStateConnected');
      receiveStart();
    }
  }

  void receiveCandidate(candidate) async {
    // Exchange ICE candidates with the Kurento server
    await peerConnection?.addCandidate(RTCIceCandidate(candidate!,'',0));
  }

  void receiveSDP(answer) async {
    if (answer == null || answer.isEmpty) {
      print("Received SDP answer is null or empty");
      return;
    }

    await peerConnection?.setRemoteDescription(RTCSessionDescription(answer, 'answer'));
  }


  void receiveStart()async{
    // Receive start answer from the Kurento server
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"100\",\"method\":\"userShareWebcam\",\"params\":[\"${streamID(edSet.deviceId)}\"]}"]);
    isvideo = true;
  }

  Future<void> getDeviceID(String type) async {
    try {
      // Enumerate media devices
      var devices = await mediaDevices.enumerateDevices();


      // Loop through devices to find the requested type
      for (var device in devices) {
        if (device.kind == type) {
          // print('Label: ${device.label}');
          // print('Kind: ${device.kind}');
          // print('Device ID: ${device.deviceId}');
          // print("======");
          edSet = device; // Store the found device
        }
      }

      // Check if a device was found
      if (edSet != null) {
        // print("Selected Device:");
        // print(edSet.deviceId);

        var mc = {
          'audio': {'deviceId': edSet.deviceId}
        };
      } else {
        // print('No device found of type $type.');
      }
    } catch (e) {
      // print('Error retrieving devices: $e');
    }
  }

  void sendCandidate(candidate){
    // print('sending candidate out');
    var payload={"type":"video","role":"share","id":"onIceCandidate","candidate":candidate,"cameraId":streamID(edSet.deviceId)};
    // print('payload:${payload}');
    websocketsub(payload);
  }

  void videoStream(sdp) {
    if (isWebsocketRunning) return; //chaech if its already running
    // print("This is the SDP: $sdp");
    // final url = 'wss://${baseurl}bbb-webrtc-sfu?sessionToken=${webrtctoken}';
    // print("video websocket url $url");
    channel = WebSocketChannel.connect(
      Uri.parse(mediawebsocketurl), //connect to a websocket
    );
    //stop video stream;
    // {"id":"stop","type":"video","cameraId":"w_2er3ojb6o4yv_9eb30d720bf574674bce5c0adeb4b88b78ef6b1b4862e6129d22aaeb38c33adf","role":"share"}
    var payload={
      "id":"start",
      "type":"video",
      "cameraId":streamID(edSet.deviceId),
      "role":"share",
      "sdpOffer":sdp,
      "bitrate":200,
      "record":true
    };
    websocketsub(payload);
    isWebsocketRunning = true;
    channel!.stream.listen(
          (event) {

        var e=jsonDecode(event);

        switch(e['id']){
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
            if(e['message'] == "MEDIA_SERVER_GENERIC_ERROR"){
              // websocketsub(payload);
            }
            // print(e);
            break;
          default:
          // print('no handler yet');
        }
      },
      onDone: () {
        // print("kurento ws ondone");
        isWebsocketRunning = false;
      },
      onError: (err) {
        // print("kurento ws error");
        // print(err);
        isWebsocketRunning = false;
        if (retryLimit > 0) {
          retryLimit--;
          // startStream();

        }
      },
    );
    update();
  }

  Future<void> replaceVideoTrack(
      MediaStreamTrack track, {
        List<RTCRtpSender>? sendersList,
      }) async {
    final List<RTCRtpSender> senders =
    (sendersList ?? await peerConnection!.getSenders())
        .where(
          (sender) => sender.track?.kind == 'video',
    )
        .toList();

    if (senders.isEmpty) return;

    final sender = senders.first;

    sender.replaceTrack(track);

    // await _enableEncryption(_callSetting.e2eeEnabled);
  }

  void websocketsub(json) {
    channel!.sink.add(jsonEncode(json),);
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
      websocketsub(stopPayload);
    }

    // 2. Close the WebSocket connection if it's open
    if (channel != null) {
      await channel?.sink.close();
      channel = null;
      isWebsocketRunning = false;
    }

    // 3. Close the peer connection if it's active
    if (peerConnection != null) {
      await peerConnection?.close();
      peerConnection = null;
    }

    // 4. Stop the local media stream (camera)
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        track.stop();  // Stop each track
      });
      _localStream = null;
    }
    // Render remote video
    var list = websocket.participant.where((v) {
      return v.fields!.userId == websocket.mydetails!.fields!.userId;
    }).toList();
    if (list.isNotEmpty) {
      list[0].mediaStream = null;
      list[0].rtcVideoRenderer = null;
    }
    // 7. Reset flags
    isvideo = false;
    update();
  }


  String streamID(id) => "${meetingdetails.internalUserId}${meetingdetails.authToken}${id}";
}