import 'package:bigbluebuttonsdk/provider/websocket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/postjoin_controller.dart';
import '../tabs/chat_tab.dart';
import '../tabs/people_tab.dart';
import '../widget/tab_bar.dart';

class ParticipantScreen extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return DefaultTabController(
      length: controller.tabController.length,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
            title: GetBuilder<Websocket>(builder: (logic) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    logic.meetingDetails!.confname,
                    style: TextStyle(fontSize: screenWidth * 0.05),
                  ),
                  if (controller.bigbluebuttonsdkPlugin.isrecording)
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.fiber_manual_record_outlined,
                          color: Colors.red,
                        ),
                        Text(
                          "REC 00:12:36",
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ],
                    )
                ],
              );
            }),
            titleSpacing: 0.0,
            actions: [
              // InkWell(
              //   onTap: () {
              //     if (controller.meetingdetails.customdata.isNotEmpty) {
              //       Clipboard.setData(ClipboardData(
              //           text: controller.meetingdetails.customdata[0]
              //               ["meetingLink"]));
              //     }
              //   },
              //   child: Row(
              //     children: [
              //       Container(
              //           height: screenHeight * 0.04,
              //           width: screenWidth * 0.35,
              //           decoration: BoxDecoration(
              //               borderRadius:
              //                   const BorderRadius.all(Radius.circular(10)),
              //               border: Border.all(color: Colors.black)),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: [
              //               const Icon(Icons.add_box, color: Colors.green),
              //               Text('Add user to the call',
              //                   style: TextStyle(
              //                       color: Colors.black,
              //                       fontSize: screenWidth * 0.03)),
              //             ],
              //           )),
              //       SizedBox(
              //         width: screenWidth * 0.01,
              //       ),
              //       const Icon(Icons.more_vert),
              //     ],
              //   ),
              // ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight * 0.06),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: Container(
                  height: screenHeight * 0.05,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Color(0xff98A2B3)),
                    color: Colors.white,
                  ),
                  child: GetBuilder<Websocket>(builder: (logic) {
                    return TabBar(
                      controller: controller.tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Color(0xff98A2B3),
                      tabs: [
                        TabItem(title: 'Chat', count: 0),
                        // TabItem(title: 'More', count: 0),
                        TabItem(
                            title: 'People', count: logic.participant.length),
                      ],
                    );
                  }),
                ),
              ),
            )),
        body: TabBarView(
          controller: controller.tabController,
          children: [
            ChatTab(),
            // const Center(child: Text('Group Chat')),
            PeopleTab(),
          ],
        ),
      ),
    );
  }
}
