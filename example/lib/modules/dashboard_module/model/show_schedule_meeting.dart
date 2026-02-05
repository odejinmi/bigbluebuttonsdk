import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_timezone/timezone_info.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../utils/Roomlistparser.dart';
import '../dashboard_controller.dart';

class ShowScheduleMeeting extends StatefulWidget {
  final Roomlistparser roomData;
  const ShowScheduleMeeting({Key? key, required this.roomData}) : super(key: key);

  @override
  _ShowScheduleMeetingState createState() => _ShowScheduleMeetingState();
}

class _ShowScheduleMeetingState extends State<ShowScheduleMeeting> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final guestsController = TextEditingController();
  final messageController = TextEditingController();
  final additionalController = TextEditingController();
  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now().add(const Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return AlertDialog(
        title: Text('Schedule a Meeting'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: guestsController,
                  decoration: InputDecoration(
                      labelText: 'Guests (comma-separated emails)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one guest email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(labelText: 'Message'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: additionalController,
                  decoration: InputDecoration(
                      labelText: 'Additional Information'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                    'Internal users (MDA users)'),
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    for (var user in controller.internalUsers.value)
                      InkWell(
                        onTap: (){
                          if (guestsController.text.isEmpty) {
                            guestsController.text = '${user.email!}, ';
                          }  else {
                            if (!guestsController.text.contains(user.email!)) {
                              guestsController.text +=
                              '${ user.email!}, ';
                            } else {
                              guestsController.text = guestsController.text.replaceAll('${user.email!}, ', '');
                            }
                          }
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // border: Border.all(
                            //   color: guestsController.text.contains(user.email!)? Colors.black.withOpacity(0.2): null,
                            // ),
                            color: guestsController.text.contains(user.email!)? Colors.black.withOpacity(0.2): Colors.white,
                          ),
                          child: Text('${user.firstname} ${user.lastname}'),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                    'From: ${DateFormat('yyyy-MM-dd HH:mm').format(fromDateTime)}'),
                ElevatedButton(
                  child: const Text('Select Start Time'),
                  onPressed: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: fromDateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    if (date == null) return;
                    final time = await showTimePicker(
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(fromDateTime));
                    if (time == null) return;
                    setState(() {
                      fromDateTime = DateTime(date.year, date.month,
                          date.day, time.hour, time.minute);
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                    'To: ${DateFormat('yyyy-MM-dd HH:mm').format(toDateTime)}'),
                ElevatedButton(
                  child: const Text('Select End Time'),
                  onPressed: () async {
                    final date = await showDatePicker(
                        context: context,
                        initialDate: toDateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    if (date == null) return;
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(toDateTime));
                    if (time == null) return;
                    setState(() {
                      toDateTime = DateTime(date.year, date.month,
                          date.day, time.hour, time.minute);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Schedule'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final TimezoneInfo currentTimeZone =
                await FlutterTimezone.getLocalTimezone();
                controller.scheduleMeeting(
                  roomData: widget.roomData,
                  title: titleController.text,
                  guests: guestsController.text,
                  fromDateTime: fromDateTime,
                  toDateTime: toDateTime,
                  message: messageController.text,
                  additional: additionalController.text,
                  hostname:
                  "${controller.data['lastname']} ${controller.data['firstname']}",
                  timezone:
                  '${currentTimeZone.identifier ?? 'Unknown'} - ${currentTimeZone.localizedName?.name ?? 'Unknown'}',
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    });
  }
}
