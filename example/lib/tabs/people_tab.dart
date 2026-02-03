import 'package:bigbluebuttonsdk/provider/websocket.dart';
import 'package:bigbluebuttonsdk/utils/participant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';

import '../controller/postjoin_controller.dart';
import '../screens/String.dart';
import '../screens/dialogs/chat.dart';
import '../screens/modal/changeroledialog.dart';
import '../screens/modal/removeuserdialog.dart';

class PeopleTab extends GetView<postjoinController> {
  bool videoOn = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Obx(() {
      controller.obj;
      return Scaffold(body: GetBuilder<Websocket>(builder: (logic) {
        return Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            child: logic.meetingResponse?.fields.lockSettingsProps
                        .hideUserList ??
                    false
                ? Text(
                    "Your Participants List has been disabled by the Moderator")
                : Column(children: [
                    // SizedBox(height: screenHeight * 0.01,),

                    const Divider(),

                    SizedBox(
                      height: screenHeight * 0.01,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Participants',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {
                            if (controller
                                .meetingdetails.customdata.isNotEmpty) {
                              Clipboard.setData(ClipboardData(
                                  text: controller.meetingdetails.customdata[0]
                                      ["meetingLink"]));
                              MotionToast.success(
                                title: Text("Meeting Link"),
                                description: Text("Meeting Link copied"),
                              ).show(context);
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.4,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.link,
                                          color: Colors.white),
                                      const VerticalDivider(),
                                      Expanded(
                                        child: Text(
                                            controller.meetingdetails
                                                .customdata[0]["meetingLink"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.035,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              const Icon(Icons.more_vert),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),

                    const Divider(),

                    Flexible(
                      child: ListView.builder(
                          itemCount: logic.participant.length,
                          itemBuilder: (context, index) {
                            var participant = logic.participant[index];
                            return Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Container(
                                  height: 69,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                  ),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment
                                    //     .spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.5,
                                        width: screenWidth * 0.2,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green[900],
                                          child: Text(
                                            generateInitials(
                                                participant.fields!.name!),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                      Expanded(
                                        child: Text(
                                          participant.fields!.name!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            //   setState(() {
                                            //   micOn = true;
                                            // });
                                          },
                                          child:
                                              participant.fields!.muted == true
                                                  ? const Icon(Icons.mic_off,
                                                      color: Colors.green)
                                                  : const Icon(Icons.mic,
                                                      color: Colors.red)),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                      if (participant.rtcVideoRenderer != null)
                                        GestureDetector(
                                            onTap: () {
                                              //   setState(() {
                                              //   videoOn = true;
                                              // });
                                            },
                                            child: videoOn
                                                ? const Icon(
                                                    Icons.videocam_outlined,
                                                    color: Colors.green)
                                                : const Icon(
                                                    Icons.videocam_outlined,
                                                    color: Colors.red)),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                      if (logic.myDetails!.fields!.role ==
                                          "MODERATOR")
                                        PopupMenuButton(
                                            color: const Color.fromRGBO(
                                                93, 149, 126, 1),
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            onSelected: (value) {
                                              if (value == 1) {
                                                _showChangeRoleDialog(
                                                    participant);
                                              } else if (value == 2) {
                                                controller
                                                    .bigbluebuttonsdkPlugin
                                                    .muteauser(
                                                        userid: participant
                                                            .fields!.userId!);
                                                // put function here
                                              } else if (value == 3) {
                                                if (participant
                                                        .fields!.chatId ==
                                                    null) {
                                                  controller
                                                      .bigbluebuttonsdkPlugin
                                                      .createGroupChat(
                                                          participant:
                                                              participant);
                                                }
                                                showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    barrierColor:
                                                        Colors.transparent,
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 400),
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return ChatDialog(
                                                          participant:
                                                              participant);
                                                    });
                                                print(participant.toJson());
                                                // postjoincontroller.chatid = participant.fields!.chatId!;
                                                // postjoincontroller.tabController.animateTo(0);

                                                // put function here
                                              } else if (value == 4) {
                                                _showRemoveUserDialog(
                                                    participant);
                                              }
                                            },
                                            itemBuilder: (BuildContext bc) {
                                              return [
                                                const PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.repeat,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "Change Role",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  onTap: () {},
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.volume_mute,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text("Mute User",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 3,
                                                  onTap: () {},
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .chat_bubble_outline,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text("Private Chat",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 4,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person_remove,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text("Remove User",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  ),
                                                )
                                              ];
                                            })
                                      else if (participant.id !=
                                          controller.bigbluebuttonsdkPlugin
                                              .mydetails!.id)
                                        InkWell(
                                          onTap: () {
                                            if (participant.fields!.chatId ==
                                                null) {
                                              controller.bigbluebuttonsdkPlugin
                                                  .createGroupChat(
                                                      participant: participant);
                                            }
                                            if (logic
                                                    .meetingResponse
                                                    ?.fields
                                                    .lockSettingsProps
                                                    .disablePrivateChat ??
                                                false) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Your Private Chat has been disabled by the Moderator"),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                barrierColor:
                                                    Colors.transparent,
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 400),
                                                pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) {
                                                  return ChatDialog(
                                                      participant: participant);
                                                });
                                            print(participant.toJson());
                                          },
                                          child: Icon(
                                            Icons.chat_bubble_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                              ],
                            );
                          }),
                    )
                  ]));
      }));
    });
  }

  // =============Dialog to Roles of participants=======================
  _showChangeRoleDialog(Participant participan) {
    showGeneralDialog(
        context: Get.context!,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Changeroledialog(participan: participan);
        });
  }

  _showRemoveUserDialog(Participant participan) {
    showGeneralDialog(
        context: Get.context!,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Removeuserdialog(participan: participan);
        });
  }
}
