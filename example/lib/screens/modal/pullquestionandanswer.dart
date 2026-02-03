import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/PullController.dart';

class Pullquestionandanswer extends GetView<PullController> {
  final Map<dynamic, dynamic> json;

  const Pullquestionandanswer({Key? key, required this.json}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Obx(
        () {
          var list = controller.bigbluebuttonsdkPlugin.participant.where((v) {
            return v.fields!.userId! == json["requester"];
          }).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(62, 132, 102, 1),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(62, 132, 102, 1),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hide Polls',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9800000190734863),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(62, 132, 102, 1),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Polls',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Created by ${list[0].fields!.name!}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            json["fields"]["question"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        for (var i = 0;
                            i < json["fields"]["answers"].length;
                            i++)
                          Obx(() {
                            return GestureDetector(
                              onTap: () {
                                controller.selectedOption =
                                    json["fields"]["answers"][i];
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                      93,
                                      149,
                                      126,
                                      1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: json["fields"]["answers"][i] ==
                                              controller.selectedOption
                                          ? Colors.white
                                          : const Color.fromRGBO(
                                              93,
                                              149,
                                              126,
                                              1,
                                            ),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      json["fields"]["answers"][i]["key"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (controller.selectedOption.isNotEmpty) {
                              controller.ispulling = false;
                              controller.bigbluebuttonsdkPlugin.votepoll(
                                poll_id: json["fields"]["id"],
                                selectedOptionId:
                                    controller.selectedOption["id"].toString(),
                              );
                              Get.back();
                              if (controller.bigbluebuttonsdkPlugin.mydetails!
                                  .fields!.presenter!) {
                              } else {
                                controller.bigbluebuttonsdkPlugin.ispolling =
                                    false;
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              height: 48,
                              width: 151,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(93, 149, 126, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: controller.selectedOption.isNotEmpty
                                      ? Colors.white
                                      : Color.fromRGBO(93, 149, 126, 1),
                                  width: 0.5,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Vote',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
