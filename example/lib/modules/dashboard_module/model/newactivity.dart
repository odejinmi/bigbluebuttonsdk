import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/Meetinghistory.dart';
import '../../../utils/strings.dart';
import '../dashboard_controller.dart';

class Newactivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: GetX<DashboardController>(
          builder: (controller) {
            if (controller.isLoading.isTrue && controller.historyList.isEmpty) {
              return loadingWidget2;
            }
            if (controller.historyList.isEmpty) {
              return const Center(
                child: Text(
                  'No meeting history found.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: controller.historyList.length,
              itemBuilder: (context, index) {
                final historyItem = controller.historyList[index];
                return item(historyItem);
              },
            );
          },
        ),
      ),
    );
  }

  Widget item(Meetinghistoryparser historyItem) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: const CircleAvatar(
          backgroundColor: Color(0xffE0F2E9),
          child: Icon(
            Icons.history,
            color: Color(0xff2a8853),
          ),
        ),
        title: Text(
          historyItem.room?.name??"",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
              historyItem.room?.createdAt == null ? "" :
            DateFormat('MMM d, y • hh:mm a').format(
              DateTime.parse(historyItem.room!.createdAt.toString()).toLocal(),
            ),
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        trailing: const Text(
          "Ended",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
