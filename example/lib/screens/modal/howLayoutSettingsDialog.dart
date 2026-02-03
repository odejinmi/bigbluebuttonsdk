import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/SwitchController.dart';

class ShowLayoutSettingsDialog extends GetView<SwitchController> {
  const ShowLayoutSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: 400,
                height: 670,
                padding: const EdgeInsets.only(top: 24, right: 20, left: 20),
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
                            'Appearance',
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

                      SwitchListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: Text('Active Speaker Mode',
                              style: TextStyle(
                                color: controller.switchValueActiveSpeaker
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          activeColor: Colors.white,
                          thumbColor:
                              const MaterialStatePropertyAll(Colors.white),
                          inactiveThumbColor: Colors.white,
                          trackColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(93, 149, 126, 1)),
                          inactiveTrackColor:
                              const Color.fromRGBO(62, 132, 102, 1),
                          value: controller.switchValueActiveSpeaker,
                          onChanged: (newValue) {
                            controller.switchValueActiveSpeaker = newValue;
                          }),
                      const Divider(),

                      SwitchListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: Text('Audio Only Mode',
                              style: TextStyle(
                                color: controller.switchValueAudioOnly
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          secondary: Icon(Icons.person_add_alt,
                              color: controller.switchValueAudioOnly
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
                          value: controller.switchValueAudioOnly,
                          onChanged: (newValue) {
                            controller.switchValueAudioOnly = newValue;
                          }),
                      const Divider(),

                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        title: Text('Change Layout',
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            'Maximum tiles to display within the window',
                            style: TextStyle(color: Colors.white70)),
                      ),

                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        // contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        // dense:true,
                        title: const Text('Smart layout',
                            style: TextStyle(color: Colors.white)),
                        trailing: Radio(
                          fillColor:
                              const MaterialStatePropertyAll(Colors.white),
                          activeColor: Colors.white,
                          value: 1,
                          groupValue: controller.selectedRadioValue,
                          onChanged: (value) {
                            controller.selectedRadioValue = value!;
                          },
                        ),
                      ),

                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text('Focus on video',
                            style: TextStyle(color: Colors.white)),
                        trailing: Radio(
                          fillColor:
                              const MaterialStatePropertyAll(Colors.white),
                          activeColor: Colors.white,
                          value: 2,
                          groupValue: controller.selectedRadioValue,
                          onChanged: (value) {
                            controller.selectedRadioValue = value!;
                          },
                        ),
                      ),

                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text('Focus on presentation',
                            style: TextStyle(color: Colors.white)),
                        trailing: Radio(
                          fillColor:
                              const MaterialStatePropertyAll(Colors.white),
                          activeColor: Colors.white,
                          value: 3,
                          groupValue: controller.selectedRadioValue,
                          onChanged: (value) {
                            controller.selectedRadioValue = value!;
                          },
                        ),
                      ),

                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: const Text('Focus on presenter',
                            style: TextStyle(color: Colors.white)),
                        trailing: Radio(
                          fillColor:
                              const MaterialStatePropertyAll(Colors.white),
                          activeColor: Colors.white,
                          value: 4,
                          groupValue: controller.selectedRadioValue,
                          onChanged: (value) {
                            controller.selectedRadioValue = value!;
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 40,
                                width: 167,
                                // padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(color: Colors.white)),
                                child: const Center(
                                    child: Text('Update Everyone',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)))),
                          ),
                        ],
                      ),
                      const Divider(),

                      const ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        title: Text('Tiles in view (6)',
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            'Maximum tiles to display within the window',
                            style: TextStyle(color: Colors.white70)),
                      ),

                      // Row(
                      //   children: [
                      //     const Icon(Icons.grid_view_sharp, color: Colors.white),
                      //
                      //     Slider(
                      //       value: switchcontroller.sliderValue.value,
                      //       min: 0,
                      //       max: 100,
                      //       divisions: 25,
                      //       onChanged: (double newValue) {
                      //         switchcontroller.toggleSlider(newValue);
                      //       },
                      //       activeColor: Colors.white, // Sets the color of the active track
                      //       inactiveColor: Colors.grey, // Sets the color of the inactive track
                      //     ),
                      //
                      //     // const Icon(Icons., color: Colors.white),
                      //   ],
                      // ),
                    ])))));
  }
}
