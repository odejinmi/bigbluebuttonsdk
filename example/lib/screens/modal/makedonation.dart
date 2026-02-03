import 'package:flutter/material.dart';
import 'package:flutterwave_standard_smart/flutterwave.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';

class Makedonation extends StatelessWidget {
  const Makedonation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postjoincontroller = Get.find<postjoinController>();
    return  Obx((){
          print(postjoincontroller.donationdetails);
      return Container(
          child: Form(
            key: postjoincontroller.formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Donation Name:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    postjoincontroller.donationdetails[0]["name"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Add a deiscription',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 515,
                    height: 48,
                    // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: ShapeDecoration(
                      color: Color(0xFF5D957E),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFF68A48B)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: postjoincontroller.donationdescriptionController,
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return "this field cannot be empty";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(93, 149, 126, 1),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Add a unique number (Optional)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 197,
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
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: postjoincontroller.donationuniquenumberController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(93, 149, 126, 1),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  postjoincontroller.donationdetails[0]["type"] == 2?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Donation Amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: (){
                          postjoincontroller.amounttodonate = postjoincontroller.donationdetails[0]["amount"].toString();
                        },
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: ShapeDecoration(
                            color: Color(0xFF5D957E),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: postjoincontroller.amounttodonate.isEmpty?Colors.transparent:Color(0xFF68A48B)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          child: Text(
                            postjoincontroller.donationdetails[0]["amount"].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ) :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Donation Amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 333,
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
                        child: TextFormField(
                          cursorColor: Colors.white,
                          onChanged: (value){
                            postjoincontroller.amounttodonate = value;
                          },
                          validator: (value){
                          if (postjoincontroller.donationdetails[0]["type"] != 2 && (value == null || value.isEmpty)){
                            return "this field cannot be empty";
                          }
                          return null;
                        },
                          // controller: donationNameController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(93, 149, 126, 1),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8)),
                                  borderSide: BorderSide.none)
                          ),
                        ),
                      ),
                    ],
                  ) ,
                  SizedBox(height: 20),
                  Container(
                    width: 325,
                    height: 24,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            postjoincontroller.check = !postjoincontroller.check;

                          },
                          child: Opacity(
                            opacity: 0.80,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: ShapeDecoration(
                                color: postjoincontroller.check
                                    ? const Color(0xFF3E8466)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.50,
                                      color: const Color(
                                          0xFF9EA1AE)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.done, size: 15,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Anonymous Donation',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.949999988079071),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          if(!postjoincontroller.isLoading && postjoincontroller.formKey.currentState!.validate()) {
                            // controller.checkingMeeting();

                              final Customer customer = Customer(
                                  name: postjoincontroller.meetingdetails.fullname,
                                  phoneNumber: '08166939205',
                                  email: postjoincontroller.meetingdetails.externUserID
                              );
                            final Flutterwave flutterwave = Flutterwave(
                                context: context, publicKey: 'FLWPUBK_TEST-f3450fbb82c4ba25f0554ae3e518df11-X',
                                currency: "naira",
                                redirectUrl: "add-your-redirect-url-here",
                                txRef: DateTime.now().toString(),
                                amount: postjoincontroller.amounttodonate,
                                customer: customer,
                                paymentOptions: "ussd, card, barter, payattitude",
                                customization: Customization(
                                  title: postjoincontroller.donationdetails[0]["name"],
                                  description: 'Onegov Donation',
                                  logo: 'https://konn3ct.com/assets/images/group99@2x.png',),
                                meta : { "donation_id": postjoincontroller.donationdetails[0]["donationCreatorId"], "uniqueNumber": postjoincontroller.donationuniquenumberController, "description": postjoincontroller.donationdescriptionController, "isAnonymous": postjoincontroller.check },
                                isTestMode: false );
                          }
                        },
                        child: Container(
                          width: 151,
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: ShapeDecoration(
                            color: Color(0xFF5D957E),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Donate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9800000190734863),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]
            ),
          )
      );
    });
  }
}
