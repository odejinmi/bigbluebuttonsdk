import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/annotations.dart';
import '../whiteboard/flutter_painter.dart';
import 'websocket.dart';

class Whiteboardcontroller extends GetxController {
  final Websocket websocket = Get.find<Websocket>();

  final Color red = const Color(0xFFFF0000);
  final FocusNode textFocusNode = FocusNode();

  late final PainterController controller;

  final Map<String, Drawable> _annotationDrawablesById = {};

  static const List<String> imageLinks = [
    "https://i.imgur.com/btoI5OX.png",
    "https://i.imgur.com/EXTQFt7.png",
    "https://i.imgur.com/EDNjJYL.png",
    "https://i.imgur.com/uQKD6NL.png",
    "https://i.imgur.com/cMqVRbl.png",
    "https://i.imgur.com/1cJBAfI.png",
    "https://i.imgur.com/eNYfHKL.png",
    "https://i.imgur.com/c4Ag5yt.png",
    "https://i.imgur.com/GhpCJuf.png",
    "https://i.imgur.com/XVMeluF.png",
    "https://i.imgur.com/mt2yO6Z.png",
    "https://i.imgur.com/rw9XP1X.png",
    "https://i.imgur.com/pD7foZ8.png",
    "https://i.imgur.com/13Y3vp2.png",
    "https://i.imgur.com/ojv3yw1.png",
    "https://i.imgur.com/f8ZNJJ7.png",
    "https://i.imgur.com/BiYkHzw.png",
    "https://i.imgur.com/snJOcEz.png",
    "https://i.imgur.com/b61cnhi.png",
    "https://i.imgur.com/FkDFzYe.png",
    "https://i.imgur.com/P310x7d.png",
    "https://i.imgur.com/5AHZpua.png",
    "https://i.imgur.com/tmvJY4r.png",
    "https://i.imgur.com/PdVfGkV.png",
    "https://i.imgur.com/1PRzwBf.png",
    "https://i.imgur.com/VeeMfBS.png",
  ];

  @override
  void onInit() {
    super.onInit();
    controller = _createPainterController();
    textFocusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    controller.notifyListeners();
  }

  @override
  void onClose() {
    textFocusNode.removeListener(_onFocusChanged);
    controller.textFocusNode = null;
    textFocusNode.dispose();
    super.onClose();
  }

  PainterController _createPainterController() {
    final shapePaint = Paint()
      ..strokeWidth = 5
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final controller = PainterController(
      settings: PainterSettings(
        text: TextSettings(
          focusNode: textFocusNode,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: red,
            fontSize: 18,
          ),
        ),
        freeStyle: FreeStyleSettings(
          color: red,
          strokeWidth: 5,
        ),
        shape: ShapeSettings(
          paint: shapePaint,
        ),
        scale: const ScaleSettings(
          enabled: true,
          minScale: 1,
          maxScale: 5,
        ),
      ),
    );

    controller.virtualCanvasSize = const Size(800, 600);
    controller.background = Colors.white.backgroundDrawable;

