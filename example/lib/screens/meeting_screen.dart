import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/postjoin_controller.dart';
import 'floatingscreen.dart';
import 'fullmeetingscreen.dart';
import 'modal/endroom.dart';
import 'modal/leavesession.dart';
// import 'package:govmail/tabs/people_tab.dart';

class MeetingScreen extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.obj;
      return PopScope(
        canPop: !controller
            .hasUnsavedChanges, // Prevents popping if unsaved changes exist
        onPopInvoked: (didPop) async {
          if (!didPop && controller.hasUnsavedChanges) {
            Get.dialog(AlertDialog(
              backgroundColor: Color(0xFF3E8466),
              content: controller.bigbluebuttonsdkPlugin.mydetails != null &&
                      controller
                              .bigbluebuttonsdkPlugin.mydetails!.fields!.role ==
                          "MODERATOR"
                  ? Endroom()
                  : Leavesession(),
            ));
          }
        },
        child: Center(
          child: GetPlatform.isAndroid
              ? PiPSwitcher(
                  childWhenDisabled: Scaffold(
                    body: Fullmeetingscreen(),
                    // floatingActionButtonLocation:
                    //     FloatingActionButtonLocation.centerFloat,
                    // floatingActionButton: FutureBuilder<bool>(
                    //   future: controller.floating.isPipAvailable,
                    //   initialData: false,
                    //   builder: (context, snapshot) => snapshot.data ?? false
                    //       ? Column(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: [
                    //             FloatingActionButton.extended(
                    //               onPressed: () => controller.enablePip(),
                    //               label: const Text('Enable PiP'),
                    //               icon: const Icon(Icons.picture_in_picture),
                    //             ),
                    //             const SizedBox(height: 12),
                    //             FloatingActionButton.extended(
                    //               onPressed: () =>
                    //                   controller.enablePip(autoEnable: true),
                    //               label:
                    //                   const Text('Enable PiP on app minimize'),
                    //               icon: const Icon(Icons.auto_awesome),
                    //             ),
                    //           ],
                    //         )
                    //       : const Card(
                    //           child: Text('PiP unavailable'),
                    //         ),
                    // ),
                  ),
                  childWhenEnabled: Floatingscreen(),
                )
              : Fullmeetingscreen(),
        ),
      );
    });
  }
}
