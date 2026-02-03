import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';

class ShareScreenDialog extends StatelessWidget {
  const ShareScreenDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.65),
        body: Center(
          child: GetBuilder<postjoinController>(builder: (controller) {
            return Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Everything on your screen, including \nnotifications, will be recorded. Enable Do Not \nDisturb to prevent unexpected notifications.',
                  style:
                      TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 120,
                ),
                Container(
                  width: 310,
                  height: 96,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(30, 30, 30, 0.75),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.radio_button_checked,
                            color: Colors.white, size: 30),
                        Text(
                          'Screen Broadcast',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 310,
                  height: 46,
                  padding: const EdgeInsets.only(
                      top: 11, right: 16, left: 16, bottom: 11),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.screen_share_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Onegov Screen Share',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          )
                        ],
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 310,
                  padding: const EdgeInsets.only(
                      top: 11, right: 16, left: 16, bottom: 11),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return Checkbox(
                          value: controller.isshareaudio,
                          onChanged: (value) {
                            controller.isshareaudio = value;
                          },
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                        );
                      }),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "share your device's audio \nThe mute button stops sharing audio and turn's off your mic",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      )
                    ],
                  ),
                ),
                GetBuilder<Websocket>(builder: (websocket) {
                  return SizedBox(
                    width: 310,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (websocket.remoteRTCVideoRenderer.srcObject !=
                            null) {
                          controller.bigbluebuttonsdkPlugin.stopscreenshare();
                        } else {
                          Get.back();
                          // var result = await startForegroundService();
                          // if (result) {
                          controller.bigbluebuttonsdkPlugin
                              .startscreenshare(controller.isshareaudio);

                          // }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        backgroundColor: const Color.fromRGBO(30, 30, 30, 0.75),
                      ),
                      child: const Center(
                          child: Text(
                        'Start Broadcast',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter'),
                      )),
                    ),
                  );
                })
              ],
            );
          }),
        ));
  }
}
