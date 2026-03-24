import 'package:get/get.dart';

import 'dashboard_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
