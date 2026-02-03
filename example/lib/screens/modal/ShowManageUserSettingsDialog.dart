import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/SwitchController.dart';
import '../../controller/postjoin_controller.dart';

class ShowManageUserSettingsDialog extends GetView<postjoinController> {
  const ShowManageUserSettingsDialog({super.key});

  // final SwitchController switchcontroller = Get.put(SwitchController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwitchController>(
      builder: (logic) => Scaffold(
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
            child: GetBuilder<Websocket>(
              builder: (websocket) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Manage Users',
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
                    if (websocket.myDetails!.fields!.role == "MODERATOR")
                      Column(
                        children: [
                          SwitchListTile(
                            title: Text(
                              'Mute all users',
                              style: TextStyle(
                                color: logic.switchValueMuteAllUsers
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            secondary: Icon(
                              Icons.person_add_alt,
                              color: logic.switchValueMuteAllUsers
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            activeColor: Colors.white,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            inactiveThumbColor: Colors.white,
                            trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1),
                            ),
                            inactiveTrackColor: const Color.fromRGBO(
                              62,
                              132,
                              102,
                              1,
                            ),
                            value: logic.switchValueMuteAllUsers,
                            onChanged: (newValue) {
                              logic.switchValueMuteAllUsers = newValue;
                              controller.bigbluebuttonsdkPlugin.locksettings(
                                disableMic: newValue,
                              );
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: Text(
                              'Mute all users except presenter',
                              style: TextStyle(
                                color: logic.switchValueMuteExceptPresenter
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            secondary: Image.asset(
                              'assets/image/mute_except.png',
                              package: "govmeeting",
                              color: logic.switchValueMuteExceptPresenter
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            activeColor: Colors.white,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            inactiveThumbColor: Colors.white,
                            trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1),
                            ),
                            inactiveTrackColor: const Color.fromRGBO(
                              62,
                              132,
                              102,
                              1,
                            ),
                            value: logic.switchValueMuteExceptPresenter,
                            onChanged: (newValue) {
                              logic.switchValueMuteExceptPresenter = newValue;
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: Text(
                              'Lock viewers',
                              style: TextStyle(
                                color: logic.switchValueLockViewers
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            secondary: Icon(
                              Icons.lock_open,
                              color: logic.switchValueLockViewers
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            activeColor: Colors.white,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            inactiveThumbColor: Colors.white,
                            trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1),
                            ),
                            inactiveTrackColor: const Color.fromRGBO(
                              62,
                              132,
                              102,
                              1,
                            ),
                            value: logic.switchValueLockViewers,
                            onChanged: (newValue) {
                              logic.switchValueLockViewers = newValue;
                              controller.bigbluebuttonsdkPlugin.locksettings(
                                lockOnJoin: newValue,
                              );
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: Text(
                              'Disable Camera',
                              style: TextStyle(
                                color: logic.switchValuediasblecamera
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            secondary: Icon(
                              Icons.video_camera_back_sharp,
                              color: logic.switchValuediasblecamera
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            activeColor: Colors.white,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            inactiveThumbColor: Colors.white,
                            trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1),
                            ),
                            inactiveTrackColor: const Color.fromRGBO(
                              62,
                              132,
                              102,
                              1,
                            ),
                            value: logic.switchValuediasblecamera,
                            onChanged: (newValue) {
                              logic.switchValuediasblecamera = newValue;
                              controller.bigbluebuttonsdkPlugin.locksettings(
                                disableCam: newValue,
                              );
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: Text(
                              'Diable Public Chat',
                              style: TextStyle(
                                color: logic.switchValuediasablepublicchat
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            secondary: Icon(
                              Icons.lock_open,
                              color: logic.switchValuediasablepublicchat
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            activeColor: Colors.white,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            inactiveThumbColor: Colors.white,
                            trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1),
                            ),
                            inactiveTrackColor: const Color.fromRGBO(
                              62,
                              132,
                              102,
                              1,
                            ),
                            value: logic.switchValuediasablepublicchat,
                            onChanged: (newValue) {
                              logic.switchValuediasablepublicchat = newValue;
                              controller.bigbluebuttonsdkPlugin.locksettings(
                                disablePublicChat: newValue,
                              );
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: Text(
                              'Disable Private Chat',
                              style: TextStyle(
                                color: logic.switchValuedisableprivatechat
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            secondary: Icon(
                              Icons.lock_open,
                              color: logic.switchValuedisableprivatechat
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            activeColor: Colors.white,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            inactiveThumbColor: Colors.white,
                            trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1),
                            ),
                            inactiveTrackColor: const Color.fromRGBO(
                              62,
                              132,
                              102,
                              1,
                            ),
                            value: logic.switchValuedisableprivatechat,
                            onChanged: (newValue) {
                              logic.switchValuedisableprivatechat = newValue;
                              controller.bigbluebuttonsdkPlugin.locksettings(
                                disablePrivateChat: newValue,
                              );
                            },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: Text(
                              'Hide Participant List',
                              style: TextStyle(
                                color: logic.switchValuehideparticipantslist
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            secondary: Icon(
                              Icons.lock_open,
                              color: logic.switchValuehideparticipantslist
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            activeColor: Colors.white,
                            thumbColor: const MaterialStatePropertyAll(
                              Colors.white,
                            ),
                            inactiveThumbColor: Colors.white,
                            trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1),
                            ),
                            inactiveTrackColor: const Color.fromRGBO(
                              62,
                              132,
                              102,
                              1,
                            ),
                            value: logic.switchValuehideparticipantslist,
                            onChanged: (newValue) {
                              logic.switchValuehideparticipantslist = newValue;
                              controller.bigbluebuttonsdkPlugin.locksettings(
                                hideUserList: newValue,
                              );
                            },
                          ),
                        ],
                      )
                    else
                      Container(
                        child: Text(
                          "This page can only be seen by a Moderator",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
