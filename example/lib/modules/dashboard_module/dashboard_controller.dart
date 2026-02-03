import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:bigbluebuttonsdk/utils/diorequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../main.dart';
import '../../routes/app_pages.dart';
import '../../utils/InviteHistory.dart' as invite_history_model;
import '../../utils/Meetinghistory.dart';
import '../../utils/Roomlistparser.dart';
import '../../utils/strings.dart';

class DashboardController extends GetxController {
  var appVersion = ''.obs;
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  var _token = ''.obs;
  set token(value) => _token.value = value;
  get token => _token.value;
  
  var data = {}.obs;

  var isLoading = false.obs;
  var hasError = false.obs;
  var meetingController = TextEditingController().obs;
  // ;
  var _originList = <Roomlistparser>[].obs;
  set originList(value) => _originList.value = value;
  List<Roomlistparser> get originList => _originList.value;

  var validated = false.obs;

  var recordingList = [].obs;
  var inviteHistory = Rx<invite_history_model.InviteHistory?>(null);

  final _govmeetingPlugin = Govmeeting();
  final _appLinks = AppLinks();

  List<Meetinghistoryparser> historyList = [];
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    token = Get.arguments['token'];
    data.value = Get.arguments['data']; // Assuming user data is passed in arguments
    _handleIncomingLinks();
    onRefresh(); // Initial data fetch
    getAppVersion();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      print("Received URI: $uri"); // Added for debugging
      if (uri != null &&
          uri.pathSegments.length == 3 &&
          uri.pathSegments[0] == 'conferencing' &&
          uri.pathSegments[1] == 'join') {
        final meetingId = uri.pathSegments[2];
        final room = <String, dynamic>{
          "id": meetingId,
          "name": "Meeting from link"
        };
        print("Starting meeting with ID: $meetingId"); // Added for debugging
        Meetingstart(room);
      }
    }, onError: (Object err) {
      print('onLinkError: $err');
    });
  }

  Future<void> _fetchmeetingHistory() async {
    // isLoading.value = true;

    var cmddetails = await Diorequest().get("meeting-history", token: token);

    // print(cmddetails);
    isLoading.value = false;
    if (cmddetails['success']) {
      historyList =
          meetinghistoryparserFromJson(json.encode(cmddetails['data']));
      // _region = cmddetails['data'];
    } else {
      if (cmddetails['message'] != "No internet connection") {
        // showCommonError(cmddetails['message'], context);
      }
    }
  }

  Future<void> _fetchHistory() async {
    isLoading.value = true;

    var cmddetails = await Diorequest().get("list-rooms", token: token);

    isLoading.value = false;
    if (cmddetails['success']) {
      originList = roomlistparserFromJson(json.encode(cmddetails['data']));
    } else {
      if (cmddetails['message'] != "No internet connection") {
        // showCommonError(cmddetails['message'], context);
      }
    }
  }

  Future<void> _fetchinviteHistory() async {
    isLoading.value = true;

    var cmddetails = await Diorequest().get("app/invites", token: token);

    isLoading.value = false;
    if (cmddetails['success']) {
      inviteHistory.value = invite_history_model.InviteHistory.fromJson(cmddetails['data']);
    } else {
      if (cmddetails['message'] != "No internet connection") {
        // showCommonError(cmddetails['message'], context);
      }
    }
  }

  void Meetingstart(Map<String, dynamic> room) async {
    isLoading.value = true;

    var cmddetails =
        await Diorequest().get("start-a-room/${room['id']}", token: token);

    isLoading.value = false;
    print(cmddetails);
    if (cmddetails['success']) {
      // meetingdetail(cmddetails['sessionToken'], room);
      meetingdetail(cmddetails['url'].toString().split("=").last, room);
    } else {
      if (cmddetails['message'] != "No internet connection") {
        // Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  void validateMeeting() async {

    isLoading.value = true;

  }

  void meetingdetail(String webtoken, Map<String, dynamic> roomdetails) async {
    print("meeting detail");
    print(webtoken);
    try {
      var cmddetails =
          await Diorequest().get("$entermeetingurl$webtoken", token: token);
      print(cmddetails);
      if (cmddetails["response"]["returncode"] == "SUCCESS") {
        var result = await _govmeetingPlugin.startmeeting(
            meetingdetails: cmddetails["response"],
            token: webtoken,
            roomdetails: roomdetails,
            baseurl: baseurl,
            context: Get.context!,
            micstatus: true,
            camerastatus: false);
        print("result from sdk page");
        print(result);
        if (result != null) {
          Get.offAllNamed(Routes.LEFTSESSION, arguments: {
            "accesscode": "",
            "reason": result,
            "meetingdetails": cmddetails["response"],
            "roomdetails": roomdetails,
            "token": token,
            "data": data.value,
          });
          isLoading.value = false;
        }
        update();
      } else {
        print("start the meeting again");
      }
    } on Exception {}
  }

  void createMeeting() async {
    isLoading.value = true;
    var json_body = {
      "name": meetingController.value.text,
      "logout_url": "",
      "welcome_message": ""
    };
    var cmddetails =
        await Diorequest().post("create-room", json_body, token: token);
    meetingController.value.clear();

    isLoading.value = false;

    if (cmddetails['success']) {
      _fetchHistory();
      showSuccessSnackbar("Success", cmddetails['message']);
    } else {
      if (cmddetails['message'] != "No internet connection") {
        showErrorSnackbar("Error", cmddetails['message']);
      }
    }
  }
  
  void scheduleMeeting({
    required Roomlistparser roomData,
    required String title,
    required String guests, // Expects comma-separated emails
    required DateTime fromDateTime,
    required DateTime toDateTime,
    String? message,
    String? additional,
    required String timezone,
    required String hostname,
  }) async {
    isLoading.value = true;
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('HH:mm');

    var json_body = {
      "room_id": roomData.id,
      "hostname": hostname,
      "fromtime": timeFormat.format(fromDateTime),
      "totime": timeFormat.format(toDateTime),
      "guest": guests,
      "message": message ?? "",
      "title": title,
      "timezone": timezone,
      "additional": additional ?? "",
      "date": dateFormat.format(fromDateTime),
    };

    var cmddetails =
        await Diorequest().post("app/invite", json_body, token: token);

    isLoading.value = false;
    dev.log("Schedule meeting response: ${cmddetails.toString()}");

    if (cmddetails['success']) {
      showSuccessSnackbar("Success", cmddetails['message']);
      _fetchinviteHistory(); // Refresh the history list
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

  Future<void> onRefresh() async {
    await Future.wait([
      _fetchHistory(),
      _fetchinviteHistory(),
      fetchRecordings(),
      _fetchmeetingHistory(),
    ]);
  }

  Future<void> fetchRecordings() async {
    isLoading.value = true;
    var cmddetails = await Diorequest().get("rooms-recordings", token: token);

    isLoading.value = false;

    if (cmddetails['success']) {
      recordingList.value = cmddetails['data'];
      recordingList.value = recordingList.reversed.toList();
    } else {
      if (cmddetails['message'] != "No internet connection") {
        // showCommonError(cmddetails['message'], context);
      }
    }
  }

  void onLogin() {
    Get.toNamed(Routes.PREJOIN, arguments: {
      "token": token,
    });
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    appVersion.value = "Version: $version ($buildNumber)";
  }
}
