import 'dart:ui';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PullController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var _ispulling = false.obs; // variable to track card visibility
  set ispulling(value) => _ispulling.value = value;
  get ispulling => _ispulling.value;

  var _selectedOption = {}.obs;
  set selectedOption(value) => _selectedOption.value = value;
  get selectedOption => _selectedOption.value;

  var _pullresult = {}.obs;
  set pullresult(value) => _pullresult.value = value;
  get pullresult => _pullresult.value;

  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();

  var _lastPollId = "".obs;
  set lastPollId(value) => _lastPollId.value = value;
  get lastPollId => _lastPollId.value;

  var question = ''.obs;
  var options = ['Option 1'].obs;

  void addOption() {
    options.add('Option ${options.length + 1}');
  }

  Map<String, dynamic> mergeData(Map<String, dynamic> incomingData) {
    incomingData.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          pullresult[key] is Map<String, dynamic>) {
        // Recursively merge if both are maps
        pullresult[key] = mergeData(value);
      } else if (key != "id") {
        // Add or replace the value
        pullresult[key] = value;
      }
    });
    return pullresult;
  }

  void removeOption(int i) {
    options.removeAt(i);
  }

// =====================================================================================================================================================================================
  void showPollsResultsDialog(
      {required String question, required List<String> options}) {
    Get.generalDialog(
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          final List<int> votes = [50, 30, 15]; // Example votes for each option
          late final totalVotes = votes.reduce((a, b) =>
              a + b); // add all the votes to give the total number of votes
          late final List<double> percentages =
              votes.map((vote) => (vote / totalVotes) * 100).toList();
          late final sortedOptions = List<String>.from(options)
            ..sort((a, b) =>
                votes[options.indexOf(b)].compareTo(votes[options.indexOf(a)]));
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Scaffold(
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
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Polls',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Created by Femi Williams',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                question,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Flexible(
                                child: ListView.builder(
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30.0),
                                        child: LinearPercentIndicator(
                                          width: 210,
                                          //width for progress bar
                                          animation: true,
                                          //animation to show progress at first
                                          animationDuration: 1000,
                                          lineHeight: 50.0,
                                          //height of progress bar
                                          percent: percentages[index] / 100,
                                          // 30/100 = 0.3
                                          center: Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                '${percentages[index].toStringAsFixed(0)}%',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                sortedOptions[index],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          barRadius: const Radius.circular(8),
                                          progressColor: const Color.fromRGBO(
                                              93, 148, 126, 1),
                                          //percentage progress bar color
                                          backgroundColor: Colors
                                              .transparent, //background progressbar color
                                        ),
                                      );
                                    })),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '$totalVotes votes of ${totalVotes + 50}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))));
        });
  }
}
