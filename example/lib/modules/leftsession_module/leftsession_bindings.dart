import 'package:get/get.dart';

import 'leftsession_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class leftsessionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => leftsessionController());
  }
}