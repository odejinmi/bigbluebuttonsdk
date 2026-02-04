import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';
import 'advanced_you_tube_player.dart';

class Cinema extends StatefulWidget {
  const Cinema({super.key});

  @override
  State<Cinema> createState() => _CinemaState();
}

class _CinemaState extends State<Cinema> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: GetBuilder<postjoinController>(builder: (postjoincontroller) {
          return Container(
            width: double.infinity,
            height: 350,
            padding:
                const EdgeInsets.only(top: 10, right: 10, bottom: 20, left: 10),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(62, 132, 102, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        padding: const EdgeInsets.only(left: 10),
                        onPressed:() {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        iconSize: 24,
                        color: Colors.white,
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(62, 132, 102, 1)))
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Add link',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  width: 343,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(93, 149, 126, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(2.0),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(7.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                InkWell(
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      postjoincontroller.bigbluebuttonsdkPlugin
                          .sendecinema(videourl: _controller.text);
                      Get.back();
                      // Get.to(ShowVideoScreen(videoLink: _controller.text));
                    }
                  },
                  child: Container(
                    width: 151,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(93, 149, 126, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                        child: Text(
                      'Broadcast',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ShowVideoScreen extends StatefulWidget {
  final String videoLink;
  final bool ishowecinema;

  const ShowVideoScreen({
    super.key,
    required this.videoLink,
    required this.ishowecinema,
  });

  @override
  State<ShowVideoScreen> createState() => _ShowVideoScreenState();
}

class _ShowVideoScreenState extends State<ShowVideoScreen> {

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

  String? videoId;

  @override
  void initState() {
    super.initState();
    // Usage
    videoId = YouTubeHelper.extractVideoId(
      widget.videoLink,
    );
    print("Extracted video ID: $videoId");
    //     if (videoId != null) {
    // // Use the video ID
    //       AdvancedYouTubePlayer(videoId: videoId);
    //     }
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
            child: AdvancedYouTubePlayer(videoId: videoId!, autoPlay: true),
          );
        },
      ),

      /// Stop Broadcast Button
      floatingActionButton: GetBuilder<postjoinController>(
        builder: (postjoincontroller) {
          return postjoincontroller
              .bigbluebuttonsdkPlugin
              .mydetails!
              .fields!
              .role ==
              "MODERATOR"
              ? Align(
            alignment: const Alignment(1, -0.75),
            child: InkWell(
              onTap: () {
                _showEndBroadcastDialog();
              },
              child: Container(
                width: 151,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
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

  @override
  void dispose() {
    super.dispose();
  }

  /// Show end broadcast dialog=======================================
  _showEndBroadcastDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: GetBuilder<postjoinController>(
              builder: (postjoincontroller) {
                return Container(
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
                              'asset/image/caution.png',
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
                                postjoincontroller.bigbluebuttonsdkPlugin
                                    .endecinema();
                              },
                              child: Container(
                                height: 48,
                                width: 151,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(204, 82, 95, 1),
                                  borderRadius: const BorderRadius.all(
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
