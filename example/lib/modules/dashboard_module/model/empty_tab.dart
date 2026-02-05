import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/Roomlistparser.dart';
import '../../../utils/emptytransaction.dart';
import '../../../utils/strings.dart';
import '../dashboard_controller.dart';
import 'show_schedule_meeting.dart';

class EmptyTab extends GetView<DashboardController> {
  const EmptyTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Text("Meetings"),
                          const SizedBox(
                            width: 10,
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       _showCreateMeetingDialog(context);
                          //     },
                          //     icon: const Icon(
                          //       Icons.add,
                          //       color: Colors.black,
                          //     ))
                        ],
                      ),
                      controller.isLoading.isTrue
                          ? loadingWidget2
                          : Expanded(
                              child: controller.originList.isEmpty
                                  ? const Emptytransaction(
                                      desc: "Your rooms is empty",
                                    )
                                  : SingleChildScrollView(
                                      physics: const ClampingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          for (int i = 0;
                                              i < controller.originList.length;
                                              i++)
                                            GestureDetector(
                                              child: item1(
                                                  controller.originList[i],
                                                  false,
                                                  context),
                                              onTap: () async {
                                                if (Platform.isIOS) {
                                                  controller.Meetingstart(
                                                    controller.originList[i]
                                                        .toJson(),
                                                    // context
                                                  );
                                                } else {
                                                  if (await Permission
                                                              .microphone
                                                              .request()
                                                              .isGranted &&
                                                          await Permission
                                                              .camera
                                                              .request()
                                                              .isGranted //&&
                                                      //await Permission.storage
                                                      //  .request()
                                                      //        .isGranted
                                                      ) {
                                                    controller.Meetingstart(
                                                      controller.originList[i]
                                                          .toJson(),
                                                      // context
                                                    );
                                                  } else {
                                                    // requestPermission();
                                                  }
                                                }
                                              },
                                            ),
                                        ],
                                      ))),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget item1(Roomlistparser name, on, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Image.asset(
            "asset/image/conference_logo.webp",
            height: 39,
            width: 39,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat('MMM dd, yyyy hh:mm a').format(name.createdAt),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showScheduleMeetingDialog(context, name);
            },
            child: Icon(Icons.calendar_month_sharp),
          ),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            onPressed: () async {
              if (Platform.isIOS) {
                controller.Meetingstart(
                  name.toJson(),
                  // context
                );
              } else {
                if (await Permission.microphone.request().isGranted &&
                        await Permission.camera.request().isGranted //&&
                    //await Permission.storage
                    //  .request()
                    //        .isGranted
                    ) {
                  controller.Meetingstart(
                    name.toJson(),
                    // context
                  );
                } else {
                  // requestPermission();
                }
              }
            },
            child: Icon(Icons.video_call),
          ),
        ],
      ),
    );
  }

  void _showCreateMeetingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Create New Meeting",
              textAlign: TextAlign.center,
            ),
            content: TextFormField(
              textAlign: TextAlign.start,
              controller: controller.meetingController.value,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: "Enter meeting name",
                hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600),
              ),
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
              keyboardType: TextInputType.emailAddress,
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text("Create"),
                onPressed: () {
                  controller.createMeeting();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _showScheduleMeetingDialog(
      BuildContext context, Roomlistparser roomData) {

    showDialog(
        context: context,
        builder: (context) {
          return ShowScheduleMeeting(roomData: roomData,);
        });
  }
}
