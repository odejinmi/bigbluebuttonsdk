import 'dart:ui';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/postjoin_controller.dart';

class Changeroledialog extends StatefulWidget {
  final Participant participan;

  const Changeroledialog({Key? key, required this.participan})
    : super(key: key);

  @override
  _ChangeroledialogState createState() => _ChangeroledialogState();
}

class _ChangeroledialogState extends State<Changeroledialog> {
  String _topSelectedDDItem = 'Viewer';
  List<String> topItemsDD = [];

  @override
  Widget build(BuildContext context) {
    topItemsDD = [];
    if (!widget.participan.fields!.presenter!) {
      topItemsDD.add('PRESENTER');
    }
    if (widget.participan.fields!.role! != "MODERATOR") {
      topItemsDD.add('MODERATOR');
    }
    if (widget.participan.fields!.role! != "VIEWER") {
      topItemsDD.add('VIEWER');
    }
    return GetBuilder<postjoinController>(
      builder: (logic) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Scaffold(
            backgroundColor: Colors.transparent.withOpacity(0.1),
            body: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(62, 139, 102, 1),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      const Text(
                        'Change Role',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'Change the role of "${widget.participan.fields!.name}" to',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      const SizedBox(height: 30),

                      Container(
                        width: 328,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(93, 149, 126, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                _topSelectedDDItem,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: const Color.fromRGBO(
                                  93,
                                  149,
                                  126,
                                  1,
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                                items: topItemsDD.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _topSelectedDDItem = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 48,
                              width: 111,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 40),

                          GestureDetector(
                            onTap: () {
                              Get.back();
                              if (_topSelectedDDItem != "PRESENTER") {
                                logic.bigbluebuttonsdkPlugin.changerole(
                                  userid: widget.participan.fields!.userId!,
                                  role: _topSelectedDDItem,
                                );
                              } else {
                                logic.bigbluebuttonsdkPlugin.assignpresenter(
                                  userid: widget.participan.fields!.userId!,
                                );
                              }
                            },
                            child: Container(
                              height: 48,
                              width: 111,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(93, 149, 126, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Change Role',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
