import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';

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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        iconSize: 24,
                        color: Colors.white,
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromRGBO(62, 132, 102, 1)))
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