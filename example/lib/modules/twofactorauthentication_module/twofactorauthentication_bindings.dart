import 'package:get/get.dart';

import 'twofactorauthentication_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class twofactorauthenticationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => twofactorauthenticationController());
  }
}
