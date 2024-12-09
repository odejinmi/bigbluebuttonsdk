import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

import '../provider/websocket.dart';
import '../provider/whiteboardcontroller.dart';
import '../utils/Drawingpainter.dart';
import '../utils/Drawnpath.dart';
import 'annotations.dart';
import 'main.dart';

class Whiteboard extends GetView<Whiteboardcontroller> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FlutterPainterExample();
    // return GetBuilder<Websocket>(builder: (logic) {
    //   return Column(
    //     children: [
    //       Row(
    //         children: [
    //           IconButton(
    //             icon: Icon(Icons.draw),
    //             onPressed: () => controller.currentMode = "draw",
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.change_history),
    //             onPressed: () => controller.currentMode = "triangle",
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.crop_square),
    //             onPressed: () => controller.currentMode = "rectangle",
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.panorama_fish_eye),
    //             onPressed: () => controller.currentMode = "ellipse",
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.delete),
    //             onPressed: () => controller.currentMode = "eraser",
    //           ),
    //           IconButton(
    //             icon: Icon(Icons.text_fields),
    //             onPressed: () => controller.currentMode = "text",
    //           ),
    //         ],
    //       ),
    //       Expanded(
    //         // child: Card(
    //         //   clipBehavior: Clip.hardEdge,
    //         //   margin: EdgeInsets.zero,
    //         //   color: Colors.white,
    //         //   surfaceTintColor: Colors.white,
    //         //   child: CustomPaint(
    //         //     painter: DrawingPainter(paths),
    //         //     child: Scribble(
    //         //       notifier: notifier,
    //         //       drawPen: true,
    //         //     ),
    //         //   ),
    //         // ),
    //         child: Row(
    //           children: [
    //             Expanded(
    //               child: Container(
    //                 width: screenSize.width,
    //                 // height: screenSize.height-300,
    //                 child: GestureDetector(
    //                   onTapUp: controller.onCanvasTap,
    //                   onPanStart: (details) {
    //                     if (controller.currentMode == "eraser") {
    //                       controller.erase(position: details.localPosition);
    //                     } else {
    //                       controller.startPoint = details.localPosition;
    //                       controller.currentPathPoints = [[details.localPosition.dx,details.localPosition.dy]];
    //                     }
    //                   },
    //                   onPanUpdate: (details) {
    //                     if (controller.currentMode == "draw") {
    //                       controller.currentPathPoints.add([details.localPosition.dx,details.localPosition.dy]);
    //                     } else if (controller.currentMode == "eraser") {
    //                       controller.erase(position: details.localPosition);
    //                       // } else if (controller.currentMode == DrawMode.pointer) {
    //                       //   controller.pointerPosition = details.localPosition;
    //                     } else {
    //                       controller.currentPathPoints =
    //                       <List<double>>[[controller.startPoint![0],controller.startPoint![1]], [details.localPosition.dx, details.localPosition.dy]];
    //                     }
    //                     controller.pointerPosition = details.localPosition;
    //                   },
    //                   onPanEnd: (details) {
    //                     if (controller.currentMode == "draw") {
    //                       controller.pathse.add(
    //                           Annotations(
    //                             fields: Fields(
    //                                 annotationInfo: AnnotationInfo(
    //                                     point: List.from(controller.currentPathPoints),
    //                                     style: Style(
    //                                         scale: controller.currentStrokeWidth,
    //                                         color: controller.currentColor
    //                                     ),
    //                                     type: controller.currentMode
    //                                 )
    //                             ),));
    //                       controller.currentPathPoints.clear();
    //                     } else if (controller.currentMode != "eraser") {
    //                       controller.addShape(
    //                           controller.startPoint!, details.localPosition);
    //                       controller.currentPathPoints.clear();
    //                     } //else if (controller.currentMode == DrawMode.pointer) {
    //                     controller.pointerPosition = null; // Hide pointer when touch ends
    //                     // }
    //                     print("controller.exportToJson()");
    //                     print(controller.exportToJson());
    //                   },
    //                   child: Stack(
    //                     children: [
    //                       Transform.scale(
    //                         scale: controller.zoomLevel,
    //                         child: SvgPicture.network(
    //                           logic.currentslide["fields"]["svgUri"],
    //                           width: screenSize.width,
    //                           semanticsLabel: 'A shark?!',
    //                           placeholderBuilder: (BuildContext context) => Container(
    //                             padding: const EdgeInsets.all(30.0),
    //                             child: const CircularProgressIndicator(),
    //                           ),
    //                         ),
    //                       ),
    //                       ClipRect(
    //                         child: Align(
    //                           alignment: Alignment.center, // Aligns the drawing to the same position as the image
    //                           child: SizedBox(
    //                             width: screenSize.width, // Ensures the CustomPaint matches the background image's dimensions
    //                             height: screenSize.height - 300, // Optional: adjust this based on your layout needs
    //                             child: CustomPaint(
    //                               painter: DrawingPainter(
    //                                 paths: controller.pathse,
    //                                 currentPathPoints: controller.currentPathPoints,
    //                                 color: controller.currentColor,
    //                                 strokeWidth: controller.currentStrokeWidth,
    //                                 mode: controller.currentMode,
    //                                 actions: controller.actions,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       // Pointer Indicator
    //                       if ( controller.pointerPosition != null)
    //                         Positioned(
    //                           left: controller.pointerPosition![0] - 10,
    //                           top: controller.pointerPosition![1] - 10,
    //                           child: Container(
    //                             width: 20,
    //                             height: 20,
    //                             decoration: BoxDecoration(
    //                               shape: BoxShape.circle,
    //                               color: Colors.red.withOpacity(0.6),
    //                             ),
    //                           ),
    //                         ),
    //                       if (controller.currentMode == "text" &&
    //                           controller.textPosition != null)
    //                         Positioned(
    //                           left: controller.textPosition!.dx,
    //                           top: controller.textPosition!.dy,
    //                           child: Container(
    //                             width: 150,
    //                             child: TextField(
    //                               autofocus: true,
    //                               onChanged: (value) => controller.currentText = value,
    //                               onSubmitted: (value) {
    //                                 controller.currentText = value;
    //                                 controller.addTextEntry();
    //                               },
    //                               decoration: InputDecoration(
    //                                 hintText: "Type here",
    //                                 border: OutlineInputBorder(),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Column(
    //               children: [
    //                 IconButton(
    //                   icon: Icon(Icons.arrow_back),
    //                   onPressed: () =>
    //                   controller.currentMode = "draw",
    //                 ),
    //                 IconButton(
    //                   icon: Icon(Icons.draw),
    //                   onPressed: () =>
    //                   controller.currentMode = "draw",
    //                 ),
    //                 IconButton(
    //                   icon: Icon(Icons.change_history),
    //                   onPressed: () =>
    //                   controller.currentMode = "triangle",
    //                 ),
    //                 IconButton(
    //                   icon: Icon(Icons.crop_square),
    //                   onPressed: () =>
    //                   controller.currentMode = "rectangle",
    //                 ),
    //                 IconButton(
    //                   icon: Icon(Icons.panorama_fish_eye),
    //                   onPressed: () =>
    //                   controller.currentMode = "ellipse",
    //                 ),
    //                 IconButton(
    //                   icon: Icon(Icons.delete),
    //                   onPressed: () =>
    //                   controller.currentMode = "eraser",
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //       // Padding(
    //       //   padding: const EdgeInsets.all(16),
    //       //   child: Row(
    //       //     children: [
    //       //       _buildColorToolbar(context),
    //       //       const VerticalDivider(width: 32),
    //       //       _buildStrokeToolbar(context),
    //       //       const Expanded(child: SizedBox()),
    //       //       _buildPointerModeSwitcher(context),
    //       //     ],
    //       //   ),
    //       // ),
    //       if (logic.mydetails != null &&
    //           logic.mydetails!.fields!.presenter!)
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             // Previous Slide Button
    //             InkWell(
    //               child: Icon(Icons.arrow_back_ios,
    //                 color: controller.slideposition > 1 ? Colors.black : Colors
    //                     .grey,),
    //               onTap: () {
    //                 if (controller.slideposition > 1) {
    //                   controller.slideposition -= 1;
    //                   controller.nextpresentation(
    //                       page: "${controller
    //                           .slideposition}");
    //                 }
    //               },
    //             ),
    //             // Slide Selector Dropdown
    //             DropdownButton<int>(
    //               value: logic.currentslide["fields"]["num"],
    //               // Initial value, make sure this is dynamic if needed
    //               items: List.generate(
    //                 logic.slides.length,
    //                     (index) =>
    //                     DropdownMenuItem<int>(
    //                       value: index + 1,
    //                       child: Text('Slide ${index + 1}'),
    //                     ),
    //               ),
    //               onChanged: (int? newValue) {
    //                 controller.slideposition = newValue!;
    //                 controller.nextpresentation(
    //                     page: "${controller.slideposition}");
    //                 // Action when a slide is selected
    //               },
    //             ),
    //             // Next Slide Button
    //             InkWell(
    //               child: Icon(Icons.arrow_forward_ios,
    //                 color: controller.slideposition < logic.slides.length
    //                     ? Colors.black
    //                     : Colors.grey,),
    //               onTap: () {
    //                 if (controller.slideposition < logic.slides.length) {
    //                   controller.slideposition += 1;
    //                   controller.nextpresentation(
    //                       page: "${controller
    //                           .slideposition}");
    //                 }
    //                 // Action for next slide
    //               },
    //             ),
    //             // Image Icon Button
    //             InkWell(
    //               child: Icon(Icons.insert_chart_outlined,),
    //               onTap: () {
    //                 // Action for image button
    //               },
    //             ),
    //             // Zoom Out Button
    //             InkWell(
    //               child: Icon(Icons.remove),
    //               onTap: () {
    //                 controller.zoomOut();
    //                 // Action for zoom out
    //               },
    //             ),
    //             // Zoom Percentage Text
    //             Text('${controller.zoomPercentage}%'),
    //             // Zoom In Button
    //             InkWell(
    //               child: Icon(Icons.add,),
    //               onTap: () {
    //                 controller.zoomIn();
    //                 // Action for zoom in
    //               },
    //             ),
    //             // Full Screen Button
    //             InkWell(
    //               child: Icon(Icons.swap_horiz,),
    //               onTap: () {
    //                 controller.zoomOut();
    //                 // Action for full screen toggle
    //               },
    //             ),
    //           ],
    //         ),
    //     ],
    //   );
    // });
  }

}
