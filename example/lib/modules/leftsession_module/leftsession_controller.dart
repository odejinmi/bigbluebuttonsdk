import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../routes/app_pages.dart';
import '../../utils/diorequest.dart';
import '../../utils/strings.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class leftsessionController extends GetxController {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  var _meetingdetails = Rx<Map<String, dynamic>?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  get meetingdetails => _meetingdetails.value;

  var _roomdetails = {}.obs;
  set roomdetails(value) => _roomdetails.value = value;
  get roomdetails => _roomdetails.value;

  final _accesscode = "".obs;
  set accesscode(value) => _accesscode.value = value;
  get accesscode => _accesscode.value;

  final _reason = "".obs;
  set reason(value) => _reason.value = value;
  get reason => _reason.value;

  final _token = "".obs;
  set token(value) => _token.value = value;
  get token => _token.value;

  var _data = {}.obs;
  set data(value) => _data.value = value;
  get data => _data.value;

  @override
  void onInit() {
    var arguments = Get.arguments;
    meetingdetails = arguments["meetingdetails"];
    roomdetails = arguments["roomdetails"];
    accesscode = arguments["accesscode"];
    reason = arguments["reason"];
    token = arguments["token"];
    data = arguments["data"];
    // TODO: implement onInit
    super.onInit();
  }

  final _govmeetingPlugin = Govmeeting();

  void validateMeeting() async {
    // if (nameController.value.text == "") {
    //   showCommonError("Your name can not be empty.");
    //   return;
    // }
    //
    // if (emailController.value.text == "") {
    //   showCommonError("Your email can not be empty.");
    //   return;
    // }

    // isLoading = true;
    var jsonBody = {
      "id": roomdetails["id"],
      "name": meetingdetails["fullname"],
      "email": meetingdetails["externUserID"],
      "access_code": accesscode
    };

    var cmddetails = await Diorequest().post("app/join-room", jsonBody);
    // var cmddetails = await Diorequest().get("start-a-room/$id");

    // isLoading = false;

    if (cmddetails['success']) {
      // meetingurl = cmddetails['data'];
      meetingdetail(cmddetails['sessionToken']);
    } else {
      // isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  void meetingdetail(String webtoken) async {
    try {
      var cmddetails = await Diorequest().get("$entermeetingurl$webtoken");

      if (cmddetails["response"]["returncode"] == "SUCCESS") {
        var result = await _govmeetingPlugin.startmeeting(
            meetingdetails: cmddetails["response"],
            token: webtoken,
            roomdetails: roomdetails,
            baseurl: baseurl,
            context: Get.context!,
            micstatus: false,
            camerastatus: false);
        if (result != null) {
          Get.offNamed(Routes.LEFTSESSION, arguments: {
            "webrtctoken": webtoken,
            "reason": result
                ? "You left the session"
                : "You are kicked out of the session",
            "meetingdetails": cmddetails["response"],
            "roomdetails": roomdetails
          });
        }
        update();
      } else {
        print("start the meeting again");
      }
    } on Exception {}
  }
}
