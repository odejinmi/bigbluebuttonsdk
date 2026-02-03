import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

String home = 'Home';
String baseurl = 'meetingapp.convergenceondemand.com/';
String apibaseurl =
    'https://konnectsandbox.convergenceondemand.com/conferencing/';
String entermeetingurl =
    'https://${baseurl}bigbluebutton/api/enter?sessionToken=';
String token = "1075|v7DDQRBn0s5ri6p7KrAP2xBjsoB2UpIlHXnaNtyZ";

// https://konnectsandbox.convergenceondemand.com/conferencing/ajoinroom
String generateInitials(String fullName) {
  // Trim and check if the fullName is empty
  if (fullName.trim().isEmpty) {
    return ''; // Return an empty string if input is empty
  }

  // Split the name into parts
  List<String> nameParts = fullName.trim().split(' ');

  // If there's only one name part, return the first letter
  if (nameParts.length == 1) {
    return nameParts[0][0].toUpperCase();
  }

  // Otherwise, return the first letter of the first and last name
  String firstInitial = nameParts[0][0].toUpperCase();
  String lastInitial = nameParts[nameParts.length - 1][0].toUpperCase();

  return firstInitial + lastInitial;
}

const loadingWidget2 = SpinKitThreeBounce(
  color: Color(0xff21714B),
  size: 30.0,
);

void showErrorSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent.withOpacity(0.95),
    colorText: Colors.white,
    borderRadius: 10.0,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    icon: Icon(Icons.error_outline, color: Colors.white, size: 26),
    shouldIconPulse: false,
    leftBarIndicatorColor: Colors.red[800],
    duration: Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    titleText: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        offset: Offset(0, 1),
        blurRadius: 5.0,
      ),
    ],
  );
}

void showSuccessSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green[600],
    colorText: Colors.white,
    borderRadius: 10.0,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 26),
    shouldIconPulse: true,
    leftBarIndicatorColor: Colors.green[800],
    duration: Duration(seconds: 3),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    titleText: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0, 1),
        blurRadius: 4.0,
      ),
    ],
  );
}
