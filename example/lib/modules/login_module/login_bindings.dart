import 'package:get/get.dart';

import 'login_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class loginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => loginController());
  }
}
