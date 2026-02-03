import 'dart:ui';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk_example/screens/participants_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';

import '../controller/postjoin_controller.dart';
import 'String.dart';
import 'drawer.dart';
import 'modal/ShowDeviceSettingsDialog.dart';
import 'modal/endroom.dart';
import 'modal/leavesession.dart';
import 'modal/share_screen_card.dart';
import 'modal/share_screen_dialog.dart';

class Fullmeetingscreen extends GetView<postjoinController> {
  const Fullmeetingscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.scaffoldKey = GlobalKey<ScaffoldState>();
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final manyscreensize = (screenWidth / 2) - 26;
    return Obx(() {
      return Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.meetingdetails.confname,
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
                      "REC ${controller.bigbluebuttonsdkPlugin.recordingtime}",
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                  ],
                )
            ],
          ),
          actions: [
            GetBuilder<Websocket>(builder: (logic) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (controller.scaffoldKey.currentState!.isDrawerOpen) {
                        controller.scaffoldKey.currentState!.closeEndDrawer();
                      } else {
                        if (logic.meetingResponse?.fields.lockSettingsProps
                                .hideUserList ??
                            false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Your Participants List has been disabled by the Moderator",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        // controller.scaffoldKey.currentState!.openEndDrawer();
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            barrierColor: Colors.transparent,
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return ParticipantScreen();
                            });
                        controller.tabController.animateTo(1);
                      }
                      // Navigator.push(context,
                      //   MaterialPageRoute<void>(
                      //     builder: (BuildContext context) => const PeopleTab(),
                      //   ),
                      // );
                    },
                    child: GetBuilder<Websocket>(builder: (logic) {
                      return Container(
                          height: screenHeight * 0.04,
                          width: screenWidth * 0.17,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.black)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.people),
                              Text((logic.participant.length).toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.038)),
                            ],
                          ));
                    }),
                  ),
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (controller.scaffoldKey.currentState!.isDrawerOpen) {
                          // controller.scaffoldKey.currentState!.closeEndDrawer();
                        } else {
                          if (logic.meetingResponse?.fields.lockSettingsProps
                                  .disablePublicChat ??
                              false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Your Public Chat has been disabled by the Moderator",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.transparent,
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return ParticipantScreen();
                              });
                          // controller.scaffoldKey.currentState!.openEndDrawer();
                        }
                        // print('pressed chat button');
                      },
                      child: const Icon(Icons.chat_outlined)),
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                ],
              );
            }),
          ],
        ),
        // endDrawer: ParticipantScreen(),
        drawer: const DrawerComp(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // SizedBox(width: screenWidth * 2,),
              Expanded(
                child: Stack(
                  children: [
                    GetBuilder<Websocket>(builder: (logic) {
                      if (logic.remoteRTCVideoRenderer.srcObject != null) {
                        if (logic.isMeSharing) {
                          return ShareScreenCard();
                        } else {
                          return RTCVideoView(logic.remoteRTCVideoRenderer);
                        }
                      } else if (controller.iswhiteboard) {
                        controller.presentationcontroller.slideposition =
                            logic.currentSlide["fields"]["num"];
                        if (logic.presentationModel.isNotEmpty &&
                            controller.presentationcontroller.selecttoupload
                                .name.isEmpty) {
                          var selectedFile = logic.presentationModel.where((v) {
                            return v.fields!.current == true;
                          }).toList();

                          if (selectedFile.isNotEmpty) {
                            controller.presentationcontroller.selecttoupload =
                                PlatformFile(
                              name: selectedFile.last.fields!.name!,
                              size: 0,
                            );
                          } else {
                            // Handle case where no item is found, if necessary
                            print(
                                "No presentation model with current == true found.");
                          }
                        }
                        // controller
                        //     .selecttoupload = PlatformFile(name: logic.presentationmodel.where((v){return v.fields!.current == true;}).toList()[0].fields.name, size: 0);
                        return controller.bigbluebuttonsdkPlugin.whiteboard();
                      } else {
                        var participants = logic.participant;
                        if (participants.length <= 2) {
                          return ListView.builder(
                            itemCount: participants.length,
                            itemBuilder: (BuildContext context, int index) =>
                                _buildParticipantWidget(
                                    participants[index], 342, 285),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: (participants.length + 1) ~/ 2,
                            // Adjust the item count to account for pairing
                            itemBuilder: (BuildContext context, int index) {
                              // Odd number of participants, the first participant uses a larger size
                              if (participants.length % 2 == 1 && index == 0) {
                                Participant participant = participants[0];
                                return _buildParticipantWidget(
                                    participant, 342, 285);
                              } else {
                                // Handle pairs of participants
                                int firstIndex = participants.length % 2 == 1
                                    ? 1 + (index - 1) * 2
                                    : index * 2;
                                int secondIndex = firstIndex + 1;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildParticipantWidget(
                                        participants[firstIndex],
                                        manyscreensize,
                                        manyscreensize),
                                    if (secondIndex < participants.length)
                                      _buildParticipantWidget(
                                          participants[secondIndex],
                                          manyscreensize,
                                          manyscreensize),
                                  ],
                                );
                              }
                            },
                          );
                        }
                      }
                    }),

                    Positioned(
                      right: screenWidth * 0.045,
                      top: screenHeight * 0.02,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (controller.meetingdetails.customdata.isNotEmpty)
                            InkWell(
                              onTap: () {
                                if (controller
                                    .meetingdetails.customdata.isNotEmpty) {
                                  Clipboard.setData(ClipboardData(
                                      text: controller.meetingdetails
                                          .customdata[0]["meetingLink"]));
                                  MotionToast.success(
                                    title: Text("Meeting Link"),
                                    description: Text("Meeting Link copied"),
                                  ).show(context);
                                }
                              },
                              child: Container(
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.link,
                                          color: Colors.green),
                                      const Divider(color: Colors.white),
                                      Expanded(
                                        child: Text(
                                            controller.meetingdetails
                                                .customdata[0]["meetingLink"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.037,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                    ],
                                  )),
                            ),
                          if (controller.bigbluebuttonsdkPlugin.isrecording)
                            SizedBox(
                              width: screenWidth * 0.03,
                            ),
                          if (controller.bigbluebuttonsdkPlugin.isrecording)
                            Container(
                                height: screenHeight * 0.04,
                                width: screenWidth * 0.24,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.camera,
                                        color: Colors.green),
                                    Text(
                                        controller.bigbluebuttonsdkPlugin
                                            .recordingtime,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.037)),
                                  ],
                                )),
                        ],
                      ),
                    ),

                    // Positioned(
                    //     right: screenWidth * 0.04,
                    //     bottom: screenHeight * 0.135,
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.grey[600],
                    //       child: const Icon(
                    //         Icons.more_horiz, color: Colors.white,),
                    //     )
                    // ),

                    // Positioned(
                    //   right: screenHeight * 0.02,
                    //   bottom: screenHeight * 0.03,
                    //   child: Container(
                    //     width: screenWidth * 0.84,
                    //     height: screenHeight * 0.09,
                    //     padding: const EdgeInsets.only(left: 12, right: 12,),
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey[600],
                    //       borderRadius: const BorderRadius.all(
                    //           Radius.circular(12)),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         const Icon(Icons.waves, color: Colors.white),
                    //         SizedBox(width: 10,),
                    //         Expanded(
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text('Now', style: TextStyle(color: Colors.white,
                    //                   fontSize: screenHeight * 0.017),),
                    //               Text(
                    //                 'Thank you everyone for joining the design criteque meeting',
                    //                 style: TextStyle(color: Colors.white,
                    //                     fontSize: screenHeight * 0.017),),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // SizedBox(height: screenHeight * 0.02,),
              GetBuilder<Websocket>(builder: (logic) {
                var participants = logic.participant;
                return logic.remoteRTCVideoRenderer.srcObject != null ||
                        controller.iswhiteboard
                    ? SizedBox(
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: participants.length,
                            itemBuilder: (context, index) {
                              return _buildParticipantWidget(
                                  participants[index], 123, 123);
                            }),
                      )
                    : SizedBox();
              }),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            // height: screenHeight * 0.13,
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: GetBuilder<Websocket>(builder: (websocket) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.bigbluebuttonsdkPlugin.mydetails != null &&
                      controller.bigbluebuttonsdkPlugin.mydetails!.fields!
                          .presenter! &&
                      websocket.remoteRTCVideoRenderer.srcObject == null)
                    InkWell(
                      onTap: () {
                        if (websocket.remoteRTCVideoRenderer.srcObject !=
                            null) {
                          controller.bigbluebuttonsdkPlugin.stopscreenshare();
                        } else {
                          Get.dialog(
                            BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: ShareScreenDialog()),
                            barrierDismissible: false,
                            barrierColor: Colors.transparent,
                            transitionDuration:
                                const Duration(milliseconds: 400),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[600],
                        child: const Icon(
                          Icons.screen_share_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      if (controller.bigbluebuttonsdkPlugin.mydetails?.fields
                              ?.raiseHand ==
                          false) {
                        controller.bigbluebuttonsdkPlugin.raiseHand();
                      } else {
                        controller.bigbluebuttonsdkPlugin.lowerHand();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: controller.bigbluebuttonsdkPlugin
                                  .mydetails?.fields?.raiseHand ==
                              false
                          ? Color(0xffCC525F)
                          : Colors.grey[600],
                      child: const Icon(
                        Icons.back_hand,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.dialog(AlertDialog(
                        backgroundColor: Color(0xFF3E8466),
                        content: controller.bigbluebuttonsdkPlugin.mydetails !=
                                    null &&
                                controller.bigbluebuttonsdkPlugin.mydetails!
                                        .fields!.role ==
                                    "MODERATOR"
                            ? Endroom()
                            : Leavesession(),
                      ));
                    },
                    child: SizedBox(
                      width: screenHeight * 0.07,
                      height: screenHeight * 0.07,
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (websocket.meetingResponse?.fields.lockSettingsProps
                                  .disableCam ??
                              false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Your Camera has been disabled by the Moderator",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          controller.iscamera = !controller.iscamera;
                          if (controller.bigbluebuttonsdkPlugin.isvideo) {
                            controller.bigbluebuttonsdkPlugin.stopcamera();
                          } else {
                            controller.bigbluebuttonsdkPlugin.startcamera();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: !controller.iscamera
                              ? Color(0xffCC525F)
                              : Colors.grey[600],
                          child: Icon(
                            !controller.iscamera
                                ? Icons.videocam_off
                                : Icons.video_camera_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if(controller.iscamera)
                      InkWell(
                          child: Icon(Icons.more_vert),
                        onTap: (){
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.transparent,
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return const ShowDeviceSettingsDialog();
                              });
                        },
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      if (websocket.meetingResponse?.fields.lockSettingsProps
                              .disableMic ??
                          false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Your Microphone has been disabled by the Moderator",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      controller.bigbluebuttonsdkPlugin.mutemyself();
                    },
                    child: CircleAvatar(
                      backgroundColor: controller.bigbluebuttonsdkPlugin
                                  .mydetails?.fields?.muted ==
                              true
                          ? Color(0xffCC525F)
                          : Colors.grey[600],
                      child: Icon(
                        controller.bigbluebuttonsdkPlugin.mydetails?.fields
                                    ?.muted ==
                                true
                            ? Icons.mic_off
                            : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            })),
      );
    });
  }

  // Helper function to build the participant widget
  Widget _buildParticipantWidget(
      Participant participant, double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.green[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: participant.rtcVideoRenderer != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: RTCVideoView(participant.rtcVideoRenderer!,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: participant.fields!.talking == true
                            ? Colors.white
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: Image.network(
                        participant.fields!.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            generateInitials(participant.fields!.name!),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.98),
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              // width: 70,
              height: 32,
              child: Row(
                children: [
                  if (participant.fields!.muted == true)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: Color(0xFFCC525F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                      child: Icon(Icons.mic_off_outlined, color: Colors.white),
                      alignment: Alignment.center,
                    ),
                  if (participant.fields!.raiseHand != null &&
                      participant.fields!.raiseHand!)
                    SizedBox(
                      width: 5,
                    ),
                  if (participant.fields!.raiseHand != null &&
                      participant.fields!.raiseHand!)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: Color(0x7A5D957E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.back_hand,
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
