import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EndRecordingDialog extends StatelessWidget {
  EndRecordingDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 25),
        child: Container(
          width: 342,
          height: 200,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(62, 132, 102, 1),
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Color.fromRGBO(204, 82, 95, 1)),
                      SizedBox(width: 10),
                      Text('End Recording', style: TextStyle(color: Color.fromRGBO(204, 82, 95, 1), fontSize: 20, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                          
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text(
                    'Are you sure you want to end recording? \nYou can’t undo this action.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    ),
                  ),
                ),
                          
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 130,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(62, 132, 102, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                          onPressed: (){Navigator.pop(context);},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(5),
                            side: const BorderSide(width: 0.5, color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color.fromRGBO(62, 132, 102, 1)
                          ), 
                          child: const Center(child: Text("Don't End", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),)),
                        ),
                    ),
                    
                          
                    Container(
                      width: 130,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(204, 82, 95, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: (){
                          // controller.stopRecording();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color.fromRGBO(204, 82, 95, 1),
                        ), 
                        child: const Center(child: Text('End Recording', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

        ),
      ),
    );

  }
}