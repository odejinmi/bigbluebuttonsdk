import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/utils/meetingresponse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/SwitchController.dart';
import '../../controller/postjoin_controller.dart';

class ShowManageUserSettingsDialog extends GetView<postjoinController> {
  const ShowManageUserSettingsDialog({super.key});

  // final SwitchController switchcontroller = Get.put(SwitchController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Websocket>(
      builder: (logic) {
        LockSettingsProps? lockSettingsProps = logic.meetingResponse?.fields
            .lockSettingsProps;
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
                                  color: lockSettingsProps?.disableMic == true
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              secondary: Icon(
                                Icons.person_add_alt,
                                color: lockSettingsProps?.disableMic == true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeThumbColor: Colors.white,
                              thumbColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: Colors.white,
                              trackColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(93, 149, 126, 1),
                              ),
                              inactiveTrackColor: const Color.fromRGBO(
                                62,
                                132,
                                102,
                                1,
                              ),
                              value: lockSettingsProps?.disableMic == true,
                              onChanged: (newValue) {
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
                                  color: lockSettingsProps?.disableNotes == true
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              secondary: Image.asset(
                                'asset/image/mute_except.png',
                                color: lockSettingsProps?.disableNotes == true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeThumbColor: Colors.white,
                              thumbColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: Colors.white,
                              trackColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(93, 149, 126, 1),
                              ),
                              inactiveTrackColor: const Color.fromRGBO(
                                62,
                                132,
                                102,
                                1,
                              ),
                              value: lockSettingsProps?.disableNotes == true,
                              onChanged: (newValue) {
                                // logic.switchValueMuteExceptPresenter = newValue;
                              },
                            ),
                            const Divider(),
                            SwitchListTile(
                              title: Text(
                                'Lock viewers',
                                style: TextStyle(
                                  color: lockSettingsProps?.lockOnJoin == true
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              secondary: Icon(
                                Icons.lock_open,
                                color: lockSettingsProps?.lockOnJoin == true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeThumbColor: Colors.white,
                              thumbColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: Colors.white,
                              trackColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(93, 149, 126, 1),
                              ),
                              inactiveTrackColor: const Color.fromRGBO(
                                62,
                                132,
                                102,
                                1,
                              ),
                              value: lockSettingsProps?.lockOnJoin == true,
                              onChanged: (newValue) {
                                // logic.switchValueLockViewers = newValue;
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
                                  color: lockSettingsProps?.disableCam == true
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              secondary: Icon(
                                Icons.video_camera_back_sharp,
                                color: lockSettingsProps?.disableCam == true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeThumbColor: Colors.white,
                              thumbColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: Colors.white,
                              trackColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(93, 149, 126, 1),
                              ),
                              inactiveTrackColor: const Color.fromRGBO(
                                62,
                                132,
                                102,
                                1,
                              ),
                              value: lockSettingsProps?.disableCam == true,
                              onChanged: (newValue) {
                                // logic.switchValuediasblecamera = newValue;
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
                                  color: lockSettingsProps?.disablePublicChat ==
                                      true
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              secondary: Icon(
                                Icons.lock_open,
                                color: lockSettingsProps?.disablePublicChat ==
                                    true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeThumbColor: Colors.white,
                              thumbColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: Colors.white,
                              trackColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(93, 149, 126, 1),
                              ),
                              inactiveTrackColor: const Color.fromRGBO(
                                62,
                                132,
                                102,
                                1,
                              ),
                              value: lockSettingsProps?.disablePublicChat ==
                                  true,
                              onChanged: (newValue) {
                                // logic.switchValuediasablepublicchat = newValue;
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
                                  color: lockSettingsProps
                                      ?.disablePrivateChat == true
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              secondary: Icon(
                                Icons.lock_open,
                                color: lockSettingsProps?.disablePrivateChat ==
                                    true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeThumbColor: Colors.white,
                              thumbColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: Colors.white,
                              trackColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(93, 149, 126, 1),
                              ),
                              inactiveTrackColor: const Color.fromRGBO(
                                62,
                                132,
                                102,
                                1,
                              ),
                              value: lockSettingsProps?.disablePrivateChat ==
                                  true,
                              onChanged: (newValue) {
                                // logic.switchValuedisableprivatechat = newValue;
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
                                  color: lockSettingsProps?.hideUserList == true
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              secondary: Icon(
                                Icons.lock_open,
                                color: lockSettingsProps?.hideUserList == true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeThumbColor: Colors.white,
                              thumbColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: Colors.white,
                              trackColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(93, 149, 126, 1),
                              ),
                              inactiveTrackColor: const Color.fromRGBO(
                                62,
                                132,
                                102,
                                1,
                              ),
                              value: lockSettingsProps?.hideUserList == true,
                              onChanged: (newValue) {
                                // logic.switchValuehideparticipantslist = newValue;
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
        );
      });
  }
}
