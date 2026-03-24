import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'dashboard_controller.dart';
import 'model/empty_tab.dart';
import 'model/invite_history.dart';
import 'model/meeting_recordings.dart';
import 'model/newactivity.dart';

class DashboardPage extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Gov Conference',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff006D43),
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.abc_rounded),
                text: "Meetings",
              ),
              Tab(
                icon: Icon(Icons.clear_all),
                text: "Meeting Logs",
              ),
              Tab(
                icon: Icon(Icons.schedule),
                text: "Invite History",
              ),
              Tab(
                icon: Icon(Icons.record_voice_over),
                text: "Recordings",
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: "Logout",
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                Get.defaultDialog(
                  content: Text('Do you want to Logout?'),
                  onCancel: () => Get.back(),
                  onConfirm: () => Get.offAllNamed(Routes.LOGIN),
                  textConfirm: 'Yes',
                  // textCancel: 'No',
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: Container(
            child: Obx(() {
              controller.obj;
              return TabBarView(
                children: [
                  EmptyTab(),
                  Newactivity(),
                  InviteHistoryPage(),
                  MeetingRecordings()
                ],
              );
            }),
          ),
        ),
        // bottomNavigationBar: const Bottomnavigationbar(
        //   position: 1,
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.PREJOIN, arguments: {
              "token": controller.token,
              "data": controller.data.value,
            });
          },
          // child: Text(
          //   "Join Meeting",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(color: Colors.white, fontSize: 12),
          // ),
          child: Image.asset(
            "asset/image/join_meet.png",
            // height: 50,
            // color: Colors.green,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
