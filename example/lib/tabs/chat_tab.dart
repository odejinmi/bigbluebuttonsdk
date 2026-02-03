import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ChatController.dart';

class ChatTab extends GetView<ChatController> {
  final messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: GetBuilder<Websocket>(builder: (logic) {
        return logic.meetingResponse?.fields.lockSettingsProps
                    .disablePublicChat ??
                false
            ? Text('Your Public Chat has been disabled by the Moderator')
            : Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  const Divider(),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Chats',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold)),
                        // const Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  const Divider(),
                  Expanded(
                    child: GetBuilder<Websocket>(builder: (logic) {
                      return ListView.builder(
                        itemCount:
                            logic.getChatMessages(controller.chatid).length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 16, left: 16),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              chatMessageCard(
                                  logic.getChatMessages(
                                      controller.chatid)[index],
                                  logic.meetingDetails!),
                              SizedBox(
                                height: screenHeight * 0.025,
                              )
                            ],
                          );
                        },
                      );
                    }),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Everyone',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Icon(Icons.keyboard_arrow_right_rounded,
                                color: Colors.grey[500]),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  child: Icon(Icons.pin, color: Colors.grey[500]),
                                  onTap: () {
                                    controller.isEmojiVisible = false;
                                  },
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                InkWell(
                                  child: Icon(Icons.tag_faces,
                                      color: Colors.grey[500]),
                                  onTap: () {
                                    controller.isEmojiVisible = true;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return controller.isEmojiVisible
                        ? SizedBox(
                            height: 250,
                            child: EmojiPicker(
                              textEditingController: messageController,
                              scrollController: _scrollController,
                              // onEmojiSelected: (category, emoji) =>
                              //     _onEmojiSelected(emoji),
                              config: Config(
                                height: 256,
                                checkPlatformCompatibility: true,
                                viewOrderConfig: const ViewOrderConfig(),
                                emojiViewConfig: EmojiViewConfig(
                                  // Issue: https://github.com/flutter/flutter/issues/28894
                                  emojiSizeMax: 28 *
                                      (foundation.defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                          ? 1.2
                                          : 1.0),
                                ),
                                skinToneConfig: const SkinToneConfig(),
                                categoryViewConfig: const CategoryViewConfig(),
                                bottomActionBarConfig:
                                    const BottomActionBarConfig(),
                                searchViewConfig: const SearchViewConfig(),
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 15),
                    child: TextFormField(
                      controller: messageController,
                      onTap: () {
                        controller.isEmojiVisible = false;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Container(
                            width: screenWidth * 0.06,
                            height: screenWidth * 0.06,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                                onPressed: () {
                                  if (messageController.text.isNotEmpty) {
                                    controller.bigbluebuttonsdkPlugin
                                        .sendmessage(
                                            chatid: controller.chatid,
                                            message: messageController.text);
                                    messageController.clear();
                                  }
                                  controller.isEmojiVisible = false;
                                },
                                icon: const Icon(Icons.send,
                                    color: Colors.white))),
                        hintText: "Message to everyone...",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget chatMessageCard(ChatMessage message, Meetingdetails meetingdetails) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return message.senderName == meetingdetails.fullname
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 0.78,
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          '2:12 PM',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.09,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          message.message,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.green,
                //backgroundImage: AssetImage('assets/person.png'),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Colors
                    .green, //backgroundImage: AssetImage('assets/person.png')//
              ),
              SizedBox(
                width: screenWidth * 0.78,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          message.senderName!,
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          '2:12 PM',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.09,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          message.message,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
