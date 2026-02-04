// import 'package:bigbluebuttonsdk/bigbluebuttonsdkr.dart';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/postjoin_controller.dart';
import 'dialogs/ai_chat.dart';
import 'dialogs/cinema.dart';
import 'dialogs/donations_dialog.dart';
import 'dialogs/polls_dialog.dart';
import 'dialogs/settings.dart';

class DrawerComp extends StatefulWidget {
  const DrawerComp({super.key});

  @override
  State<DrawerComp> createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(right: 94),
      child: GetBuilder<postjoinController>(builder: (postjoincontroller) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: screenHeight * 0.01,
            ),

            const Divider(),
            const SizedBox(
              height: 15,
            ),
            // if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails != null &&
            //     postjoincontroller
            //             .bigbluebuttonsdkPlugin.mydetails!.fields!.role ==
            //         "MODERATOR")
            // Column(
            //   children: [
            //     ListTile(
            //         leading: const Icon(Icons.radio_button_checked, size: 20),
            //         title: const Text(
            //           'Breakout Room',
            //           style: TextStyle(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 14,
            //           ),
            //         ),
            //         onTap: () {
            //           Navigator.pop(context);
            //         }),
            //     const Divider(),
            //   ],
            // ),
            if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails != null &&
                postjoincontroller
                        .bigbluebuttonsdkPlugin.mydetails!.fields!.role ==
                    "MODERATOR")
              Column(
                children: [
                  ListTile(
                      leading: const Icon(Icons.radio_button_checked, size: 20),
                      title: Text(
                        '${!postjoincontroller.bigbluebuttonsdkPlugin.isrecording? 'Start' : 'Stop'} Recording',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () async {
                        var result = await postjoincontroller.bigbluebuttonsdkPlugin
                            .toggleRecording();
                        Navigator.pop(context);
                      }),
                  const Divider(),
                ],
              ),
            // ListTile(
            //   leading: Image.asset('asset/image/change_layout_icon.png',package: "govmeeting",),
            //   title: const Text('Change Layout', style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14,),),
            //   trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Image.asset('asset/image/fullscreen_icon.png',package: "govmeeting",),
            //   title: const Text('Go Fullscreen', style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14,),),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: const Icon(Icons.monitor_rounded, size: 20),
            //   title: const Text(
            //     'White Board',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14,
            //     ),
            //   ),
            //   onTap: () {
            //     postjoincontroller.iswhiteboard =
            //         !postjoincontroller.iswhiteboard;
            //   },
            // ),
            // if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails != null &&
            //     postjoincontroller
            //         .bigbluebuttonsdkPlugin.mydetails!.fields!.presenter!)
            //   ListTile(
            //     leading: const Icon(Icons.folder_open_rounded, size: 20),
            //     title: const Text(
            //       'Upload Files',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 14,
            //       ),
            //     ),
            //     onTap: () async {
            //       Get.back();
            //       showGeneralDialog(
            //           context: context,
            //           barrierDismissible: false,
            //           barrierColor: Colors.transparent,
            //           transitionDuration: const Duration(milliseconds: 400),
            //           pageBuilder: (context, animation, secondaryAnimation) {
            //             return const Presentation();
            //           });
            //     },
            //   ),
            // SwitchListTile(
            //     title: Text('Raise Hand',
            //         style: TextStyle(
            //           color:
            //               postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
            //                           null &&
            //                       postjoincontroller.bigbluebuttonsdkPlugin
            //                           .mydetails!.fields!.raiseHand!
            //                   ? Colors.black
            //                   : Colors.grey,
            //         )),
            //     secondary: Icon(
            //       Icons.back_hand_outlined,
            //       color: postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
            //                   null &&
            //               postjoincontroller.bigbluebuttonsdkPlugin.mydetails!
            //                   .fields!.raiseHand!
            //           ? Colors.black
            //           : Colors.grey,
            //     ),
            //     activeColor: Colors.black,
            //     thumbColor: const MaterialStatePropertyAll(Colors.black),
            //     inactiveThumbColor: Colors.black,
            //     trackColor: const MaterialStatePropertyAll(
            //         Color.fromRGBO(93, 149, 126, 1)),
            //     inactiveTrackColor: const Color.fromRGBO(62, 132, 102, 1),
            //     value: postjoincontroller.bigbluebuttonsdkPlugin.mydetails !=
            //             null &&
            //         postjoincontroller
            //             .bigbluebuttonsdkPlugin.mydetails!.fields!.raiseHand!,
            //     onChanged: (newValue) {
            //       Navigator.pop(context);
            //       if (postjoincontroller
            //           .bigbluebuttonsdkPlugin.mydetails!.fields!.raiseHand!) {
            //         postjoincontroller.bigbluebuttonsdkPlugin.lowerHand();
            //       } else {
            //         postjoincontroller.bigbluebuttonsdkPlugin.raiseHand();
            //       }
            //     }),

            if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails != null &&
                postjoincontroller
                        .bigbluebuttonsdkPlugin.mydetails!.fields!.role ==
                    "MODERATOR")
              ListTile(
                leading: const Icon(Icons.mic_off_outlined, size: 20),
                title: Text(
                  '${postjoincontroller.muteAll?"Unmute New Users":"Mute All & New Users"}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  var result = await postjoincontroller.bigbluebuttonsdkPlugin.muteallusers();
                  if(result != null){
                    postjoincontroller.muteAll = !postjoincontroller.muteAll;
                  }
                },
              ),

            // if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails != null &&
            //     postjoincontroller
            //             .bigbluebuttonsdkPlugin.mydetails!.fields!.role ==
            //         "MODERATOR")
            //   ListTile(
            //     leading: const Icon(Icons.mic_off_outlined, size: 20),
            //     title: Text(
            //       '${muteAllExceptPresenter?"Unmute New Users":"Mute All Except Presenter"}',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 14,
            //       ),
            //     ),
            //     onTap: () async {
            //       var result = await postjoincontroller.bigbluebuttonsdkPlugin.muteAllExceptPresenter();
            //       if(result != null){
            //         muteAllExceptPresenter = !muteAllExceptPresenter;
            //         setState(() {
            //
            //         });
            //       }
            //     },
            //   ),

            if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails != null &&
                postjoincontroller
                    .bigbluebuttonsdkPlugin.mydetails!.fields!.presenter!)
              ListTile(
                leading: const Icon(Icons.how_to_vote, size: 20),
                title: const Text(
                  'Polls',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.transparent,
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return PollsDialog();
                      }).then((_) {
                    // This runs after bottom sheet is dismissed
                    var controller = postjoincontroller.pullcontroller;
                    controller.question.value = "";
                    controller.options.value = ['Option 1'];
                  });
                },
              ),
            // ListTile(
            //   leading: const Icon(Icons.attach_money_rounded, size: 20),
            //   title: const Text(
            //     'Donation',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14,
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _showDonationsDialog();
            //   },
            // ),

            if (postjoincontroller.bigbluebuttonsdkPlugin.mydetails != null &&
                postjoincontroller
                    .bigbluebuttonsdkPlugin.mydetails!.fields!.presenter!)
              ListTile(
                leading: const Icon(Icons.movie_outlined, size: 20),
                title: const Text(
                  'E-Cinema',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCinemaDialog();
                },
              ),
            const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.smart_toy_sharp),
            //   title: const Text(
            //     'Onegov AI',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14,
            //     ),
            //   ),
            //   trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _showAIChatDialog(postjoincontroller.meetingdetails);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, size: 20),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog();
              },
            ),
          ],
        );
      }),
    );
  }

// =============Dialog for showing Donations=======================
  _showDonationsDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DonationsDialog();
        });
  }

// =============Dialog for Settings section=======================
  _showSettingsDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const SettingsFlow();
        });
  }

  _showAIChatDialog(var meetingdetails) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return AiChat(meetingdetails: meetingdetails);
        });
  }

  _showCinemaDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const Cinema();
        });
  }
}
