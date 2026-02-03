import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/diorequest.dart';
import '../../utils/strings.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class loginController extends GetxController {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  var _obscureText = true.obs;
  set obscureText(value) => _obscureText.value = value;
  get obscureText => _obscureText.value;

  var _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  var tenantId = TextEditingController();
  var username = TextEditingController();
  var password = TextEditingController();

  final box = GetSecureStorage();

  var _biometric = true.obs;
  set biometric(value) => _biometric.value =value;
  get biometric => _biometric.value;

  var _appVersion = "1.0.0".obs;
  set appVersion(value) => _appVersion.value =value;
  get appVersion => _appVersion.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (kDebugMode) {
      tenantId.text = "konnectsandbox";
      username.text = "odejinmisa@newwavesecosystem.com";
      password.text = "827xazLF6TBfD7N!";
      // tenantId.text = "Govtest";
      // username.text = "Chinwuba.okafor@cicod.com";
      // password.text = "F@nt@stiC18";
    } else {
      print("Fetch storage ${box.read('tenantId')}");
      tenantId.text = box.read('tenantId') ?? '';
      username.text = box.read('username') ?? '';
    }
    getAppVersion();
  }
//100032919, 1000326033, 1000326034, 1000326035
  //Fetches and sets the app version and build number
  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    appVersion = "Version: $version ($buildNumber)";
  }

  void login() async {
    if (tenantId.text.isEmpty ||
        username.text.isEmpty ||
        password.text.isEmpty) {
      showErrorSnackbar('Error', 'All fields are required');
      return;
    }
    if (isLoading) return;
    isLoading = true;
    var data = {
      "tenantId": tenantId.text,
      "username": username.text,
      "password": password.text,
    };
    var cmddetails = await Diorequest().post("app/1gov/login", data);
    isLoading = false;
    if (cmddetails["success"] == true) {
      box.write('tenantId', tenantId.text);
      box.write('username', username.text);
      box.write('password', password.text);

      if (cmddetails.containsKey("twoFactorAuth") &&
          cmddetails["twoFactorAuth"] == true) {
        var twoFactorMedium = cmddetails["twoFactorMedium"];
        var twoFactorMediums = cmddetails["twoFactorMediums"];
        Get.toNamed('/twofactorauthentication', arguments: {
          "twoFactorMedium": twoFactorMedium,
          "twoFactorMediums": twoFactorMediums,
          "username": username.text,
          "tenantId" : tenantId.text,
          "password" : password.text
        });
      } else {
        var data = cmddetails["data"];
        Get.offAllNamed('/dashboard',
            arguments: {"data": data, "token": cmddetails["token"]});
      }
    } else {
      showErrorSnackbar(
          'Error', 'Failed to login due to ${cmddetails['message']}');
    }
  }


  void checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      // Snackbar.showMessage('error biome trics $e');
    }
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = [];
      try {
        availableBiometrics = await auth.getAvailableBiometrics();
      } catch (e) {}

      if (availableBiometrics.isNotEmpty) {
        availableBiometrics.forEach((ab) {});
      } else {}

      bool authenticated = false;
      try {
        authenticated = await auth.authenticate(
          localizedReason: "Place your finger on the censor to login".tr,
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } catch (e) {}
      if (authenticated) {
        tenantId.text = box.read('tenantId');
        username.text = box.read('username');
        password.text = box.read('password');
        login();
      }
    }
  }
}
