import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/postjoin_controller.dart';
import '../../utils/diorequest.dart';

class Activedonation extends StatelessWidget {
  const Activedonation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postjoincontroller = Get.find<postjoinController>();
    // Original DateTime string
    String originalDateTime = postjoincontroller.donationdetails[0]["created_at"];

    // Parse the string to DateTime
    DateTime parsedDate = DateTime.parse(originalDateTime);

    // Define the desired output format
    String formattedDate = DateFormat('dd/MM/yyyy hh:mma').format(parsedDate);
    return  Obx((){
      print(postjoincontroller.donationdetails);
      return Container(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40),
                Text(
                  'Active Donation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment : CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Donation Name:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      postjoincontroller.donationdetails[0]["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Donations Received',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 307,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: Color(0xFF5D957E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFF68A48B)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:50),
                InkWell(
                  onTap: (){
                    Get.back();
                    patchMeeting();
                  },
                  child: Container(
                    width: 151,
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Color(0xFFCC525F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'End Donation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9800000190734863),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ]
          )
      );
    });
  }


  void patchMeeting() async {
    var postjoincontroller = Get.find<postjoinController>();
    // if (nameController.value.text == "") {
    //   showCommonError("Your name can not be empty.");
    //   return;
    // }
    //
    // if (emailController.value.text == "") {
    //   showCommonError("Your email can not be empty.");
    //   return;
    // }

    var json_body;
    json_body = {
      "status": 0
    };

    var cmddetails = await Diorequest().patch("k4/donation/${postjoincontroller.donationdetails[0]["room_id"]}",json_body);
    // var cmddetails = await Diorequest().get("start-a-room/$id");


    if (cmddetails['success']) {
      postjoincontroller.donate = false;
    } else {

    }
  }
}
