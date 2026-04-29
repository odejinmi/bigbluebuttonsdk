import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:get/get.dart';

import '../provider/websocket.dart';

class AdvancedYouTubePlayer extends StatefulWidget {
  final String videoId;

  const AdvancedYouTubePlayer({
    super.key,
    required this.videoId,
    // this.autoPlay = false,
    // this.showControls = true,
    // this.loop = false,
    // this.startSeconds = 0,
    // this.isPresenter = false,
  });

  @override
  State<AdvancedYouTubePlayer> createState() => _AdvancedYouTubePlayerState();
}

class _AdvancedYouTubePlayerState extends State<AdvancedYouTubePlayer> {
  late YoutubePlayerController _controller;
  final Websocket _websocket = Get.find<Websocket>();
  Worker? _ecinemaWorker;


  bool isFullscreen = true; // Default to landscape mode

  void _enableFullscreen(bool fullscreen) {
    isFullscreen = fullscreen;
    if (fullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  var isPresenter = false;

  @override
  void initState() {
    super.initState();
    isPresenter = _websocket.myDetails?.fields?.presenter ?? true;

    _controller = YoutubePlayerController(
      initialVideoId: YouTubeHelper.extractVideoId(
        widget.videoId
      )??"",
      flags: YoutubePlayerFlags(
        autoPlay: isPresenter,
        mute: false,
        // loop: widget.loop,
        hideControls: isPresenter ,
        // startAt: widget.startSeconds,
      ),
    )
      ..addListener(_listener);

    // Listen for remote eCinema events (play/stop/seek)
    _ecinemaWorker = ever(_websocket.ecinemaEvent, _handleRemoteEvent);
    print("_AdvancedYouTubePlayerState initState");
    print(_websocket.ecinemaEvent);
  }

  void _handleRemoteEvent(Map<String, dynamic> event) {
    // Only apply remote events if we are NOT the presenter
    if (isPresenter || !_controller.value.isReady) return;

    try {
      final fields = event['fields'];
      if (fields == null) return;

      final eventName = fields['eventName'];
      final args = fields['args'];
      if (args == null || args is! List || args.isEmpty) return;

      final data = args[0];
      final double remoteTime = (data['time'] ?? 0).toDouble();

      if (eventName == 'play') {
        _controller.seekTo(Duration(seconds: remoteTime.toInt()));
        _controller.play();
      } else if (eventName == 'stop') {
        _controller.seekTo(Duration(seconds: remoteTime.toInt()));
        _controller.pause();
      }
    } catch (e) {
      debugPrint('Error handling remote eCinema event: $e');
    }
  }

  Future<Map<String, dynamic>> pauseplayecinema({required String status, required int time}) {
    _websocket.callMethod("emitExternalVideoEvent", [{"status":"presenterReady","playerStatus":{"state":0}}]);
    // "{\"msg\":\"method\",\"id\":\"261\",\"method\":\"emitExternalVideoEvent\",\"params\":[{\"status\":\"play\",\"playerStatus\":{\"time\":54,\"state\":0}}]}"
    // "{\"msg\":\"method\",\"id\":\"384\",\"method\":\"emitExternalVideoEvent\",\"params\":[{\"status\":\"stop\",\"playerStatus\":{\"time\":45,\"state\":0}}]}"
    return _websocket.callMethod("emitExternalVideoEvent", [{"status":status,"playerStatus":{"time":time,"state":0}}]);
  }

  void _listener() {
    if (isPresenter && _controller.value.isReady) {
      if (_controller.value.playerState == PlayerState.playing) {
        pauseplayecinema(
          status: 'play',
          time: _controller.value.position.inSeconds,
        );
      } else if (_controller.value.playerState == PlayerState.paused) {
        pauseplayecinema(
          status: 'stop',
          time: _controller.value.position.inSeconds,
        );
      }
    }
  }

  @override
  void dispose() {
    _ecinemaWorker?.dispose();
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      body: OrientationBuilder(
          builder: (context, orientation) {
            debugPrint('Device orientation: $orientation');
            isFullscreen = orientation == Orientation.landscape;
            return Center(
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: false,
                    progressIndicatorColor: Colors.red,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                  ),
                  builder: (context, player) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        player,
                      ],
                    );
                  },
                )
            );
          }),

      /// Stop Broadcast Button
      floatingActionButton: GetBuilder<Websocket>(
        builder: (postjoincontroller) {
          return postjoincontroller
              .myDetails!
              .fields!.presenter == true
              ? Align(
            alignment: const Alignment(1, -0.75),
            child: InkWell(
              onTap: () {
                _showEndBroadcastDialog();
              },
              child: Container(
                width: 151,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(204, 82, 95, 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromRGBO(204, 82, 95, 1),
                  ),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.close, color: Colors.white),
                      Text(
                        'Stop Broadcast',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  /// Show end broadcast dialog=======================================
  void _showEndBroadcastDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              height: 200,
              width: 350,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(62, 132, 102, 1),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          package: "govmeeting",
                          'assets/image/caution.png',
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'End eCinema',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "The session will end for everyone.\nYou can’t undo this action.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Don't End Button
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 48,
                            width: 151,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Don't End",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// End eCinema Button
                        GestureDetector(
                          onTap: () {

                            // _enableFullscreen(true);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            endecinema();
                          },
                          child: Container(
                            height: 48,
                            width: 151,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(204, 82, 95, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'End eCinema',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> endecinema() {
    return _websocket.callMethod("stopWatchingExternalVideo", []);
  }
}

class YouTubeHelper {
  /// Extracts the video ID from a YouTube URL.
  static String? extractVideoId(String url) {
    if (url.isEmpty) return null;
    return YoutubePlayer.convertUrlToId(url);
  }

  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (url.isEmpty) return null;
    return YoutubePlayer.convertUrlToId(url);
  }
}
