import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdvancedYouTubePlayer extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final bool showControls;
  final bool loop;
  final int startSeconds;

  const AdvancedYouTubePlayer({
    Key? key,
    required this.videoId,
    this.autoPlay = false,
    this.showControls = true,
    this.loop = false,
    this.startSeconds = 0,
  }) : super(key: key);

  @override
  State<AdvancedYouTubePlayer> createState() => _AdvancedYouTubePlayerState();
}

class _AdvancedYouTubePlayerState extends State<AdvancedYouTubePlayer>
    with WidgetsBindingObserver {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  bool isPlaying = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final physicalSize = PlatformDispatcher.instance.views.first.physicalSize;
    if (physicalSize.width > physicalSize.height) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.restoreSystemUIOverlays();
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(_getYouTubeEmbedUrl()),
                ),
                initialSettings: InAppWebViewSettings(
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  useHybridComposition: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  supportMultipleWindows: true,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  // Android specific
                  allowFileAccess: true,
                  allowContentAccess: true,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  setState(() {
                    isLoading = false;
                    errorMessage = 'Error $code: $message';
                  });
                  print('Load error: $code - $message');
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print("Console: ${consoleMessage.message}");
                },
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              if (errorMessage != null && !isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getYouTubeEmbedUrl() {
    final params = <String, String>{
      'autoplay': widget.autoPlay ? '1' : '0',
      'controls': widget.showControls ? '1' : '0',
      'modestbranding': '1',
      'playsinline': '1',
      'rel': '0',
      'fs': '1',
      'enablejsapi': '0', // Disable JS API as it causes issues
    };

    if (widget.loop) {
      params['loop'] = '1';
      params['playlist'] = widget.videoId;
    }

    if (widget.startSeconds > 0) {
      params['start'] = widget.startSeconds.toString();
    }

    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    // Use youtube-nocookie.com domain
    return 'https://www.youtube-nocookie.com/embed/${widget.videoId}?$queryString';
  }
}

class YouTubeHelper {
  static String? extractVideoId(String url) {
    if (url.isEmpty) return null;

    // If it's already just a video ID (11 characters, no special chars)
    if (!url.contains('http') && url.length == 11) {
      return url;
    }

    // Trim whitespace
    url = url.trim();

    // List of regex patterns for different YouTube URL formats
    final patterns = [
      // Standard watch URL
      RegExp(r'(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})'),
      // Shorts URL
      RegExp(r'(?:youtube\.com\/shorts\/)([a-zA-Z0-9_-]{11})'),
      // Short URL
      RegExp(r'(?:youtu\.be\/)([a-zA-Z0-9_-]{11})'),
      // Embed URL
      RegExp(r'(?:youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})'),
      // Music URL
      RegExp(r'(?:music\.youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    return null;
  }

  /// Converts fully qualified YouTube Url to video id.
  ///
  /// If videoId is passed as url then no conversion is done.
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    return extractVideoId(url);
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class AdvancedYouTubePlayer extends StatefulWidget {
//   final String videoId;
//   final bool autoPlay;
//   final bool showControls;
//   final bool loop;
//   final int startSeconds;
//
//   const AdvancedYouTubePlayer({
//     Key? key,
//     required this.videoId,
//     this.autoPlay = false,
//     this.showControls = true,
//     this.loop = false,
//     this.startSeconds = 0,
//   }) : super(key: key);
//
//   @override
//   State<AdvancedYouTubePlayer> createState() => _AdvancedYouTubePlayerState();
// }
//
// class _AdvancedYouTubePlayerState extends State<AdvancedYouTubePlayer> {
//   late YoutubePlayerController _controller;
//   bool _isPlayerReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoId,
//       flags: YoutubePlayerFlags(
//         autoPlay: widget.autoPlay,
//         mute: false,
//         loop: widget.loop,
//         hideControls: !widget.showControls,
//         controlsVisibleAtStart: widget.showControls,
//         enableCaption: true,
//         startAt: widget.startSeconds,
//       ),
//     )..addListener(_listener);
//   }
//
//   void _listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {});
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       onEnterFullScreen: () {
//         SystemChrome.setPreferredOrientations([
//           DeviceOrientation.landscapeLeft,
//           DeviceOrientation.landscapeRight,
//         ]);
//       },
//       onExitFullScreen: () {
//         SystemChrome.setPreferredOrientations([
//           DeviceOrientation.portraitUp,
//         ]);
//       },
//       player: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.red,
//         progressColors: const ProgressBarColors(
//           playedColor: Colors.red,
//           handleColor: Colors.redAccent,
//         ),
//         onReady: () {
//           _isPlayerReady = true;
//         },
//         onEnded: (data) {
//           if (widget.loop) {
//             _controller.seekTo(const Duration(seconds: 0));
//             _controller.play();
//           }
//         },
//       ),
//       builder: (context, player) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             player,
//             if (widget.showControls) _buildCustomControls(),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildCustomControls() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           IconButton(
//             icon: Icon(
//               _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//             ),
//             onPressed: () {
//               setState(() {
//                 _controller.value.isPlaying
//                     ? _controller.pause()
//                     : _controller.play();
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.replay_10),
//             onPressed: () {
//               _controller.seekTo(
//                 Duration(
//                   seconds: _controller.value.position.inSeconds - 10,
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.forward_10),
//             onPressed: () {
//               _controller.seekTo(
//                 Duration(
//                   seconds: _controller.value.position.inSeconds + 10,
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.fullscreen),
//             onPressed: () {
//               _controller.toggleFullScreenMode();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class YouTubeHelper {
//   static String? extractVideoId(String url) {
//     return YoutubePlayer.convertUrlToId(url);
//   }
//
//   static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
//     return YoutubePlayer.convertUrlToId(url);
//   }
// }
