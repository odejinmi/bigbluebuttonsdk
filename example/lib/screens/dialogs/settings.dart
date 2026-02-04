import 'package:flutter/material.dart';

import '../modal/ShowDeviceSettingsDialog.dart';
import '../modal/ShowManageUserSettingsDialog.dart';
import '../modal/ShowNotificationSettingsDialog.dart';
import '../modal/howLayoutSettingsDialog.dart';
import '../modal/waitingroom.dart';

class SettingsFlow extends StatefulWidget {
  const SettingsFlow({super.key});

  @override
  State<SettingsFlow> createState() => _SettingsFlowState();
}

class _SettingsFlowState extends State<SettingsFlow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 400,
          height: 670,
          padding: const EdgeInsets.only(
            top: 24,
            right: 16,
            bottom: 24,
            left: 16,
          ),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(62, 132, 102, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    iconSize: 24,
                    color: Colors.white,
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Get.back();
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.transparent,
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const ShowDeviceSettingsDialog();
                      });
                },
                child: Container(
                  height: 56,
                  width: 358,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    // color: Color.fromRGBO(93, 149, 126, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Device Settings',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  showNotificationSettingsDialog();
                },
                child: Container(
                  height: 56,
                  width: 358,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    // color: Color.fromRGBO(93, 149, 126, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Notifications',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 30),
              // GestureDetector(
              //   onTap: () {
              //     showLayoutSettingsDialog();
              //   },
              //   child: Container(
              //     height: 56,
              //     width: 358,
              //     padding: const EdgeInsets.all(16),
              //     decoration: const BoxDecoration(
              //       // color: Color.fromRGBO(93, 149, 126, 1),
              //       borderRadius: BorderRadius.all(Radius.circular(8)),
              //     ),
              //     child: Center(
              //       child: Row(
              //         children: [
              //           Image.asset(
              //             'asset/image/layout_icon.png',
              //             package: "govmeeting",
              //           ),
              //           const SizedBox(width: 10),
              //           const Text(
              //             'Layout',
              //             style: TextStyle(color: Colors.white, fontSize: 16),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  showManageUserSettingsDialog();
                },
                child: Container(
                  height: 56,
                  width: 358,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    // color: Color.fromRGBO(93, 149, 126, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.people_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Manage Users',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  showWaitingRoomSettingsDialog();
                },
                child: Container(
                  height: 56,
                  width: 358,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    // color: Color.fromRGBO(93, 149, 126, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Image.asset(
                          'asset/image/person_wait.png',
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Waiting Room',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 30),
              // GestureDetector(
              //   onTap: () {
              //     showGeneralDialog(
              //       context: context,
              //       barrierDismissible: false,
              //       barrierColor: Colors.transparent,
              //       transitionDuration: const Duration(milliseconds: 400),
              //       pageBuilder: (context, animation, secondaryAnimation) {
              //         return Takespotattendance();
              //       },
              //     );
              //   },
              //   child: Container(
              //     height: 56,
              //     width: 358,
              //     padding: const EdgeInsets.all(16),
              //     decoration: const BoxDecoration(
              //       // color: Color.fromRGBO(93, 149, 126, 1),
              //       borderRadius: BorderRadius.all(Radius.circular(8)),
              //     ),
              //     child: Center(
              //       child: Row(
              //         children: [
              //           Image.asset(
              //             'asset/image/take_spot.png',
              //             package: "govmeeting",
              //           ),
              //           const SizedBox(width: 10),
              //           const Text(
              //             'Take Spot Attendance',
              //             style: TextStyle(color: Colors.white, fontSize: 16),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // showDeviceSettingsDialog(){
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierColor: Colors.transparent,
  //     transitionDuration: const Duration(milliseconds: 400),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return const ShowDeviceSettingsDialog();
  //     }
  //   );
  // }
  //
  showNotificationSettingsDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return ShowNotificationSettingsDialog();
        });
  }

  showManageUserSettingsDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const ShowManageUserSettingsDialog();
        });
  }

  showLayoutSettingsDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const ShowLayoutSettingsDialog();
        });
  }

  showWaitingRoomSettingsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Waitingroom();
      },
    );
  }
}
