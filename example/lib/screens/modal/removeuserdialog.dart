import 'dart:ui';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';


class Removeuserdialog extends StatefulWidget {
  final Participant participan;

  const Removeuserdialog({Key? key, required this.participan})
      : super(key: key);

  @override
  State<Removeuserdialog> createState() => _RemoveuserdialogState();
}

class _RemoveuserdialogState extends State<Removeuserdialog> {

  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.1),
        body: Center(
          child: GetBuilder<postjoinController>(builder: (logic) {
            return Container(
              height: 200,
              width: 350,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(62, 139, 102, 1),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    const Center(
                        child: Text('Remove user (Debbie)', style: TextStyle(
                            fontSize: 20, color: Colors.white),)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            side: const BorderSide(color: Colors.white),
                            checkColor: Colors.greenAccent,
                            activeColor: Colors.white,
                            value: valuefirst,
                            onChanged: (bool? value) {
                              setState(() {
                                valuefirst = value!;
                              });
                            }
                        ),
                        const Text(
                          'Prevent this user from rejoining the session',
                          style: TextStyle(color: Colors.white, fontSize: 12),),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            logic.bigbluebuttonsdkPlugin.removeuser(userid:widget.participan.fields!.userId!, notallowagain:valuefirst);
                          },
                          child: Container(
                              height: 48,
                              width: 98,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(93, 149, 126, 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)),
                              ),
                              child: const Center(child: Text('Yes',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)))
                          ),
                        ),
                        const SizedBox(width: 10,),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        },
                            child: const Text('No', style: TextStyle(
                                color: Colors.white, fontSize: 16)))
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
