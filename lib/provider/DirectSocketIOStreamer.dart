import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bigbluebuttonsdk/provider/websocket.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../utils/diorequest.dart';

class DirectSocketIOStreamer extends GetxController {
  var websocket = Get.find<Websocket>();

  final AudioRecorder _recorder = AudioRecorder();
  IO.Socket? _socket;
  Timer? _recordingTimer;

  bool _isRecording = false;
  bool _isConnected = false;
  int _currentChunk = 0;

  var _transcribewords = "".obs;
  set transcribewords(String value) => _transcribewords.value = value;
  String get transcribewords => _transcribewords.value;

  // WAV-specific settings
  static const int wavSampleRate = 16000;
  static const int wavChannels = 1;

  static const String serverUrl = 'https://k4caption.konn3ct.ng/';

  @override
  onInit() {
    super.onInit();
    getlanguage();
    // connectToServer();
  }

  Future<void> connectToServer() async {
    try {
      // print('🔌 Connecting WAV streamer to Socket.IO server...');

      _socket = IO.io(
          serverUrl,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .setTimeout(5000)
              .build());

      _socket!.onConnect((_) {
        // print('✅ WAV streamer connected to server');
        _isConnected = true;

        // Notify server about stream start
        _socket!.emit('join_room', websocket.meetingDetails!.meetingId);
        startWavStreaming();
      });

      _socket!.onDisconnect((_) {
        // print('❌ WAV streamer disconnected');
        _isConnected = false;
        if (_isRecording) stopWavStreaming();
      });

      _socket!.on('receive_captions', (data) {
        // print('✅ Server received receive_captions ${data}');
        transcribewords = "${data["text"]}";
      });

      _socket!.on('joined_room', (data) {
        // print('✅ Server received joined_room ${data}');
      });

      _socket!.on('transcribe_audio', (data) {
        // print('✅ Server received transcribe_audio ${data}');
        transcribewords = "${data["text"]}";
      });

      _socket!.connect();
    } catch (e) {
      // print('❌ WAV Socket.IO connection failed: $e');
    }
  }

  Future<void> startWavStreaming({int chunkDurationSeconds = 5}) async {
    if (!_isConnected || _isRecording) {
      // print(
      //     '❌ Cannot start WAV streaming: Connected=$_isConnected, Recording=$_isRecording');
      return;
    }

    if (!await _recorder.hasPermission()) {
      // print('❌ Microphone permission required for WAV recording');
      return;
    }

    // print('🎙️ Starting continuous WAV streaming...');
    _isRecording = true;
    _currentChunk = 0;

    // Start first WAV chunk
    await _recordNextWavChunk(chunkDurationSeconds);
  }

  Future<void> _recordNextWavChunk(int durationSeconds) async {
    if (!_isRecording || !_isConnected) return;

    _currentChunk++;
    final chunkNumber = _currentChunk;

    try {
      Directory appDocDir = await getApplicationSupportDirectory();
      String appDocPath = appDocDir.path;
      final String tempPath = appDocPath +
          "/" +
          'wav_chunk_${chunkNumber}_${DateTime.now().millisecondsSinceEpoch}.wav';

      // print('🎙️ Recording WAV chunk $chunkNumber...');

      if (websocket.myDetails!.fields!.muted != true) {
        // WAV recording configuration
        const RecordConfig wavConfig = RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: wavSampleRate,
          numChannels: wavChannels,
          autoGain: true,
          echoCancel: true,
          noiseSuppress: true,
        );

        // Start WAV recording
        await _recorder.start(wavConfig, path: tempPath);

        // Set timer for chunk duration
        _recordingTimer = Timer(Duration(seconds: durationSeconds), () async {
          await _stopAndSendWavChunk(tempPath, chunkNumber, durationSeconds);
        });
      } else {
        // print('🔇 User is muted, skipping WAV chunk $chunkNumber');
        // Set timer for chunk duration
        _recordingTimer = Timer(Duration(seconds: durationSeconds), () async {
          await _recordNextWavChunk(durationSeconds);
        });
      }
    } catch (e) {
      // print('❌ WAV chunk recording error: $e');
    }
  }

  void getlanguage() async {
    var cmddetails = await Diorequest().get(
      "https://megatongue.prisca.5starcompany.com.ng/api/languages",
    );
    print("language cmddetails");
    print(cmddetails);
    if (cmddetails["success"]) {
      if (cmddetails["data"] == 0) {
        // checkdonationpayment(reference);
      }
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    } else {}
  }

  Future<void> _stopAndSendWavChunk(
      String filePath, int chunkNumber, int durationSeconds) async {
    try {
      // Stop current WAV recording
      final String? recordedPath = await _recorder.stop();
      // print('⏹️ WAV chunk $chunkNumber recorded: $recordedPath');

      // Start next WAV chunk immediately (seamless)
      if (_isRecording) {
        _recordNextWavChunk(durationSeconds);
      }

      // Send completed WAV chunk
      if (recordedPath != null) {
        await _sendWavChunk(recordedPath, chunkNumber);
      }
    } catch (e) {
      // print('❌ WAV chunk stop/send error: $e');
    }
  }

  Future<void> _sendWavChunk(String filePath, int chunkNumber) async {
    try {
      // print('📤 Sending WAV chunk $chunkNumber...');

      final File wavFile = File(filePath);
      final Uint8List wavBytes = await wavFile.readAsBytes();
      final String base64Wav = base64Encode(wavBytes);

      // WAV chunk data
      final wavData = {
        "user": websocket.myDetails!.fields!.name,
        "meetingID": websocket.meetingDetails!.meetingId,
        "date": DateTime.now().toIso8601String(),
        'audio': "data:audio/wav;base64,$base64Wav",
      };

      // developer.log(
      //   'Complete WAV Base64 String: $base64Wav',
      //   name: "tag",
      //   level: 1000, // Info level
      // );
      if (_socket != null && _isConnected) {
        _socket!.emit('transcribe_audio', wavData);
        // print('✅ WAV chunk $chunkNumber sent (${wavBytes.length} bytes)');
      }

      // Clean up WAV file
      await wavFile.delete();
    } catch (e) {
      // print('❌ WAV chunk send error: $e');

      // Clean up file even on error
      try {
        await File(filePath).delete();
      } catch (_) {}
    }
  }

  Future<void> stopWavStreaming() async {
    if (!_isRecording) return;

    print('🛑 Stopping WAV streaming...');
    _isRecording = false;

    _recordingTimer?.cancel();

    try {
      await _recorder.stop();
    } catch (e) {
      print('❌ Error stopping WAV recorder: $e');
    }

    // Notify server
    if (_socket != null && _isConnected) {
      _socket!.emit('end_wav_stream', {
        'total_chunks': _currentChunk,
        'format': 'wav',
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    print('✅ WAV streaming stopped');
  }

  void disconnect() {
    stopWavStreaming();
    _socket?.disconnect();
    _socket?.dispose();
    _isConnected = false;
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
