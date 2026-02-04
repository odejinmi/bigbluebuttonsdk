import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../dashboard_controller.dart';

class InviteHistoryPage extends StatelessWidget {
  const InviteHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.inviteHistory.value == null ||
            controller.inviteHistory.value!.data.isEmpty) {
          return const Center(
            child: Text(
              'No invitations found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.inviteHistory.value!.data.length,
          itemBuilder: (context, index) {
            final invite = controller.inviteHistory.value!.data[index];
            final formattedDate =
                DateFormat('MMM dd, yyyy').format(invite.date);
            final formattedTime =
                invite.time.substring(0, 5); // Basic time formatting

            return Card(
              elevation: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(
                  Icons.event_note,
                  color: Color(0xff2a8853),
                  size: 40,
                ),
                title: Text(
                  invite.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(
                      'On $formattedDate at $formattedTime',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Room: ${invite.roomname}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Guests: ${invite.guest}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                isThreeLine: true,
                onTap: (){
                  Get.dialog(
                      AlertDialog(
                        // backgroundColor: Color(0xFF3E8466),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                InkWell(
                                    child: Icon(Icons.close),
                                  onTap: (){
                                      Get.back();
                                  },
                                ),
                              ],
                            ),
                           Text(
                              invite.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'On $formattedDate at $formattedTime',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Room: ${invite.roomname}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Guests: ${invite.guest}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      )
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
