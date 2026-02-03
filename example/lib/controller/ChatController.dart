import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var _isEmojiVisible = false.obs; // variable to track card visibility
  set isEmojiVisible(value) => _isEmojiVisible.value = value;
  get isEmojiVisible => _isEmojiVisible.value;

  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();

  var _chatid = "MAIN-PUBLIC-GROUP-CHAT".obs; // Initial zoom level (100%)
  set chatid(value) => _chatid.value = value;
  get chatid => _chatid.value;

  final _messages = <ChatMessage>[].obs;
  set messages(value) => _messages.value = value;
  get messages => _messages;

  final messageController = TextEditingController();

  final List<Map<String, dynamic>> menuItems = [
    {'name': 'Back', 'icon': Icons.arrow_back_ios},
    {'name': 'Appreciation'},
    {'name': 'Minutes'},
    {'name': 'General notes'},
    {'name': 'Technical notes'},
    {'name': 'Sales notes'},
    {'name': 'Transcript'},
  ];

  dynamic selectedItem;
}
