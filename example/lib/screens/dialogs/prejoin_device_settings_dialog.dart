import 'package:flutter/material.dart';

class DeviceSettings extends StatefulWidget {
  const DeviceSettings({super.key});

  @override
  State<DeviceSettings> createState() => _DeviceSettingsState();
}

class _DeviceSettingsState extends State<DeviceSettings> {
  String firstDropdownValue = 'HD Camera';
  String secondDropdownValue = 'High Definition';
  String thirdDropdownValue = 'Default - Phone mic';

  var firstItemsDropdown = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5',]; 
  var secondItemsDropdown = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5',]; 
  var thirdItemsDropdown = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5',];

  // String dropdownValue = 'HD Camera';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(0, 0, 0, 0.76),
      body: Center(
        child: Container(
          width: 360,
          height: 664,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(93, 149, 126, 1),
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(left: 10),
                      onPressed:() {
                        Navigator.pop(context);
                      }, 
                      icon: const Icon(Icons.arrow_back_ios), 
                      iconSize: 24,
                      color: Colors.white,
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(62, 132, 102, 1)))
                    ),

                    const Text('Device Settings', 
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                    ),
                    
                    // const SizedBox(width: 180,),
                    IconButton(
                      onPressed:() {

                      }, 
                      icon: const Icon(Icons.clear_rounded), 
                      iconSize: 24,
                      color: Colors.white,
                    ),
                  ],
                ),

                const SizedBox(height: 10,),
                const Divider(),
            
                const SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Video', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),),
                    const SizedBox(height: 10,),
                    Container(
                      width: 328,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(62, 132, 102, 1),
                        // border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: Colors.white,),
                          const SizedBox(width: 20,),
                          Text(firstDropdownValue,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                          ),
                          const SizedBox(width: 60,),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: const Color.fromRGBO(62, 132, 102, 1),
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 34,),
                              items: firstItemsDropdown.map((String items) { 
                                return DropdownMenuItem( 
                                  value: items, 
                                  child: Text(items, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),), 
                                );
                              }).toList(),
                              onChanged: (String? newValue) {  
                                setState(() { 
                                  firstDropdownValue = newValue!; 
                                }); 
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Video Quality', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),),
                    const SizedBox(height: 10,),
                    Container(
                      width: 328,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(62, 132, 102, 1),
                        // border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(secondDropdownValue,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                            ),
                          ),

                          const SizedBox(width: 30,),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: const Color.fromRGBO(62, 132, 102, 1),
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 34,),
                              items: secondItemsDropdown.map((String items) { 
                                return DropdownMenuItem( 
                                  value: items, 
                                  child: Text(items, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),), 
                                );
                              }).toList(),
                              onChanged: (String? newValue) {  
                                setState(() { 
                                  secondDropdownValue = newValue!; 
                                }); 
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Microphone', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),),
                    
                    const SizedBox(height: 10,),
                    Container(
                      width: 328,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(62, 132, 102, 1),
                        // border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.mic_none_rounded, color: Colors.white,),
                          
                          const SizedBox(width: 20,),
                          Text(thirdDropdownValue,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                          ),
                          
                          const SizedBox(width: 60,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: const Color.fromRGBO(62, 132, 102, 1),
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 34,),
                                  items: thirdItemsDropdown.map((String items) { 
                                    return DropdownMenuItem( 
                                      value: items, 
                                      child: Text(items, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),), 
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {  
                                    setState(() { 
                                      thirdDropdownValue = newValue!; 
                                    }); 
                                  }
                                ),
                              ),
                            ],
                          ),
                      
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}