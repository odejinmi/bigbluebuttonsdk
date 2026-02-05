import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  final AudioPlayer _player = AudioPlayer();

  factory SoundManager() {
    return _instance;
  }

  SoundManager._internal();

  /// Play audio from a local asset.
  /// This uses rootBundle to load the asset, so provide the full asset key.
  /// For app assets: 'assets/sounds/notification.mp3'
  /// For package assets: 'packages/package_name/assets/sounds/notification.mp3'
  Future<void> playAsset(String assetPath) async {
    await _player.stop(); // Stop previous sound if any
    try {
      final data = await rootBundle.load(assetPath);
      await _player.play(BytesSource(data.buffer.asUint8List()));
    } catch (e) {
      print("SoundManager: Error playing asset $assetPath: $e");
    }
  }

  /// Play audio from a remote URL.
  Future<void> playUrl(String url) async {
    await _player.stop();
    await _player.play(UrlSource(url));
  }

  /// Play audio from a local file path.
  Future<void> playDeviceFile(String filePath) async {
    await _player.stop();
    await _player.play(DeviceFileSource(filePath));
  }

  /// Stop current playback
  Future<void> stop() async {
    await _player.stop();
  }

  /// Dispose the player when no longer needed
  void dispose() {
    _player.dispose();
  }
}
