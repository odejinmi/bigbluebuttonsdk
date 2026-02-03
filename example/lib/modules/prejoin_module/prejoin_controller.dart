import 'package:bigbluebuttonsdk/utils/diorequest.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import '../../routes/app_pages.dart';
import '../../utils/strings.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class prejoinController extends GetxController {
  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final _roomdetails = {}.obs;
  set roomdetails(value) => _roomdetails.value = value;
  get roomdetails => _roomdetails.value;

  final _ismuted = false.obs;
  set ismuted(value) => _ismuted.value = value;
  get ismuted => _ismuted.value;

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _accesscode = false.obs;
  set accesscode(value) => _accesscode.value = value;
  get accesscode => _accesscode.value;

  final _username = "".obs;
  set username(value) => _username.value = value;
  get username => _username.value;

  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var meetingidController = TextEditingController();

  var accesscodeController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var webViewKey = GlobalKey<FormState>();

  final _cameracontroller = Rx<CameraController?>(null);
  set cameracontroller(value) => _cameracontroller.value = value;
  get cameracontroller => _cameracontroller.value;

  final _cameras = <CameraDescription>[].obs;
  set cameras(value) => _cameras.value = value;
  get cameras => _cameras.value;

  // late List<CameraDescription> _cameras;
  Future<void>? initializeControllerFuture;

  var _isvideo = false.obs;
  set isvideo(value) => _isvideo.value = value;
  get isvideo => _isvideo.value;

  var _isaudio = true.obs;
  set isaudio(value) => _isaudio.value = value;
  get isaudio => _isaudio.value;

  final _iswaiting = false.obs;
  set iswaiting(value) => _iswaiting.value = value;
  get iswaiting => _iswaiting.value;

  var _token = ''.obs;
  set token(value) => _token.value = value;
  get token => _token.value;

  var _data = {}.obs;
  set data(value) => _data.value = value;
  get data => _data.value;

  // Helper method to get correct aspect ratio
  double getAspectRatio(var context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final cameraRatio = cameracontroller!.value.aspectRatio;

    // Check if we need to invert the aspect ratio based on orientation
    if (deviceRatio < 1.0) {
      // Portrait mode
      return cameraRatio > 1.0 ? 1.0 / cameraRatio : cameraRatio;
    } else {
      // Landscape mode
      return cameraRatio < 1.0 ? 1.0 / cameraRatio : cameraRatio;
    }
  }

  Future<bool> startCamera() async {
    try {
      // First check if we have camera permission
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          return false;
        }
      }

      // Get available cameras
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint('No cameras found');
        return false;
      }

      // Initialize the camera
      cameracontroller = CameraController(
        cameras.length > 1 ? cameras[1] : cameras[0],
        ResolutionPreset.max,
        enableAudio: isaudio,
      );

      await cameracontroller?.initialize();
      obj = "kjhg";
      update(); // Notify listeners that the state has changed
      return true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint('Camera access was denied');
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            debugPrint('Camera access was denied without prompt');
            break;
          case 'CameraAccessRestricted':
            debugPrint('Camera access is restricted');
            break;
          default:
            debugPrint('Camera error: ${e.description}');
            break;
        }
      }
      return false;
    }
  }

  Future<void> toggleCamera() async {
    if (cameracontroller != null && cameracontroller!.value.isInitialized) {
      await closeCamera();
      isvideo = false;
    } else {
      final success = await startCamera();
      isvideo = success;
    }
    update();
  }

  // Method to close the camera and release resources
  Future<bool> closeCamera() async {
    if (cameracontroller != null) {
      await cameracontroller!.dispose();
      cameracontroller = null;
      update();
      return false;
    } else {
      return true;
    }
  }

  void validateMeeting(int id) async {
    // if (nameController.value.text == "") {
    //   showCommonError("Your name can not be empty.");
    //   return;
    // }
    //
    // if (emailController.value.text == "") {
    //   showCommonError("Your email can not be empty.");
    //   return;
    // }

    isLoading = true;
    // var jsonBody = {
    //   "id": id,
    //   "name": usernameController.text,
    //   "email": emailController.text,
    //   "access_code": accesscodeController.text
    // };

    var jsonBody = {
      "room": roomdetails["name"],
      "name": usernameController.text,
      "email": emailController.text,
      "access_code": accesscodeController.text,
    };

    var cmddetails = await Diorequest().post("app/kv4/join-room", jsonBody);
    // var cmddetails = await Diorequest().get("start-a-room/$id");

    // isLoading = false;

    if (cmddetails['success']) {
      if (cmddetails['wait']) {
        waiting(cmddetails['data']);
        return;
      }
      meetingdetail(cmddetails['data']);
    } else {
      isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  final _govmeetingPlugin = Govmeeting();

  void meetingdetail(String webtoken) async {
    try {
      var cmddetails = await Diorequest().get("$entermeetingurl$webtoken");
      if (cmddetails["response"]["returncode"] == "SUCCESS") {
        if (isvideo) {
          isvideo = await closeCamera();
        }
        accesscode = false;
        var result = await _govmeetingPlugin.startmeeting(
            meetingdetails: cmddetails["response"],
            token: webtoken,
            roomdetails: roomdetails,
            baseurl: baseurl,
            context: Get.context!,
            micstatus: isaudio,
            camerastatus: isvideo);
        print("result from sdk page");
        print(result);
        if (result != null) {
          Get.offAllNamed(Routes.LEFTSESSION, arguments: {
            "accesscode": accesscodeController.text,
            "reason": result
                ? "You left the session"
                : "You are kicked out of the session",
            "meetingdetails": cmddetails["response"],
            "roomdetails": roomdetails,
            "token": token,
            "data": data,
          });
        }
        isLoading = false;
        update();
      } else {
        print("start the meeting again");
      }
    } on Exception {}
  }

  Future<void> waiting(String data) async {
    iswaiting = true;
    var response = await Diorequest().get(
      "https://${baseurl}bigbluebutton/api/guestWait?sessionToken=$data",
    );
    if (response is! Map) {
      meetingdetail(data);
      return;
    }
    if (response["response"]["messageKey"] == "guestWait") {
      Future.delayed(const Duration(seconds: 3), () {
        waiting(data);
      });
    } else if (response["response"]["messageKey"] == "guestDeny") {
      iswaiting = false;
    }
  }

  void checkingMeeting() async {
    isLoading = true;
    var json_body = {
      "name": meetingidController.value.text,
    };

    var cmddetails = await Diorequest().post("app/validate-meeting", json_body);

    if (cmddetails['success']) {
      roomdetails = cmddetails['data'];
      if (cmddetails['access_code']) {
        isLoading = false;
        accesscode = cmddetails['access_code'];
      } else {
        validateMeeting(cmddetails['data']['id']);
      }
    } else {
      isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  void checkForDeepLink() {
    // Read the parameter from the current route state
    final String? meetingId = Get.parameters['id'];

    if (meetingId != null && meetingId != meetingidController.text) {
      print("Joined via redialed link: $meetingId");

      // CRITICAL: Update the EXISTING controller's text, DO NOT reassign the controller variable.
      meetingidController.text = meetingId;

      // If you need the UI to update instantly and it's not bound correctly:
      update(); // Trigger GetBuilder/Obx updates if needed

      // checkingMeeting();
    }
  }

  @override
  void onInit() {
    super.onInit();
    token = Get.arguments == null? "": Get.arguments['token'];
    data = Get.arguments == null? {}: Get.arguments['data']; // Assuming user data is passed in arguments
    // Camera will be initialized when explicitly requested

    if (kDebugMode) {
      username = "videx";
      usernameController = TextEditingController(text: "videx");
      emailController =
          TextEditingController(text: "odejinmiabraham@gmail.com");
      meetingidController = TextEditingController(text: "Tolu");
    }
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose of the controller when the widget is disposed.
    closeCamera();
    usernameController.dispose();
    emailController.dispose();
    meetingidController.dispose();
    accesscodeController.dispose();
    super.onClose();
  }
}
