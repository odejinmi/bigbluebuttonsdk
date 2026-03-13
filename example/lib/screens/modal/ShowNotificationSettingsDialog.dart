import 'package:bigbluebuttonsdk/provider/websocket.dart';
import 'package:bigbluebuttonsdk/utils/meetingresponse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/SwitchController.dart';
import '../../controller/postjoin_controller.dart';

class ShowNotificationSettingsDialog extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    // return Container();
    return GetBuilder<Websocket>(
        builder: (logic) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: 400,
                    height: 670,
                    padding: const EdgeInsets.only(
                        top: 24, right: 16, bottom: 24, left: 16),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(62, 132, 102, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                    ),
                    child: Obx(() => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Settings',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
                          const SizedBox(
                            height: 20,
                          ),
                          SwitchListTile(
                              title: Text('Joined',
                                  style: TextStyle(
                                    color: logic.notificationSettingsProps.joined == true
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(Icons.person_add_alt,
                                  color: logic.notificationSettingsProps.joined == true
                                      ? Colors.white
                                      : Colors.grey),
                              activeColor: Colors.white,
                              thumbColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              inactiveThumbColor: Colors.white,
                              trackColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(93, 149, 126, 1)),
                              inactiveTrackColor:
                                  const Color.fromRGBO(62, 132, 102, 1),
                              value: logic.notificationSettingsProps.joined == true,
                              onChanged: (newValue) {
                                logic.notificationSettingsProps = logic.notificationSettingsProps.copyWith(
                                    joined: newValue);
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('Leave',
                                  style: TextStyle(
                                    color: logic.notificationSettingsProps.leave == true
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              // secondary: Icon(Icons.room, color: Colors.white),
                              activeColor: Colors.white,
                              thumbColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              inactiveThumbColor: Colors.white,
                              trackColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(93, 149, 126, 1)),
                              inactiveTrackColor:
                                  const Color.fromRGBO(62, 132, 102, 1),
                              value: logic.notificationSettingsProps.leave == true,
                              onChanged: (newValue) {
                                logic.notificationSettingsProps = logic.notificationSettingsProps.copyWith(
                                    leave: newValue);
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('New Message',
                                  style: TextStyle(
                                    color: logic.notificationSettingsProps.newMessage == true
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(Icons.message_outlined,
                                  color: logic.notificationSettingsProps.newMessage == true
                                      ? Colors.white
                                      : Colors.grey),
                              activeColor: Colors.white,
                              thumbColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              inactiveThumbColor: Colors.white,
                              trackColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(93, 149, 126, 1)),
                              inactiveTrackColor:
                                  const Color.fromRGBO(62, 132, 102, 1),
                              value: logic.notificationSettingsProps.newMessage == true,
                              onChanged: (newValue) {
                                logic.notificationSettingsProps = logic.notificationSettingsProps.copyWith(
                                    newMessage: newValue);
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('Hand Raise',
                                  style: TextStyle(
                                    color: logic.notificationSettingsProps.handRaise == true
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(
                                Icons.back_hand_outlined,
                                color: logic.notificationSettingsProps.handRaise == true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeColor: Colors.white,
                              thumbColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              inactiveThumbColor: Colors.white,
                              trackColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(93, 149, 126, 1)),
                              inactiveTrackColor:
                                  const Color.fromRGBO(62, 132, 102, 1),
                              value: logic.notificationSettingsProps.handRaise == true,
                              onChanged: (newValue) {
                                logic.notificationSettingsProps = logic.notificationSettingsProps.copyWith(
                                    handRaise: newValue);
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('Error',
                                  style: TextStyle(
                                    color: logic.notificationSettingsProps.error == true
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(
                                Icons.error_outline,
                                color: logic.notificationSettingsProps.error == true
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              activeColor: Colors.white,
                              thumbColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              inactiveThumbColor: Colors.white,
                              trackColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(93, 149, 126, 1)),
                              inactiveTrackColor:
                                  const Color.fromRGBO(62, 132, 102, 1),
                              value: logic.notificationSettingsProps.error == true,
                              onChanged: (newValue) {
                                logic.notificationSettingsProps = logic.notificationSettingsProps.copyWith(
                                    error: newValue);
                              }
                          ),
                    ]))
                )
            )
        )
    );
  }
}
