import 'package:bigbluebuttonsdk_example/modules/showschedulemeeting_module/showschedulemeeting_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ShowschedulemeetingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShowschedulemeetingController());
  }
}