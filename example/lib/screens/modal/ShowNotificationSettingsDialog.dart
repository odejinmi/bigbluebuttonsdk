import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/SwitchController.dart';

class ShowNotificationSettingsDialog extends GetView<SwitchController> {
  @override
  Widget build(BuildContext context) {
    // return Container();
    return GetBuilder<SwitchController>(
        builder: (_) => Scaffold(
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
                                    color: controller.switchValueJoined
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(Icons.person_add_alt,
                                  color: controller.switchValueJoined
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
                              value: controller.switchValueJoined,
                              onChanged: (newValue) {
                                controller.switchValueJoined = newValue;
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('Leave',
                                  style: TextStyle(
                                    color: controller.switchValueLeave
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
                              value: controller.switchValueLeave,
                              onChanged: (newValue) {
                                controller.switchValueLeave = newValue;
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('New Message',
                                  style: TextStyle(
                                    color: controller.switchValueNewMessage
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(Icons.message_outlined,
                                  color: controller.switchValueNewMessage
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
                              value: controller.switchValueNewMessage,
                              onChanged: (newValue) {
                                controller.switchValueNewMessage = newValue;
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('Hand Raise',
                                  style: TextStyle(
                                    color: controller.isHandRaisedSwitchOn
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(
                                Icons.back_hand_outlined,
                                color: controller.isHandRaisedSwitchOn
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
                              value: controller.isHandRaisedSwitchOn,
                              onChanged: (newValue) {
                                controller.isHandRaisedSwitchOn = newValue;
                              }),
                          const Divider(),
                          SwitchListTile(
                              title: Text('Error',
                                  style: TextStyle(
                                    color: controller.switchValueError
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              secondary: Icon(
                                Icons.error_outline,
                                color: controller.switchValueError
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
                              value: controller.switchValueError,
                              onChanged: (newValue) {
                                controller.switchValueError = newValue;
                              }),
                        ]))))));
  }
}
