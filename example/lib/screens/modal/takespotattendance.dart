import 'dart:io';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../controller/postjoin_controller.dart';

class Takespotattendance extends GetView<postjoinController> {
  const Takespotattendance({Key? key}) : super(key: key);

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
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Take Spot Attendance',
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
                  Text(
                    'Total Number of SPort Attendees: ${logic.participant.length}',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      await generateAttendanceFile(
                        filePath: await getFilePath(
                          'attendance_${controller.meetingdetails.confname}${DateTime.now().microsecondsSinceEpoch}.txt',
                        ),
                        meetingHost: controller.meetingdetails.confname,
                        meetingDateTime: DateTime.now(),
                        attendees: logic.participant
                            .map((e) => e.fields?.name)
                            .toList(),
                      );
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF5D957E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFF5D957E),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Download (TXT)',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      await generateAttendanceFile(
                        filePath: await getFilePath(
                          'attendance_${controller.meetingdetails.confname}${DateTime.now().microsecondsSinceEpoch}.csv',
                        ),
                        meetingHost: controller.meetingdetails.confname,
                        meetingDateTime: DateTime.now(),
                        attendees: logic.participant
                            .map((e) => e.fields?.name)
                            .toList(),
                      );
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF5D957E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFF5D957E),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Download (CSV)',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getFilePath(String fileName) async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$fileName'; // 3

    return filePath;
  }

  Future<void> generateAttendanceFile({
    required String filePath,
    required String meetingHost,
    required DateTime meetingDateTime,
    required List<String?> attendees,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln(
      'Attendance for the meeting, $meetingHost @ ${meetingDateTime.year}-${meetingDateTime.month}-${meetingDateTime.day} ${meetingDateTime.hour}:${meetingDateTime.minute}:${meetingDateTime.second}\n',
    );
    for (final attendee in attendees) {
      buffer.writeln(' $attendee');
    }
    buffer.writeln('\n\n Auto-Generated from Konn3ct\n\n');
    buffer.writeln(' Total Number of Attendees: ${attendees.length}');

    final file = File(filePath);
    await file.writeAsString(buffer.toString());
  }
}
