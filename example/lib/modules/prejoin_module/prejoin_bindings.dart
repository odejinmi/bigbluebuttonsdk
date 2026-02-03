import 'package:get/get.dart';

import 'prejoin_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class prejoinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => prejoinController());
  }
}