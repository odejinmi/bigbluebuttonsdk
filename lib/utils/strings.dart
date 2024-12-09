import 'package:flutter_background/flutter_background.dart';

import 'meetingdetails.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

void logLongText(String text, {int chunkSize = 1000}) {
  final pattern = RegExp('.{1,$chunkSize}'); // This will split the text into chunks of size `chunkSize`
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Future<bool> startForegroundService() async {
  // Check if the background execution is already enabled
  if (FlutterBackground.isBackgroundExecutionEnabled) {
    print("Background service is already running.");
    return true;
  }
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: 'Title of the notification',
    notificationText: 'Text of the notification',
    notificationImportance: AndroidNotificationImportance.normal,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  await FlutterBackground.initialize(androidConfig: androidConfig);
  return FlutterBackground.enableBackgroundExecution();
}

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

final List<String> backgrounds = [
  "assets/backgroundimages/background-1.jpg.webp",
  'assets/backgroundimages/background-2.jpg.webp',
  'assets/backgroundimages/background-3.jpg.webp',
  'assets/backgroundimages/background-4.jpg.webp',
  'assets/backgroundimages/background-5.jpg.webp',
];

final List<String> desktopBackgrounds = [
  'assets/backgroundimages/desktop-background-1.jpg.webp',
  'assets/backgroundimages/desktop-background-2.jpg.webp',
  'assets/backgroundimages/desktop-background-3.jpg.webp',
  'assets/backgroundimages/desktop-background-4.jpg.webp',
  'assets/backgroundimages/desktop-background-5.jpg.webp',
  'assets/backgroundimages/desktop-background-6.jpg.webp',
  'assets/backgroundimages/desktop-background-7.jpg.webp',
  'assets/backgroundimages/desktop-background-8.jpg.webp',
  'assets/backgroundimages/desktop-background-9.jpg.webp',
];