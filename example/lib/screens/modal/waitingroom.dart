import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';

class Waitingroom extends GetView<postjoinController> {
  const Waitingroom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<Websocket>(
        builder: (logic) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 400,
              height: 670,
              padding: const EdgeInsets.only(
                top: 24,
                right: 16,
                bottom: 24,
                left: 16,
              ),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(62, 132, 102, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Waiting Room',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  if (logic.myDetails!.fields!.role == "MODERATOR")
                    Flexible(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.guestpermission = "ASK_MODERATOR";
                                  print("ASK_MODERATOR");
                                  controller.bigbluebuttonsdkPlugin
                                      .changeGuestPolicy("ASK_MODERATOR");
                                },
                                child: Container(
                                  height: 38,
                                  // width: 153,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    right: 16,
                                    bottom: 6,
                                    left: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.guestpermission ==
                                            "ASK_MODERATOR"
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Text(
                                    'Ask Moderator',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.guestpermission = "Always Accept";
                                  print("ALWAYS_ACCEPT");
                                  controller.bigbluebuttonsdkPlugin
                                      .changeGuestPolicy("ALWAYS_ACCEPT");
                                },
                                child: Container(
                                  height: 38,
                                  // width: 153,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    right: 16,
                                    bottom: 6,
                                    left: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.guestpermission ==
                                            "Always Accept"
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Text(
                                    'Always Accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 20),
                          if(controller.guestpermission != "Always Accept")
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.bigbluebuttonsdkPlugin
                                          .allowPendingUsers(
                                        logic.waitingParticipant,
                                        "ALLOW",
                                      );
                                    },
                                    child: Container(
                                      height: 48,
                                      // width: 153,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        right: 16,
                                        bottom: 6,
                                        left: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        border: Border.all(color: Colors.white),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: 23,
                                          ),
                                          Text(
                                            'Allow Everyone',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.bigbluebuttonsdkPlugin
                                          .allowPendingUsers(
                                        logic.waitingParticipant,
                                        "DENY",
                                      );
                                    },
                                    child: Container(
                                      height: 48,
                                      // width: 153,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        right: 16,
                                        bottom: 8,
                                        left: 16,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(204, 82, 95, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 23,
                                          ),
                                          Text(
                                            'Deny Everyone',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                            ],
                          ),
                          Flexible(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: logic.waitingParticipant.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (logic.waitingParticipant.isEmpty) {
                                  return Container();
                                }
                                final user = logic.waitingParticipant[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      user["fields"]["avatar"],
                                    ),
                                  ),
                                  title: Text(
                                    user["fields"]["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () async {
                                          var result = await controller.bigbluebuttonsdkPlugin
                                              .allowPendingUsers([user], "ALLOW");
                                          print("pending result");
                                          print(result);
                                        },
                                        child: Container(
                                          height: 22,
                                          width: 54,
                                          padding: const EdgeInsets.only(
                                            right: 5,
                                            left: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(44),
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Allow',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () async {
                                          var result = await controller.bigbluebuttonsdkPlugin
                                              .allowPendingUsers([user], "DENY");
                                          print('deny result');
                                          print(result);
                                        },
                                        child: Container(
                                          height: 22,
                                          width: 54,
                                          padding: const EdgeInsets.only(
                                            right: 5,
                                            left: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(44),
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Deny',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      child: Text(
                        "This page can only be seen by a Moderator",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
