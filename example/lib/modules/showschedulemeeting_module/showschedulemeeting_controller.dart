import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_timezone/timezone_info.dart';

import '../../utils/Roomlistparser.dart';
import '../../utils/diorequest.dart';
import '../../utils/strings.dart';
import '../dashboard_module/model/internal_user.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ShowschedulemeetingController extends GetxController{

  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;


  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final guestsController = TextEditingController();
  final messageController = TextEditingController();
  final additionalController = TextEditingController();
  var _fromDateTime = DateTime.now().obs;
  set fromDateTime(value) => _fromDateTime.value = value;
  DateTime get fromDateTime => _fromDateTime.value;

  var _toDateTime = DateTime.now().add(const Duration(hours: 1)).obs;
  set toDateTime(value) => _toDateTime.value = value;
  DateTime get toDateTime => _toDateTime.value;

  var internalUsers = <InternalUser>[].obs;


  var _token = ''.obs;
  set token(value) => _token.value = value;
  get token => _token.value;

  var _roomid = 0.obs;
  set roomid(value) => _roomid.value = value;
  get roomid => _roomid.value;
  var data = {}.obs;

  @override
  void onInit() {
    super.onInit();
    token = Get.arguments['token'];
    data.value = Get.arguments['data']; // Assuming user data is passed in arguments
    roomid = Get.arguments['roomid']; // Assuming user data is passed in arguments
  }


  void scheduleMeeting() async {
    isLoading.value = true;
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');

    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();

    var json_body = {
      "room_id": roomid,
      "hostname": "${data['lastname']} ${data['firstname']}",
      "fromtime": timeFormat.format(fromDateTime),
      "totime": timeFormat.format(toDateTime),
      "guest": guestsController.text,
      "message": messageController.text,
      "title": titleController.text,
      "timezone": '${currentTimeZone.identifier ?? 'Unknown'} - ${currentTimeZone.localizedName?.name ?? 'Unknown'}',
      "additional": additionalController.text,
      "date": dateFormat.format(fromDateTime),
    };

    var cmddetails =
    await Diorequest().post("app/invite", json_body);

    isLoading.value = false;
    dev.log("Schedule meeting response: ${cmddetails.toString()}");

    if (cmddetails['success']) {
      showSuccessSnackbar("Success", cmddetails['message']);
    } else {
      String errorMessage = "An unknown error occurred.";
      if (cmddetails['error'] != null) {
        errorMessage = (cmddetails['error'] as List).join('\n');
      } else if(cmddetails['message'] != "No internet connection") {
        errorMessage = cmddetails['message'];
      }
      showErrorSnackbar("Error", errorMessage);
    }
  }
}
