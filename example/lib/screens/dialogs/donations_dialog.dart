import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';
import '../../utils/diorequest.dart';

class DonationsDialog extends StatefulWidget {
  const DonationsDialog({super.key});

  @override
  State<DonationsDialog> createState() => _DonationsDialogState();
}

class _DonationsDialogState extends State<DonationsDialog> {
  int? _selectedValue;
  bool _flashEnabled = false; // Tracks the checkbox state
  var controller = Get.find<postjoinController>();
  final donationNameController = TextEditingController();
  final donationamountController = TextEditingController();

  var isLoading = false;

  var formKey = GlobalKey<FormState>();

  void validateMeeting() async {
    isLoading = true;
    var json_body;
    json_body = {
      "name": donationNameController.text,
      "type": _selectedValue,
      "amount": donationamountController.text,
      "id": controller.roomdetails['id']
    };

    var cmddetails = await Diorequest().post("k4/donation", json_body);

    isLoading = false;

    if (cmddetails['success']) {
      controller.donate = true;
      controller.bigbluebuttonsdkPlugin.sendmessage(
          chatid: "MAIN-PUBLIC-GROUP-CHAT",
          message:
              "Donation created|${donationNameController.text}|2|10000000|7");
      controller.bigbluebuttonsdkPlugin.stoptyping();
      // ["{\"msg\":\"method\",\"id\":\"428\",\"method\":\"sendGroupChatMsg\",\"params\":[\"MAIN-PUBLIC-GROUP-CHAT\",{\"correlationId\":\"w_nidxlpogyafr-1728639206402\",\"sender\":{\"id\":\"w_nidxlpogyafr\",\"name\":\"\",\"role\":\"\"},\"chatEmphasizedText\":true,\"message\":\"Donation created|help the needy|2|10000000|7\"}]}"]
      // ["{\"msg\":\"method\",\"id\":\"429\",\"method\":\"stopUserTyping\",\"params\":[]}"]
    } else {
      // isLoading = false;
      if (cmddetails['message'] != "No internet connection") {
        Get.defaultDialog(content: Text(cmddetails['message']));
        // showCommonError(cmddetails['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 580,
                  width: 400,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(62, 132, 102, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 75),
                        const Text(
                          'Donation Name',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                        TextFormField(
                          cursorColor: Colors.white,
                          controller: donationNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "this field cannot be empty";
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(93, 149, 126, 1),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide.none)),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Donation Amount',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                        // const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Fixed',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Radio(
                              value: 1,
                              groupValue: _selectedValue,
                              onChanged: (value) => setState(() {
                                _selectedValue = value as int;
                              }),
                              activeColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.white;
                                }
                                return Colors.white;
                              }),
                            ),
                            const SizedBox(width: 10),
                            const Text('Any amount',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Radio(
                              value: 2,
                              groupValue: _selectedValue,
                              onChanged: (value) => setState(() {
                                _selectedValue = value as int;
                              }),
                              activeColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.white;
                                }
                                return Colors.white;
                              }),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 190,
                          height: 58,
                          child: TextFormField(
                            controller: donationamountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "this field cannot be empty";
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                                hintText: '1000.00',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                filled: true,
                                fillColor: Color.fromRGBO(93, 149, 126, 1),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide.none)),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              side: const BorderSide(color: Colors.white),
                              value: _flashEnabled,
                              onChanged: (value) =>
                                  setState(() => _flashEnabled = value!),
                              activeColor: Colors.white,
                            ),
                            const Text('Enable flash notifications',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          ],
                        ),

                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!isLoading &&
                                    formKey.currentState!.validate() &&
                                    _selectedValue != null) {
                                  validateMeeting();
                                  Get.back();
                                }
                              },
                              child: Container(
                                  height: 48,
                                  width: 151,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(93, 149, 126, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: const Center(
                                      child: Text('Create',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)))),
                            ),
                          ],
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
    );
  }
}
