import 'dart:convert';

import 'package:bigbluebuttonsdk/utils/diorequest.dart';
import 'package:get/get.dart';

import '../dashboard_module/model/internal_user.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class inderneruserController extends GetxController {
  var internalUsers = <InternalUser>[].obs;
  var filteredUsers = <InternalUser>[].obs;
  var selectedEmails = <String>[].obs;

  var _token = ''.obs;
  set token(value) => _token.value = value;
  get token => _token.value;

  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      token = Get.arguments['token'];
      String? initialEmails = Get.arguments['selectedEmails'];
      if (initialEmails != null && initialEmails.isNotEmpty) {
        selectedEmails.addAll(initialEmails.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
      }
    }
    _fetchinternaluser();

    // Listen to searchQuery changes and filter users
    debounce(searchQuery, (_) => filterUsers(), time: const Duration(milliseconds: 300));
  }

  Future<void> _fetchinternaluser() async {
    isLoading.value = true;

    try {
      var cmddetails =
          await Diorequest().get("app/1gov/internal-users", token: token);

      if (cmddetails['success']) {
        internalUsers.value = internalUserFromJson(
            json.encode(cmddetails['data']['intUsers']));
        filteredUsers.assignAll(internalUsers);
      } else {
        if (cmddetails['message'] != "No internet connection") {
          Get.snackbar("Error", cmddetails['message'] ?? "Failed to fetch users");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  void filterUsers() {
    if (searchQuery.isEmpty) {
      filteredUsers.assignAll(internalUsers);
    } else {
      print(searchQuery);
      filteredUsers.assignAll(internalUsers.where((user) {
        final fullName = "${user.firstname ?? ''} ${user.lastname ?? ''}".toLowerCase();
        final email = (user.email ?? '').toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return fullName.contains(query) || email.contains(query);
      }).toList());
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void toggleSelection(String email) {
    if (selectedEmails.contains(email)) {
      selectedEmails.remove(email);
    } else {
      selectedEmails.add(email);
    }
  }

  void done() {
    Get.back(result: selectedEmails.join(','));
  }
}
