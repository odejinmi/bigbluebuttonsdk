import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../routes/app_pages.dart';
import 'showschedulemeeting_controller.dart';

class ShowschedulemeetingPage extends GetView<ShowschedulemeetingController> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff006D43);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Schedule a Meeting',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(primaryColor),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        _buildSectionCard(
                          title: "Meeting Details",
                          icon: Icons.info_outline,
                          children: [
                            _buildTextField(
                              controller: controller.titleController,
                              label: 'Meeting Title',
                              hint: 'Enter the purpose of the meeting',
                              icon: Icons.title,
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Please enter a title' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: controller.guestsController,
                              label: 'Guests',
                              hint: 'Select or enter emails (comma separated)',
                              icon: Icons.group_add_outlined,
                              maxLines: 2,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.person_add, color: primaryColor),
                                onPressed: () async {
                                  var result = await Get.toNamed(Routes.INDERNERUSER, arguments: {
                                    'token': controller.token,
                                    'selectedEmails': controller.guestsController.text,
                                  });
                                  if (result != null) {
                                    controller.guestsController.text = result;
                                  }
                                },
                              ),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Please add at least one guest' : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          title: "Date & Time",
                          icon: Icons.calendar_today,
                          children: [
                            _buildDateTimeTile(
                              context: context,
                              label: "Starts",
                              dateTime: controller.fromDateTime,
                              onTap: () => _selectDateTime(context, true),
                              icon: Icons.access_time_filled,
                              color: Colors.blue[700]!,
                            ),
                            const Divider(height: 32),
                            _buildDateTimeTile(
                              context: context,
                              label: "Ends",
                              dateTime: controller.toDateTime,
                              onTap: () => _selectDateTime(context, false),
                              icon: Icons.access_time_filled,
                              color: Colors.orange[700]!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          title: "Additional Information",
                          icon: Icons.description_outlined,
                          children: [
                            _buildTextField(
                              controller: controller.messageController,
                              label: 'Message',
                              hint: 'Brief invitation message',
                              icon: Icons.message_outlined,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: controller.additionalController,
                              label: 'Additional Notes',
                              hint: 'Any other details...',
                              icon: Icons.note_add_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildScheduleButton(primaryColor),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildHeader(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "New Meeting",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Fill in the details below to invite your colleagues.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xff006D43)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff006D43), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDateTimeTile({
    required BuildContext context,
    required String label,
    required DateTime dateTime,
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    DateFormat('EEE, MMM d, yyyy • HH:mm').format(dateTime),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleButton(Color color) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () {
                if (controller.formKey.currentState!.validate()) {
                  controller.scheduleMeeting();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: color.withOpacity(0.4),
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Schedule Meeting',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isFrom) async {
    final initialDate = isFrom ? controller.fromDateTime : controller.toDateTime;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xff006D43)),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xff006D43)),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    final finalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (isFrom) {
      controller.fromDateTime = finalDateTime;
      if (controller.toDateTime.isBefore(finalDateTime)) {
        controller.toDateTime = finalDateTime.add(const Duration(hours: 1));
      }
    } else {
      controller.toDateTime = finalDateTime;
    }
  }
}
