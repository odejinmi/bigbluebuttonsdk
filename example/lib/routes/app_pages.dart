import 'package:get/get.dart';

import '../modules/dashboard_module/dashboard_bindings.dart';
import '../modules/dashboard_module/dashboard_page.dart';
import '../modules/inderneruser_module/inderneruser_bindings.dart';
import '../modules/inderneruser_module/inderneruser_page.dart';
import '../modules/leftsession_module/leftsession_bindings.dart';
import '../modules/leftsession_module/leftsession_page.dart';
import '../modules/login_module/login_bindings.dart';
import '../modules/login_module/login_page.dart';
import '../modules/prejoin_module/prejoin_bindings.dart';
import '../modules/prejoin_module/prejoin_page.dart';
import '../modules/showschedulemeeting_module/showschedulemeeting_bindings.dart';
import '../modules/showschedulemeeting_module/showschedulemeeting_page.dart';
import '../modules/twofactorauthentication_module/twofactorauthentication_bindings.dart';
import '../modules/twofactorauthentication_module/twofactorauthentication_page.dart';


part './app_routes.dart';
/// GetX Generator - fb.com/htngu.99
///

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.JOINMEETING,
      page: () => prejoinPage(),
      binding: prejoinBinding(),
    ),
    GetPage(
      name: Routes.PREJOIN,
      page: () => prejoinPage(),
      binding: prejoinBinding(),
    ),
    GetPage(
      name: Routes.LEFTSESSION,
      page: () => leftsessionPage(),
      binding: leftsessionBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => loginPage(),
      binding: loginBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.TWOFACTORAUTHENTICATION,
      page: () => twofactorauthenticationPage(),
      binding: twofactorauthenticationBinding(),
    ),
    GetPage(
      name: Routes.SHOWSCHEDULEMEETING,
      page: () => ShowschedulemeetingPage(),
      binding: ShowschedulemeetingBinding(),
    ),
    GetPage(
      name: Routes.INDERNERUSER,
      page: () => inderneruserPage(),
      binding: inderneruserBinding(),
    ),
  ];
}
