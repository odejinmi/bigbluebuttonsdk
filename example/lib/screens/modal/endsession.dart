import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';

class Endsession extends StatelessWidget {
  const Endsession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<postjoinController>(builder: (logic) {
      return Container(
        padding: const EdgeInsets.all(5),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFF3E8466),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "asset/image/caution.png",
                    height: 14,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: SizedBox(
                      child: Text(
                        'End Session',
                        style: TextStyle(
                          color: Color(0xFFCC525F),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(
                'The session will end for everyone and all the activities will stop. You can’t undo this action.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7200000286102295),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 48,
              width: Get.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFF5D957E)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Don’t End',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.98),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      logic.isleaving = "Oops! You have Ended the session";
                      var result = await logic.bigbluebuttonsdkPlugin.endroom();
                      print(result);
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFCC525F),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFCC525F)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'End Session',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.98),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
