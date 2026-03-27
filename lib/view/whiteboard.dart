import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../provider/whiteboardcontroller.dart';
import '../whiteboard/flutter_painter.dart';

class Whiteboard extends GetView<Whiteboardcontroller> {
  const Whiteboard({super.key});

 
  @override
  Widget build(BuildContext context) {
    final shapePaint = Paint()
      ..strokeWidth = 5
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: AspectRatio(
                aspectRatio: (controller.controller.virtualCanvasSize?.width ?? 4) /
                    (controller.controller.virtualCanvasSize?.height ?? 3),
                child: FlutterPainter(
                  controller: controller.controller,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: ValueListenableBuilder(
              valueListenable: controller.controller,
              builder: (context, _, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.white54,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.controller.freeStyleMode != FreeStyleMode.none)
                            ...[
                              const Divider(),
                              const Text("Free Style Settings"),
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                      min: 2,
                                      max: 25,
                                      value: controller.controller.freeStyleStrokeWidth,
                                      onChanged: controller.setFreeStyleStrokeWidth,
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.controller.freeStyleMode == FreeStyleMode.draw)
                                Row(
                                  children: [
                                    const Expanded(flex: 1, child: Text("Color")),
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                          controller.controller.freeStyleColor,
                                        ).hue,
                                        activeColor: controller.controller.freeStyleColor,
                                        onChanged: controller.setFreeStyleColor,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          if (controller.textFocusNode.hasFocus) ...[
                            const Divider(),
                            const Text("Text settings"),
                            Row(
                              children: [
                                const Expanded(flex: 1, child: Text("Font Size")),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    min: 8,
                                    max: 96,
                                    value: controller.controller.textStyle.fontSize ?? 14,
                                    onChanged: controller.setTextFontSize,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(flex: 1, child: Text("Color")),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    min: 0,
                                    max: 359.99,
                                    value: HSVColor.fromColor(
                                      controller.controller.textStyle.color ?? controller.red,
                                    ).hue,
                                    activeColor: controller.controller.textStyle.color,
                                    onChanged: controller.setTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (controller.controller.shapeFactory != null) ...[
                            const Divider(),
                            const Text("Shape Settings"),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1, child: Text("Stroke Width")),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    min: 2,
                                    max: 25,
                                    value: controller.controller.shapePaint?.strokeWidth ??
                                        shapePaint.strokeWidth,
                                    onChanged: (value) => controller.setShapeFactoryPaint(
                                      (controller.controller.shapePaint ?? shapePaint)
                                          .copyWith(strokeWidth: value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(flex: 1, child: Text("Color")),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    min: 0,
                                    max: 359.99,
                                    value: HSVColor.fromColor(
                                      (controller.controller.shapePaint ?? shapePaint).color,
                                    ).hue,
                                    activeColor:
                                        (controller.controller.shapePaint ?? shapePaint).color,
                                    onChanged: (hue) => controller.setShapeFactoryPaint(
                                      (controller.controller.shapePaint ?? shapePaint).copyWith(
                                        color:
                                            HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(flex: 1, child: Text("Fill shape")),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Switch(
                                      value: (controller.controller.shapePaint ?? shapePaint)
                                              .style ==
                                          PaintingStyle.fill,
                                      onChanged: (value) => controller.setShapeFactoryPaint(
                                        (controller.controller.shapePaint ?? shapePaint).copyWith(
                                          style: value
                                              ? PaintingStyle.fill
                                              : PaintingStyle.stroke,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 0,
            left: 0,
            child: ValueListenableBuilder(
              valueListenable: controller.controller,
              builder: (context, _, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: controller.controller.selectedObjectDrawable == null
                        ? null
                        : controller.removeSelectedDrawable,
                  ),
                  IconButton(
                    icon: const Icon(Icons.flip),
                    onPressed: controller.controller.selectedObjectDrawable != null &&
                        controller.controller.selectedObjectDrawable is ImageDrawable
                        ? controller.flipSelectedImageDrawable
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: controller.controller.canRedo ? controller.redo : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo),
                    onPressed: controller.controller.canUndo ? controller.undo : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: controller.controller,
        builder: (context, _, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: controller.controller.freeStyleMode == FreeStyleMode.erase
                    ? Colors.yellow
                    : null,
              ),
              onPressed: controller.toggleFreeStyleErase,
            ),
            IconButton(
              icon: Icon(
                Icons.draw,
                color: controller.controller.freeStyleMode == FreeStyleMode.draw
                    ? Colors.yellow
                    : null,
              ),
              onPressed: controller.toggleFreeStyleDraw,
            ),
            IconButton(
              icon: Icon(
                Icons.text_fields,
                color: controller.textFocusNode.hasFocus ? Colors.yellow : null,
              ),
              onPressed: controller.addText,
            ),
            IconButton(
              icon: const Icon(Icons.sticky_note_2),
              onPressed: (){
                controller.addSticker(context);
              }
            ),
            if (controller.controller.shapeFactory == null)
              PopupMenuButton<ShapeFactory?>(
                itemBuilder: (context) => <ShapeFactory, String>{
                  LineFactory(): "Line",
                  ArrowFactory(): "Arrow",
                  DoubleArrowFactory(): "Double Arrow",
                  RectangleFactory(): "Rectangle",
                  OvalFactory(): "Oval",
                }
                    .entries
                    .map(
                      (e) => PopupMenuItem(
                        value: e.key,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(controller.getShapeIcon(e.key), color: Colors.black),
                            Text(" ${e.value}"),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onSelected: controller.selectShape,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    controller.getShapeIcon(controller.controller.shapeFactory),
                    color:
                        controller.controller.shapeFactory != null ? Colors.yellow : null,
                  ),
                ),
              )
            else
              IconButton(
                icon: Icon(
                  controller.getShapeIcon(controller.controller.shapeFactory),
                  color: Colors.yellow,
                ),
                onPressed: () => controller.selectShape(null),
              ),
          ],
        ),
      ),
    );
  }

}
