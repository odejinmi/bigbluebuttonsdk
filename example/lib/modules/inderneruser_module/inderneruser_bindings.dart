import 'package:get/get.dart';

import 'inderneruser_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class inderneruserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => inderneruserController());
  }
}