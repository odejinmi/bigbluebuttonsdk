import 'dart:async';
import 'dart:convert';

import 'package:bigbluebuttonsdk/utils/meetingdetails.dart';
import 'package:bigbluebuttonsdk_example/routes/app_pages.dart';
import 'package:bigbluebuttonsdk_example/screens/meeting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

import 'controller/postjoin_controller.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetSecureStorage.init(
      password: '928w7tfg2esanhsyus98e7yiteg2e2qssdw342q');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const PreJoin(),
      theme: ThemeData(
        primaryColor: const Color(0xFF2E8B57), // Forest green color
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E8B57)),
        useMaterial3: true,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all(true),
          trackVisibility: MaterialStateProperty.all(true),
          thickness: MaterialStateProperty.all(15.0),
          radius: const Radius.circular(30),
          thumbColor: MaterialStateProperty.all(
              const Color.fromRGBO(255, 255, 255, 0.71)),
          trackColor:
              MaterialStateProperty.all(const Color.fromRGBO(51, 125, 93, 1)),
          // trackBorderColor: MaterialStateProperty.all(Colors.white),
          // minThumbLength: 60,
          mainAxisMargin: 130,
          crossAxisMargin: 10,
          interactive: true,
        ),
      ),
      initialRoute: Routes.LOGIN,
      getPages: AppPages.pages,
    );
  }
}

class Govmeeting {

  Future<dynamic> startmeeting({
    required Map<dynamic, dynamic> meetingdetails,
    required String token,
    required String baseurl,
    required Map<dynamic, dynamic> roomdetails,
    required BuildContext context,
    required bool micstatus,
    required bool camerastatus,
  }) async {
    postjoinController pollscontroller = Get.put(postjoinController());
    pollscontroller.webrtctoken = token;
    pollscontroller.roomdetails = roomdetails;
    pollscontroller.baseurl = baseurl;
    pollscontroller.meetingdetails =
        meetingdetailsFromJson(jsonEncode(meetingdetails));
    await pollscontroller.startroom();

    if (camerastatus) {
      pollscontroller.bigbluebuttonsdkPlugin.startcamera();
    }
    if (!micstatus) {
      pollscontroller.bigbluebuttonsdkPlugin.mutemyself();
    }
    pollscontroller.iscamera = camerastatus;
    // Get.offAll(MeetingScreen());
    var response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => MeetingScreen(),
    );
    // Get.delete<postjoinController>();
    return response;
  }
}