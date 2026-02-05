import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'twofactorauthentication_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class twofactorauthenticationPage
    extends GetView<twofactorauthenticationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
          // title: Text('twofactorauthentication Page')
      ),
      body: Container(
        child: Obx(() => SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header
                        Image.asset(
                          'asset/image/1govcloud.png',
                          width: 239,
                        ),
                        const SizedBox(height: 60),

                        // 2FA Content

                        Text(
                          'Two-Factor Authentication',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // OTP Options
                        if(controller.emailSelected)
                        Column(
                          children: [
                            Text(
                              'Check Email for OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // OTP Options
                            InkWell(
                              onTap: () {
                                controller.emailSelected = false;
                              },
                              child: Text(
                                'Use GovOTP app',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor ,
                                ),
                              ),
                            ),
                          ],
                        )
                        else
                          Column(
                            children: [
                              const Text(
                                'Log in to your GovOTP app to generate a code , then enter the code below.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  controller.emailSelected = true;
                                },
                                child: Text(
                                  'Use email instead!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 40),

                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            6,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 40,
                              height: 40,
                              child: TextField(
                                controller: controller.otpControllers[index],
                                focusNode: controller.focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty && index <= 5) {
                                    controller.obj += value;
                                    if (index < 5) {
                                      // Move to next field when a digit is entered
                                      controller.focusNodes[index + 1]
                                          .requestFocus();
                                    }
                                  } else if (value.isEmpty && index > 0) {
                                    controller.focusNodes[index - 1]
                                        .requestFocus();
                                    controller.obj = controller.obj.substring(
                                        0, controller.obj.length - 1);
                                  }

                                  // Reconstruct the OTP string from all controllers. This correctly
                                  // handles insertions/deletions in the middle of the OTP.
                                  String currentOtp = controller
                                      .otpControllers
                                      .map((c) => c.text)
                                      .join();

                                  print('Current OTP: ${currentOtp}');

                                  // If the OTP is fully entered, trigger verification.
                                  if (currentOtp.length == 6) {
                                    print("Verifying OTP...");
                                    controller.verifyOtp();
                                  }
                                },
                                // Handle backspace/delete key press
                                // onKey: (RawKeyEvent event) {
                                //   if (event is RawKeyDownEvent) {
                                //     if (event.logicalKey ==
                                //             LogicalKeyboardKey.backspace ||
                                //         event.logicalKey ==
                                //             LogicalKeyboardKey.delete) {
                                //       if (controller.otpControllers[index].text
                                //               .isEmpty &&
                                //           index > 0) {
                                //         // If current field is empty and backspace is pressed, go to previous field
                                //         controller.focusNodes[index - 1]
                                //             .requestFocus();
                                //       }
                                //     }
                                //   }
                                //   return false;
                                // },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),

                        if(controller.emailSelected)
                        Column(
                          children: [
                            const Text(
                              "Don't have the OTP yet?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // OTP Options
                            if(controller.isLoading)
                            CircularProgressIndicator(),
                            if(!controller.isLoading)
                            InkWell(
                              onTap: () {
                                controller.resendOtp();
                              },
                              child: Text(
                                'Resend the code',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        )
                        else
                        Column(
                          children: [
                            if(controller.isLoading)
                              CircularProgressIndicator(),
                            const Text(
                              "Don't have the Gov OTP app?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // OTP Options
                            InkWell(
                              onTap: () {
                                controller.downloadOtpApp();
                              },
                              child: Text(
                                'Download it from Google play',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor ,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Help Text
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      'Having trouble with your OTP? Fill out the form ',
                                ),
                                TextSpan(
                                  text: 'here',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // You would add a gesture recognizer here in a real app
                                ),
                                const TextSpan(
                                  text:
                                      ' or contact your IT department for support.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
