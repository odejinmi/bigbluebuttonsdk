import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/diorequest.dart';
import '../../utils/strings.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class twofactorauthenticationController extends GetxController {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  var _emailSelected = true.obs;
  set emailSelected(value) => _emailSelected.value = value;
  get emailSelected => _emailSelected.value;

  var _argument = {}.obs;
  set argument(value) => _argument.value = value;
  get argument => _argument.value;

  var _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  List<FocusNode> focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  Future<void> verifyOtp() async {
    if (otpControllers.every((controller) => controller.text.isEmpty)) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }
    if (isLoading) return;
    isLoading = true;
    var data = {
      "tenantId": argument["tenantId"],
      "username": argument["username"],
      "otpCode": otpControllers.map((controller) => controller.text).join(),
      "authType": emailSelected ? "EMAIL" : "GOVOTP"
    };
    var cmddetails = await Diorequest().post("app/1gov/login/2fa", data);
    isLoading = false;
    print(cmddetails);
    if (cmddetails["success"] == true) {
      var data = cmddetails["data"];
      Get.toNamed('/dashboard', arguments: data);
    } else {
      showErrorSnackbar(
          'Error', cmddetails['message']??'Failed to verify OTP');
    }
  }

  void resendOtp() async {
    if (isLoading) return;
    isLoading = true;
    var data = {
      "tenantId": argument['tenantId'],
      "username": argument['username'],
      "password": argument['password'],
    };
    var cmddetails = await Diorequest().post("app/1gov/login", data);
    isLoading = false;
    if (cmddetails["success"] == true) {

    } else {
      showErrorSnackbar(
          'Error', 'Failed to resend OTP due to ${cmddetails['message']}');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    argument = Get.arguments;
    emailSelected = argument["twoFactorMedium"] == "EMAIL";
  }

  Future<void> downloadOtpApp() async {
    final Uri uri = Uri.parse('https://play.google.com/store/apps/details?id=com.onegoveauthenticator');
    if (await canLaunchUrl(uri)) {
    await launchUrl(uri,
    mode: LaunchMode.externalApplication);
    }
  }
}