    return controller;
  }

  void parsedata(dynamic data) {
    _syncVirtualCanvasToSlideIfAvailable();

    final collection = data is Map ? data["collection"] : null;
    if (collection != "annotations") return;

    final msg = data["msg"];
    if (msg == "removed") {
      _removeAnnotationDrawable(data["id"]?.toString());
      return;
    }
    if (msg != "added" && msg != "changed") return;

    final annotation = annotationsFromJson(jsonEncode(data as Map));
    final info = annotation.fields?.annotationInfo;
    if (info?.isComplete != true) return;
    if (info?.type != "draw") return;

    _upsertAnnotationDrawable(annotation);
  }

  void _removeAnnotationDrawable(String? id) {
    if (id == null) return;
    final drawable = _annotationDrawablesById.remove(id);
    if (drawable == null) return;
    controller.removeDrawable(drawable);
  }

  void _upsertAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final origin = info.point;
    final points = info.points;
    if (origin == null || origin.length < 2) return;
    if (points == null || points.isEmpty) return;

    final originX = origin[0];
    final originY = origin[1];

    final path = <Offset>[];
    for (final p in points) {
      if (p.length < 2) continue;
      path.add(Offset(originX + p[0], originY + p[1]));
    }
    if (path.isEmpty) return;

    final drawable = FreeStyleDrawable(
      path: path,
      color: _annotationColor(info),
      strokeWidth: _annotationStrokeWidth(info),
    );

    final ids = <String>{
      if (annotation.id != null) annotation.id!,
      if (annotation.fields?.id != null) annotation.fields!.id!,
      if (info.id != null) info.id!,
    };

    for (final id in ids) {
      _removeAnnotationDrawable(id);
      _annotationDrawablesById[id] = drawable;
    }

    controller.addDrawables([drawable], newAction: true);
    _ensureVirtualCanvasSize(path, drawable.strokeWidth);
  }

  void _ensureVirtualCanvasSize(List<Offset> path, double strokeWidth) {
    if (path.isEmpty) return;
    if (_syncVirtualCanvasToSlideIfAvailable()) return;

    var maxX = path.first.dx;
    var maxY = path.first.dy;
    for (final p in path) {
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy > maxY) maxY = p.dy;
    }

    final padding = strokeWidth * 2;
    final requiredWidth = maxX + padding;
    final requiredHeight = maxY + padding;

    final current = controller.virtualCanvasSize;
    final next = Size(
      current == null
          ? requiredWidth
          : (current.width > requiredWidth ? current.width : requiredWidth),
      current == null
          ? requiredHeight
          : (current.height > requiredHeight ? current.height : requiredHeight),
    );
    controller.virtualCanvasSize = next;
  }

  bool _syncVirtualCanvasToSlideIfAvailable() {
    final slide = websocket.currentSlide;
    if (slide is! Map) return false;
    final fields = slide["fields"];
    if (fields is! Map) return false;

    final widthRaw =
        fields["width"] ?? fields["svgWidth"] ?? fields["originalWidth"];
    final heightRaw =
        fields["height"] ?? fields["svgHeight"] ?? fields["originalHeight"];

    final width = _toDouble(widthRaw);
    final height = _toDouble(heightRaw);
    if (width == null || height == null) return false;
    if (width <= 0 || height <= 0) return false;

    final next = Size(width, height);
    controller.virtualCanvasSize = next;
    return true;
  }

  double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Color _annotationColor(AnnotationInfo info) {
    final name = info.name?.toLowerCase();
    if (name == "highlight") return const Color(0xFFFFD400);

    final raw = info.style?.color?.toLowerCase();
    switch (raw) {
      case "black":
        return Colors.black;
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      case "yellow":
        return Colors.yellow;
      case "white":
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  double _annotationStrokeWidth(AnnotationInfo info) {
    final name = info.name?.toLowerCase();
    if (name == "highlight") return 28;

    final size = info.style?.size?.toLowerCase();
    switch (size) {
      case "s":
        return 3;
      case "m":
        return 6;
      case "l":
        return 10;
      default:
        return 6;
    }
  }

  IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return Icons.linear_scale_sharp;
    if (shapeFactory is ArrowFactory) return Icons.arrow_forward;
    if (shapeFactory is DoubleArrowFactory) return Icons.arrow_back;
    if (shapeFactory is RectangleFactory) return Icons.rectangle_outlined;
    if (shapeFactory is OvalFactory) return Icons.circle_outlined;
    return Icons.polyline;
  }

  void undo() => controller.undo();

  void redo() => controller.redo();

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  void addText() {
    if (controller.freeStyleMode != FreeStyleMode.none) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    controller.addText();
  }

  Future<void> addSticker(BuildContext context) async {
    final imageLink = await showDialog<String>(
      context: context,
      builder: (context) => const SelectStickerImageDialog(
        imagesLinks: imageLinks,
      ),
    );
    if (imageLink == null) return;
    controller.addImage(
      await NetworkImage(imageLink).image,
      const Size(100, 100),
    );
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void setTextFontSize(double size) {
    controller.textSettings = controller.textSettings.copyWith(
      textStyle: controller.textSettings.textStyle.copyWith(fontSize: size),
    );
    controller.notifyListeners();
  }

  void setShapeFactoryPaint(Paint paint) {
    controller.shapePaint = paint;
    controller.notifyListeners();
  }

  void setTextColor(double hue) {
    controller.textStyle =
        controller.textStyle.copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }

  void selectShape(ShapeFactory? factory) {
    controller.shapeFactory = factory;
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;
    controller.replaceDrawable(
      imageDrawable,
      imageDrawable.copyWith(flipped: !imageDrawable.flipped),
    );
  }
}

class SelectStickerImageDialog extends StatelessWidget {
  final List<String> imagesLinks;

  const SelectStickerImageDialog({super.key, this.imagesLinks = const []});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select sticker"),
      content: imagesLinks.isEmpty
          ? const Text("No images")
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in imagesLinks)
                      InkWell(
                        onTap: () => Navigator.pop(context, imageLink),
                        child: FractionallySizedBox(
                          widthFactor: 1 / 4,
                          child: Image.network(imageLink),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
