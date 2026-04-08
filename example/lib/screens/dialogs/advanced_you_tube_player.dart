import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AdvancedYouTubePlayer extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final bool showControls;
  final bool loop;
  final int startSeconds;

  const AdvancedYouTubePlayer({
    super.key,
    required this.videoId,
    this.autoPlay = false,
    this.showControls = true,
    this.loop = false,
    this.startSeconds = 0,
  });

  @override
  State<AdvancedYouTubePlayer> createState() => _AdvancedYouTubePlayerState();
}

class _AdvancedYouTubePlayerState extends State<AdvancedYouTubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        loop: widget.loop,
        hideControls: !widget.showControls,
        startAt: widget.startSeconds,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
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
    );
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
