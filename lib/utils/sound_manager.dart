import 'package:just_audio/just_audio.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  final AudioPlayer _player = AudioPlayer();

  factory SoundManager() {
    return _instance;
  }

  SoundManager._internal();

  /// Play audio from a local asset.
  /// Provide the full asset key.
  /// For app assets: 'assets/sounds/notification.mp3'
  /// For package assets: 'packages/bigbluebuttonsdk/assets/sounds/notification.mp3'
  Future<void> playAsset(String assetPath) async {
    try {
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      print("SoundManager: Error playing asset $assetPath: $e");
    }
  }

  /// Play audio from a remote URL.
  Future<void> playUrl(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print("SoundManager: Error playing URL $url: $e");
    }
  }

  /// Play audio from a local file path.
  Future<void> playDeviceFile(String filePath) async {
    try {
      await _player.stop();
      await _player.setFilePath(filePath);
      await _player.play();
    } catch (e) {
      print("SoundManager: Error playing device file $filePath: $e");
    }
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
