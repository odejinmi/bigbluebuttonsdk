import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../controller/PullController.dart';
import '../../controller/postjoin_controller.dart';

class Pollsresult extends GetView<PullController> {
  const Pollsresult({Key? key}) : super(key: key);

  String calculate(pollanalyseparser, index) {
    if (pollanalyseparser.answers[index].numVotes == null) {
      return (100 / controller.pullresult["answers"].length)
          .toStringAsFixed(2);
    } else {
      return ((pollanalyseparser.answers[index].numVotes /
                  pollanalyseparser?.numResponders) *
              100)
          .toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: GetBuilder<postjoinController>(builder: (postjoincontroller) {
        final List<int> votes = [
          50,
          30,
          15,
          67,
          90
        ]; // Example votes for each option
        // optionVoteValue
        late final sortedOptions = List<Map<dynamic, dynamic>>.from(
            controller.pullresult["answers"])
          ..sort((a, b) =>
              votes[controller.pullresult["answers"].indexOf(b)]
                  .compareTo(votes[
                      controller.pullresult["answers"].indexOf(a)]));
        return Obx(() {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 400,
                    height: 510,
                    padding: const EdgeInsets.only(
                        top: 24, right: 16, bottom: 24, left: 16),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(62, 132, 102, 1),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Polls',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              controller.pullresult["question"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          // Use Expanded instead of Flexible here for the ListView.builder
                          ListView.builder(
                            shrinkWrap: true,
                            // Ensures ListView takes only necessary space
                            physics: const NeverScrollableScrollPhysics(),
                            // Disables scrolling
                            itemCount: controller
                                .pullresult["answers"].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: LinearPercentIndicator(
                                  animation: true,
                                  animationDuration: 1000,
                                  lineHeight: 50.0,
                                  percent: double.parse(calculate(
                                          postjoincontroller
                                              .bigbluebuttonsdkPlugin
                                              .pollanalyseparser,
                                          index)) /
                                      100,
                                  center: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Text(
                                        '${calculate(postjoincontroller.bigbluebuttonsdkPlugin.pollanalyseparser, index)}%',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          sortedOptions[index]["key"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  barRadius: const Radius.circular(8),
                                  progressColor:
                                      const Color.fromRGBO(93, 148, 126, 1),
                                  backgroundColor: Colors.transparent,
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${postjoincontroller.bigbluebuttonsdkPlugin.pollanalyseparser?.numResponders ?? 0} votes of ${postjoincontroller.bigbluebuttonsdkPlugin.pollanalyseparser?.numRespondents ?? (postjoincontroller.bigbluebuttonsdkPlugin.participant.length - 1)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         Get.back();
                          //       },
                          //       child: Container(
                          //         width: 100,
                          //         height: 32,
                          //         decoration: BoxDecoration(
                          //           color:
                          //               const Color.fromRGBO(93, 149, 126, 1),
                          //           borderRadius: BorderRadius.circular(8),
                          //           border: Border.all(color: Colors.white),
                          //         ),
                          //         child: const Center(
                          //           child: Text(
                          //             'Edit',
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 30),
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         width: 32,
                          //         height: 32,
                          //         decoration: BoxDecoration(
                          //           color:
                          //               const Color.fromRGBO(93, 149, 126, 1),
                          //           borderRadius: BorderRadius.circular(15),
                          //           border: Border.all(color: Colors.white),
                          //         ),
                          //         child: const Center(
                          //           child:
                          //               Icon(Icons.stop, color: Colors.white),
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 20),
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         width: 32,
                          //         height: 32,
                          //         decoration: BoxDecoration(
                          //           color:
                          //               const Color.fromRGBO(93, 149, 126, 1),
                          //           borderRadius: BorderRadius.circular(15),
                          //           border: Border.all(color: Colors.white),
                          //         ),
                          //         child: const Center(
                          //           child: Icon(Icons.play_arrow,
                          //               color: Colors.white),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         Get.back();
                          //         // Handle end poll/publish action
                          //       },
                          //       child: Container(
                          //         width: 151,
                          //         height: 48,
                          //         decoration: BoxDecoration(
                          //           color: const Color.fromRGBO(204, 82, 95, 1),
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: const Center(
                          //           child: Text(
                          //             'End Poll/Publish',
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  )));
        });
      }),
    );
  }
}
