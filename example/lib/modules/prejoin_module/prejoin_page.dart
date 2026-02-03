import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/strings.dart';
import 'prejoin_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class prejoinPage extends GetView<prejoinController> {
  @override //1234
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    controller.webViewKey = GlobalKey<FormState>();
    // Access the parameter here
    controller.checkForDeepLink();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
      body: Obx(() {
        controller.obj;
        return SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: const Color.fromRGBO(229, 229, 229, 1),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    const Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Setup your audio and video before joining',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter'),
                    ),

                    // Image.asset(
                    // package: "govmeeting",
                    //   "assets/image/Video Tile.jpg",
                    //   fit: BoxFit.cover,
                    //   frameBuilder: (context, child, frame, _) {
                    //     if (frame == null) {
                    //       return child;
                    //     }else {
                    //       return const Center(
                    //         child: CircularProgressIndicator(
                    //           valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    //         ),
                    //       );
                    //     }
                    //   },
                    // ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width - 40,
                      height: controller.isvideo &&
                              controller.cameracontroller != null &&
                              controller
                                      .cameracontroller?.value.isInitialized ==
                                  true
                          ? 320
                          : 264,
                      decoration: BoxDecoration(
                        color: controller.isvideo &&
                                controller.cameracontroller != null &&
                                controller.cameracontroller?.value
                                        .isInitialized ==
                                    true
                            ? Colors.black
                            : Color(0xffB9C9C2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: controller.isvideo
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  // Camera preview without rotation, properly fitted
                                  SizedBox(
                                    width: Get.width - 40,
                                    height: controller.cameracontroller!.value
                                        .previewSize!.height,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width: controller.cameracontroller!
                                            .value.previewSize!.width,
                                        height: controller.cameracontroller!
                                            .value.previewSize!.height,
                                        child: Transform.rotate(
                                          angle: -pi /
                                              2, // Rotate -90 degrees to fix orientation
                                          child: CameraPreview(
                                              controller.cameracontroller!),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // WiFi indicator positioned at bottom left
                                  const Positioned(
                                    bottom: 18,
                                    left: 45,
                                    child: Icon(
                                      Icons.wifi_2_bar_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xff93B3A5),
                                    shape: BoxShape.circle,
                                  ),
                                  width: 144,
                                  height: 144,
                                  child: Center(
                                    child: Text(
                                      generateInitials(controller.username),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text(
                                    controller.username,
                                    style: const TextStyle(
                                      color: Color(0xffF5F9FF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton.filled(
                                onPressed: () {
                                  controller.isaudio = !controller.isaudio;
                                },
                                icon: Icon(
                                  controller.isaudio
                                      ? Icons.mic_off
                                      : Icons.mic,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        controller.isaudio
                                            ? Color(0xffB9C9C2)
                                            : Color(0xff21714B)))),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton.filled(
                                onPressed: () async {
                                  if (GetPlatform.isAndroid ||
                                      GetPlatform.isIOS) {
                                    if (controller.isvideo) {
                                      controller.isvideo =
                                          await controller.closeCamera();
                                    } else {
                                      controller.isvideo =
                                          await controller.startCamera();
                                    }
                                  }
                                },
                                icon: Icon(
                                  !controller.isvideo
                                      ? Icons.videocam_off_outlined
                                      : Icons.video_camera_back_outlined,
                                  size: 32,
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        !controller.isvideo
                                            ? Color(0xffB9C9C2)
                                            : Color(0xff21714B))))
                          ],
                        ),

                        // const Spacer(),
                        // IconButton.filled(onPressed: () {
                        //   settingsDialog();
                        // },
                        //     icon: const Icon(Icons.settings_outlined),
                        //     style: const ButtonStyle(
                        //         backgroundColor: MaterialStatePropertyAll(
                        //             Color.fromRGBO(185, 201, 194, 1))))
                      ],
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(211, 213, 218, 1),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(93, 149, 126, 1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.only(left: 5.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Meeting ID or Meeting Name',
                        ),
                        controller: controller.meetingidController,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(211, 213, 218, 1),
                              border: Border.all(
                                  width: 1,
                                  color: const Color.fromRGBO(93, 149, 126, 1)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Your Name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                style: const TextStyle(color: Colors.black),
                                controller: controller.usernameController,
                                onChanged: (value) {
                                  controller.username = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(211, 213, 218, 1),
                              border: Border.all(
                                  width: 1,
                                  color: const Color.fromRGBO(93, 149, 126, 1)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.only(left: 5.0),
                            child: TextField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'youremail@email.com',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                style: const TextStyle(color: Colors.black),
                                controller: controller.emailController),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Visibility(
                      visible: controller.accesscode,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(211, 213, 218, 1),
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(93, 149, 126, 1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          controller: controller.accesscodeController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            // focusColor: Colors.white,
                            // hoverColor: Colors.white,
                            // fillColor: Colors.white,
                            hintText: "Enter Access code here",
                            border: InputBorder.none,
                            // prefix: !change ? const Text("+(234)") : const Text(""),
                            hintStyle: TextStyle(
                                // color: primarycolour,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                            // suffixIcon: Icon(
                            //   Icons.person_pin_circle_rounded,
                            //   color: Colors.white,
                            // ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(8.0)),
                            //   borderSide: BorderSide(color: Colors.grey),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(8.0)),
                            //   borderSide: BorderSide(color: Colors.grey),
                            // ),
                            // disabledBorder: OutlineInputBorder(
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(8.0)),
                            //   borderSide: BorderSide(color: Colors.grey),
                            // ),
                          ),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              // color: primaryColour,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                          keyboardType: TextInputType.name,
                          onChanged: (value) {},
                          validator: (value) {
                            if (controller.accesscode) {
                              if (value == null) {
                                return "This field can't be empty";
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 176,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xff21714B),
                            // border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (!controller.isLoading &&
                                  controller.formKey.currentState!.validate()) {
                                if (controller.accesscode) {
                                  controller.validateMeeting(
                                      controller.roomdetails['id']);
                                } else {
                                  controller.checkingMeeting();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(62, 132, 102, 1),
                            ),
                            child: Center(
                                child: controller.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Join Meeting',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter'),
                                      )),
                          ),
                        ),
                        // const SizedBox(width: 10,),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  settingsDialog() {
    Get.dialog(
      Scaffold(
        // backgroundColor: const Color.fromRGBO(0, 0, 0, 0.76),
        body: Center(
          child: Container(
            width: 360,
            height: 664,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(62, 132, 102, 1),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter'),
                      ),
                      const SizedBox(
                        width: 180,
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const PreJoin()
                          //     )
                          // );
                        },
                        icon: const Icon(Icons.clear_rounded),
                        iconSize: 24,
                        color: Colors.white,
                        // style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(185, 201, 194, 1)))
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 328,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(93, 149, 126, 1),
                      // border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FilledButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: const Color.fromRGBO(93, 149, 126, 1),
                      ),
                      child: const Center(
                          child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Device Settings',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter'),
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      // barrierLabel: ' Full Screen Dialog',
      transitionDuration: const Duration(milliseconds: 400),
      // AlertDialog(
      //     backgroundColor: Color(0xFF3E8466),
      //     content: Endrecord()
      // )
    );
  }
}
