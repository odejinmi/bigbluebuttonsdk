import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';


class CaptionDialog extends StatefulWidget {
  const CaptionDialog({super.key});

  @override
  State<CaptionDialog> createState() => _CaptionDialogState();
}

class _CaptionDialogState extends State<CaptionDialog> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<postjoinController>(builder: (logic) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 90,
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(34, 116, 81, 1),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8))
                                ),
                                child: const SingleChildScrollView(
                                  child: Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                    style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),

                            Container(
                              height: 90,
                              width: 50,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(34, 116, 81, 1),
                                  border: Border(left: BorderSide(
                                      color: Colors.white, width: 0.5)),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Column(
                                    children: [
                                      GestureDetector(onTap: () {
                                        logic.captionButtonPressed = false;
                                        Navigator.pop(context);
                                      },
                                          child: const Icon(Icons.close,
                                              color: Colors.white)),
                                      const Expanded(child: Divider(
                                        color: Colors.white, thickness: 1,)),
                                      GestureDetector(onTap: () {
                                        showCaptionLanguageDialog();
                                      },
                                          child: const Icon(Icons.more_horiz,
                                            color: Colors.white,))
                                    ]

                                ),
                              ),
                            ),
                          ],
                        )
                    ),

                    const SizedBox(height: 90,)
                  ]
              )
          )
      );
    });
  }


  showCaptionLanguageDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 120,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(51, 125, 93, 1),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(onPressed: () {
                                      Navigator.pop(context);
                                    },
                                        icon: const Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: Colors.white,)),
                                    const Text('Caption Langauge',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),)
                                  ],
                                ),


                                Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(51, 125, 93, 1),
                                    border: Border.all(
                                        width: 0.5, color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: TextField(
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.search_rounded,
                                            color: Colors.white,),
                                          contentPadding: EdgeInsets.all(7.0),
                                          border: InputBorder.none,
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                              color: Colors.white)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          height: 370,
                          width: 360,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(3, 116, 81, 1),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))
                          ),
                          child: Scrollbar(
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: const [
                                ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('English', style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Italiano', style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Polski', style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Espanol', style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Yoruba', style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Igbo', style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                ),
                                ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text('Hausa', style: TextStyle(
                                      color: Colors.white, fontSize: 16),),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 90,)
                  ],
                ),
              )
          );
        }
    );
  }
}