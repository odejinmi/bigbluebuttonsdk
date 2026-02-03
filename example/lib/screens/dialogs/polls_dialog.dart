import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/PullController.dart';
import '../../controller/postjoin_controller.dart';

// ====================================================================================================================
class PollsDialog extends GetView<PullController> {
  PollsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 510,
            padding:
                const EdgeInsets.only(top: 24, right: 16, bottom: 24, left: 16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(62, 132, 102, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child:
                GetBuilder<postjoinController>(builder: (postjoincontroller) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Polls',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(62, 132, 102, 1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 0.5, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(7.0),
                                border: InputBorder.none,
                                hintText: 'Ask a question',
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value) =>
                                controller.question.value = value,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Column(
                        children: [
                          for (var i = 0; i < controller.options.length; i++)
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            93, 149, 126, 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: TextFormField(
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(7.0),
                                                border: InputBorder.none,
                                                hintText: 'Answer ${i + 1}',
                                                hintStyle: const TextStyle(
                                                    color: Colors.white)),
                                            onChanged: (value) =>
                                                controller.options[i] = value,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (i > 0)
                                  GestureDetector(
                                    onTap: () => controller.removeOption(i),
                                    child: Row(children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        width: 20,
                                        height: 5,
                                      ),
                                    ]),
                                  )
                              ],
                            ),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: controller.addOption,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(
                                top: 12, right: 16, left: 16, bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(93, 149, 126, 1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Add answers',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.question.isNotEmpty &&
                                controller.options.isNotEmpty) {
                              postjoincontroller.bigbluebuttonsdkPlugin
                                  .startpoll(
                                      question: controller.question.value,
                                      options: controller.options);

                              Get.back();
                            } else {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor:
                                      const Color.fromRGBO(62, 132, 102, 1),
                                  icon: const Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  content: const Padding(
                                    padding: EdgeInsets.only(top: 24),
                                    child: Text(
                                      "Ensure to input a question and answer(s).",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        'Got It',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 151,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(93, 149, 126, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                                child: Text(
                              'Publish Polls',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
