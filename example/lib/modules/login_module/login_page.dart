import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'login_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class loginPage extends GetView<loginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Obx(() => Column(
                children: [
                  const SizedBox(height: 90),
                  Image.asset('asset/image/govsupport_logo.png', width: 111),
                  const SizedBox(height: 9),
                  Image.asset(
                    'asset/image/1govcloud.png',
                    width: 239,
                  ),

                  const SizedBox(height: 60),

                  const Text(
                    'Enter your credentials to access Gov Conference',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // MDA Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your MDA',
                      suffixText: '.gov.ng',
                      suffixStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                    controller: controller.tenantId,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      suffixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                    controller: controller.username,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    obscureText: controller.obscureText,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(
                        icon: Icon(controller.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          controller.obscureText = !controller.obscureText;
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                    controller: controller.password,
                  ),
                  const SizedBox(height: 35),

                  // Login Button
                  Row(
                    children: [
                      if(controller.box.read('tenantId') != null && controller.box.read('username') != null && controller.box.read('password') != null)
                      InkWell(
                        onTap: () {
                          controller.checkBiometric();
                        },
                          child: Icon(Icons.fingerprint,size: 40,)),
                      SizedBox(width: 16,),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.login();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff006D43),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(34),
                              ),
                            ),
                            child: controller.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Footer Links
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff0d6efd),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff0d6efd),
                          ),
                        ),
                        Text(' • ', style: TextStyle(color: Colors.black54)),
                        Text(
                          'Terms of Use',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff0d6efd),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff0d6efd),
                          ),
                        ),
                        Text(' • ', style: TextStyle(color: Colors.black54)),
                        Text(
                          'Security',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff0d6efd),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff0d6efd),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: Obx(
            () => Container(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.appVersion,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.PREJOIN);
        },
        child: Image.asset(
          "asset/image/join_meet.png",
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
