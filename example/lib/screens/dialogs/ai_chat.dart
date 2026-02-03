import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ChatController.dart';
import '../../utils/diorequest.dart';

class AiChat extends GetView<ChatController> {
  Meetingdetails meetingdetails;
  AiChat({super.key, required this.meetingdetails});

  // var postjoincontroller = Get.find<postjoinController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          return Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(62, 139, 102, 1),
              ),
              child: Padding(
                // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                padding: const EdgeInsets.only(
                    top: 50, right: 12, bottom: 24, left: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Onegov Ai',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 16, left: 5, right: 5, bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(93, 149, 126, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.shield, color: Colors.white),
                            Expanded(
                              child: Text(
                                'No other participants can see this conversation',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                        child: controller.messages.isNotEmpty
                            ? _buildBodyAIScreen()
                            : _buildWelcomeToAIScreen()),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: controller.messageController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                checkdonation(
                                    controller.messageController.text, "bot");
                                controller.messages.insert(
                                    0,
                                    ChatMessage(
                                        message:
                                            controller.messageController.text,
                                        sender: "You",
                                        timestamp: 00000));
                                controller.messageController.clear();
                              },
                              icon: const Icon(Icons.send_outlined,
                                  color: Colors.white)),
                          hintText: "Ask anything about the meeting...",
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: const Color.fromRGBO(93, 149, 126, 1),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ));
        }));
  }

  Widget chatMessageCard(ChatMessage message) {
    return Align(
      alignment: Alignment.topLeft,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: const Color.fromRGBO(62, 139, 102, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  message.sender,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  '2:12 PM',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
              ]),
              Text(
                message.message,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyAIScreen() {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: controller.messages.length,
          reverse: true,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          itemBuilder: (context, index) {
            return chatMessageCard(controller.messages[index]);
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              checkdonation("", "highlights");
            },
            child: Container(
                width: 91,
                height: 32,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 137, 109, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.white, width: 1)),
                child: const Center(
                    child: Text(
                  'Highlights',
                  style: TextStyle(color: Colors.white),
                ))),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 42,
            child: Card(
              color: const Color.fromRGBO(71, 137, 109, 1),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: SizedBox(
                child: PopupMenuButton<dynamic>(
                  color: const Color.fromRGBO(93, 149, 126, 1),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                  itemBuilder: (BuildContext context) {
                    return controller.menuItems.map((item) {
                      return PopupMenuItem<dynamic>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(item['icon'], color: Colors.white),
                            const SizedBox(width: 10),
                            Text(item['name'],
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (dynamic value) {
                    checkdonation(value['name'], "bot");
                    controller.selectedItem = value;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildWelcomeToAIScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
              borderRadius: BorderRadius.all(Radius.circular(26))),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Welcome to Onegov Ai',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Here are some things you can try...',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: () {
            checkdonation("", "highlights");
          },
          child: Container(
            width: 91,
            height: 32,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Colors.white, width: 1),
                color: Colors.transparent),
            child: const Center(
                child: Text('Highlights',
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            checkdonation("", "summary");
          },
          child: Container(
            width: 140,
            height: 36,
            // padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Colors.white, width: 1),
                color: Colors.transparent),
            child: const Center(
                child: Text('Meeting Summary',
                    style: TextStyle(color: Colors.white, fontSize: 14))),
          ),
        )
      ],
    );
  }

  void checkdonation(String message, String endpoint) async {
    var cmddetails = await Diorequest()
        .post("https://kv4-ai.vercel.app/konn3ctai/$endpoint", {
      "message": message,
      "meetingID": meetingdetails.meetingId,
      "uuid": "${meetingdetails.meetingId}%${meetingdetails.internalUserId}"
    });
    if (cmddetails["message"].isNotEmpty) {
      if (cmddetails["message"] is String) {
        controller.messages.insert(
            0,
            ChatMessage(
                message: cmddetails["message"],
                sender: "Onegov Ai",
                timestamp: 00000));
      } else {
        controller.messages.insert(
            0,
            ChatMessage(
                message: cmddetails["message"]["response"],
                sender: "Onegov Ai",
                timestamp: 00000));
      }
    } else {
      print("start the meeting again");
    }
  }
}
