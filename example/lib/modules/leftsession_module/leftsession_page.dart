import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'leftsession_controller.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class leftsessionPage extends GetView<leftsessionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'asset/image/govsupport_logo.png',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromRGBO(62, 132, 102, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(),
              const SizedBox(
                height: 60,
              ),
              Image.asset(
                'asset/image/yellow_hand_icon.png',
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                controller.reason,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Have a nice day, ${controller.meetingdetails["fullname"]}',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Return to Dashboard?',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      // controller.validateMeeting();
                      Get.offAllNamed(Routes.DASHBOARD, arguments: {"token": controller.token,"data": controller.data});
                    },
                    child: Container(
                        height: 48,
                        width: 111,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(93, 149, 126, 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'asset/image/leave_icon.png',
                              ),
                              const Text('Return',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ))),
                  ),
                ],
              ),
              const SizedBox(
                height: 250,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        height: 48,
                        width: 174,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: const Center(
                            child: Text('Send Feedback',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                    child: Container(
                        height: 48,
                        width: 194,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: const Center(
                            child: Text('Return to Login Screen',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
