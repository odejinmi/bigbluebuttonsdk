import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/emptytransaction.dart';
import '../../../utils/strings.dart';
import '../dashboard_controller.dart';

class MeetingRecordings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: GetX<DashboardController>(
          builder: (controller) {
            if (controller.isLoading.isTrue &&
                controller.recordingList.isEmpty) {
              return loadingWidget2;
            }
            if (controller.recordingList.isEmpty) {
              return const Emptytransaction(
                desc: "No meeting recordings found.",
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: controller.recordingList.length,
              itemBuilder: (context, position) {
                return _buildRecordingCard(
                    controller.recordingList[position], context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecordingCard(
      Map<String, dynamic> recordingData, BuildContext context) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(recordingData['startTime']));
    final String formattedDate =
        DateFormat('MMM d, yyyy • hh:mm a').format(date.toLocal());
    final String fileSize =
        (int.parse(recordingData['playback']['format']['size']) / 1048576)
            .toPrecision(1)
            .toString();
    final String duration =
        recordingData['playback']['format']['length'].toString();
    final String playbackUrl = recordingData['playback']['format']['url'];

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with title and icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xffE0F2E9),
                  child: Icon(
                    Icons.video_library,
                    color: Color(0xff2a8853),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recordingData['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Metadata section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetadataChip(Icons.people_alt,
                    '${recordingData['participants']} Participants'),
                _buildMetadataChip(Icons.storage_rounded, '${fileSize}MB'),
                _buildMetadataChip(Icons.timelapse, '${duration} Min(s)'),
              ],
            ),
            const Divider(height: 32),
            // Actions section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Share.share(
                      playbackUrl,
                      subject: 'Meeting Record of ${recordingData['name']}',
                    );
                  },
                  icon:
                      Icon(Icons.share, color: Theme.of(context).primaryColor),
                  label: Text(
                    'Share',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri uri = Uri.parse(playbackUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Play',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2a8853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[700], fontSize: 12),
        ),
      ],
    );
  }
}
