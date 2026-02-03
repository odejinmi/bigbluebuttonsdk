import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/postjoin_controller.dart';
import 'String.dart';

class Floatingscreen extends GetView<postjoinController> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Obx(() {
      controller.check;
      return Scaffold(
          key: controller.scaffoldKey,
          body: GetBuilder<Websocket>(
            builder: (logic) {
              if (controller.iswhiteboard) {
                controller.presentationcontroller.slideposition =
                    logic.currentSlide["fields"]["num"];
                if (logic.presentationModel.isNotEmpty &&
                    controller
                        .presentationcontroller.selecttoupload.name.isEmpty) {
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
                    print("No presentation model with current == true found.");
                  }
                }
                return controller.bigbluebuttonsdkPlugin.whiteboard();
              } else {
                var participants = logic.participant;
                if (participants.length <= 2) {
                  return Container(
                    color: Color(0xFF1C1C1E), // Dark background
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < participants.length; i++)
                            ProfileAvatar(
                              participant: participants[i],
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    color: Color(0xFF1C1C1E), // Dark background
                    child: Center(
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProfileAvatar(
                                participant: participants[0],
                              ),
                              ProfileAvatar(
                                participant: participants[1],
                              ),
                            ],
                          ),
                          // SizedBox(height: 60),
                          // Add button at bottom
                          Positioned(
                            bottom: 0,
                            right: 3,
                            child: Container(
                              width: 25,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '+${participants.length - 2}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
          ));
    });
  }

  // Helper function to build the participant widget
  Widget _buildParticipantWidget(
      Participant participant, double width, double height) {
    return Container(
      margin: participant.rtcVideoRenderer != null
          ? null
          : EdgeInsets.symmetric(vertical: 5),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Color(0xFFB9C9C2),
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
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Color(0xFF93B3A5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    child: Text(
                      generateInitials(participant.fields!.name!),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.98),
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 70,
              height: 32,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Visibility(
                      visible: participant.fields!.muted == true,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: Color(0xFFCC525F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                        ),
                        child:
                            Icon(Icons.mic_off_outlined, color: Colors.white),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: Color(0x7A5D957E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child:
                          Icon(Icons.more_vert_outlined, color: Colors.white),
                      alignment: Alignment.center,
                    ),
                  ),
                  participant.fields!.raiseHand != null &&
                          participant.fields!.raiseHand!
                      ? Positioned(
                          right: 2,
                          top: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: ShapeDecoration(
                              color: Color(0x7A5D957E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: const Icon(
                              Icons.back_hand,
                              color: Colors.yellow,
                              size: 30,
                            ),
                            alignment: Alignment.center,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: ShapeDecoration(
                color: Color(0xFF1B1B1B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                participant.fields!.name!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xF2F5F9FF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final Participant participant;

  const ProfileAvatar({
    Key? key,
    required this.participant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: participant.fields!.talking == true
                        ? Colors.white
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    participant.fields!.avatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade600,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                participant.fields!.name!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: participant.fields!.muted == false
                    ?  Colors.grey.shade600: Color(0xFFCC525F),
                shape: BoxShape.circle,
              ),
              child: Icon(
                participant.fields!.muted == false
                    ? Icons.mic_sharp
                    : Icons.mic_off_sharp,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
