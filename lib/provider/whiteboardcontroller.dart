import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/annotations.dart';
import '../whiteboard/flutter_painter.dart';
import '../utils/strings.dart';
import 'websocket.dart';

class Whiteboardcontroller extends GetxController {
  final Websocket websocket = Get.find<Websocket>();

  final Color red = const Color(0xFFFF0000);
  final FocusNode textFocusNode = FocusNode();

  late final PainterController controller;

  final Map<String, Drawable> _annotationDrawablesById = {};
  final Map<String, Drawable> _localDrawablesById = {};
  final RxInt currentPage = 1.obs;
  final Map<int, List<Drawable>> _pageDrawables = {1: <Drawable>[]};

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
    final type = info?.type;
    if (type == "draw") {
      if (info?.isComplete != true) return;
      _upsertAnnotationDrawable(annotation);
    } else if (type == "text") {
      _upsertTextAnnotationDrawable(annotation);
    } else if (type == "rectangle") {
      final name = info?.name?.toLowerCase();
      if (name == "triangle") {
        _upsertTriangleAnnotationDrawable(annotation);
        return;
      }
      if (name == "rhombus" || name == "diamond") {
        _upsertRhombusAnnotationDrawable(annotation);
        return;
      }
      if (name == "trapezoid") {
        _upsertTrapezoidAnnotationDrawable(annotation);
        return;
      }
      if (name == "hexagon") {
        _upsertHexagonAnnotationDrawable(annotation);
        return;
      }
      if (name == "cloud") {
        _upsertCloudAnnotationDrawable(annotation);
        return;
      }
      if (name == "star") {
        _upsertStarAnnotationDrawable(annotation);
        return;
      }
      if (name == "xbox") {
        _upsertXBoxAnnotationDrawable(annotation);
        return;
      }
      if (name == "checkbox") {
        _upsertCheckBoxAnnotationDrawable(annotation);
        return;
      }
      if (name == "frame") {
        _upsertRectangleAnnotationDrawable(annotation);
        return;
      }
      if (name == "arrowleft" ||
          name == "arrowright" ||
          name == "arrowup" ||
          name == "arrowdown") {
        _upsertDirectionArrowAnnotationDrawable(annotation, name!);
        return;
      }
      _upsertRectangleAnnotationDrawable(annotation);
    } else if (type == "arrow") {
      _upsertArrowAnnotationDrawable(annotation);
    } else if (type == "triangle") {
      _upsertTriangleAnnotationDrawable(annotation);
    } else if (type == "ellipse") {
      _upsertEllipseAnnotationDrawable(annotation);
    } else if (type == "rhombus") {
      _upsertRhombusAnnotationDrawable(annotation);
    } else if (type == "diamond") {
      _upsertRhombusAnnotationDrawable(annotation);
    } else if (type == "trapezoid") {
      _upsertTrapezoidAnnotationDrawable(annotation);
    } else if (type == "hexagon") {
      _upsertHexagonAnnotationDrawable(annotation);
    } else if (type == "cloud") {
      _upsertCloudAnnotationDrawable(annotation);
    } else if (type == "star") {
      _upsertStarAnnotationDrawable(annotation);
    } else if (type == "xbox") {
      _upsertXBoxAnnotationDrawable(annotation);
    } else if (type == "checkbox") {
      _upsertCheckBoxAnnotationDrawable(annotation);
    }
  }

  List<int> get pages => (_pageDrawables.keys.toList()..sort());

  void addNewPage() {
    _persistCurrentPageDrawables();
    final next = (pages.isEmpty ? 1 : (pages.last + 1));
    _pageDrawables.putIfAbsent(next, () => <Drawable>[]);
    _switchToPageInternal(next);
  }

  void selectPage(int page) {
    if (!_pageDrawables.containsKey(page)) return;
    _persistCurrentPageDrawables();
    _switchToPageInternal(page);
  }

  void _persistCurrentPageDrawables() {
    _pageDrawables[currentPage.value] =
        List<Drawable>.from(controller.value.drawables);
  }

  void _switchToPageInternal(int page) {
    currentPage.value = page;
    controller.clearDrawables(newAction: true);
    controller.performedActions.clear();
    controller.unperformedActions.clear();
    final drawables = _pageDrawables[page] ?? const <Drawable>[];
    if (drawables.isNotEmpty) {
      controller.addDrawables(drawables, newAction: true);
    }
  }

  void onDrawableCreated(Drawable drawable) {
    _persistCurrentPageDrawables();
    if (!websocket.isWebsocketRunning) return;
    Map<String, dynamic>? payload;
    if (drawable is FreeStyleDrawable) {
      payload = _buildBulkAnnotationPayload(drawable);
    } else if (drawable is TextDrawable) {
      payload = _buildTextAnnotationPayload(drawable);
    } else if (drawable is RectangleDrawable) {
      payload = _buildRectangleAnnotationPayload(drawable);
    } else if (drawable is ArrowDrawable) {
      payload = _buildArrowAnnotationPayload(drawable);
    } else if (drawable is TriangleDrawable) {
      payload = _buildTriangleAnnotationPayload(drawable);
    } else if (drawable is OvalDrawable) {
      payload = _buildEllipseAnnotationPayload(drawable);
    } else if (drawable is RhombusDrawable) {
      payload = _buildRhombusAnnotationPayload(drawable);
    } else if (drawable is TrapezoidDrawable) {
      payload = _buildTrapezoidAnnotationPayload(drawable);
    } else if (drawable is HexagonDrawable) {
      payload = _buildHexagonAnnotationPayload(drawable);
    } else if (drawable is CloudDrawable) {
      payload = _buildCloudAnnotationPayload(drawable);
    } else if (drawable is StarDrawable) {
      payload = _buildStarAnnotationPayload(drawable);
    } else if (drawable is XBoxDrawable) {
      payload = _buildXBoxAnnotationPayload(drawable);
    } else if (drawable is CheckBoxDrawable) {
      payload = _buildCheckBoxAnnotationPayload(drawable);
    }
    if (payload == null) return;
    final annotations = [payload];
    websocket.callMethod("sendBulkAnnotations", [annotations]);
  }

  void onDrawableDeleted(Drawable drawable) {
    final ids = _localDrawablesById.entries
        .where((e) => identical(e.value, drawable))
        .map((e) => e.key)
        .toList();
    for (final id in ids) {
      _localDrawablesById.remove(id);
    }
    _persistCurrentPageDrawables();
    if (ids.isEmpty) return;
    if (!websocket.isWebsocketRunning) return;
    websocket.callMethod("deleteAnnotations", [ids, "unknown-wb"]);
  }

  Map<String, dynamic>? _buildBulkAnnotationPayload(FreeStyleDrawable drawable) {
    final path = drawable.path;
    if (path.isEmpty) return null;

    final origin = path.first;
    final points = <List<double>>[];

    var maxDx = 0.0;
    var maxDy = 0.0;

    for (final p in path) {
      final dx = p.dx - origin.dx;
      final dy = p.dy - origin.dy;
      if (dx > maxDx) maxDx = dx;
      if (dy > maxDy) maxDy = dy;
      points.add([_round2(dx), _round2(dy), 0.5]);
    }

    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";

    final pageIndex = currentPage.value;

    final toolName = _toolNameForDrawable(drawable);
    final styleColor =
        toolName == "Highlight" ? "black" : _bbbColorName(drawable.color);
    final scale = toolName == "Highlight"
        ? 1.0
        : _clampDouble(drawable.strokeWidth / 6, min: 0.25, max: 6);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "draw",
        "name": toolName,
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(origin.dx), _round2(origin.dy)],
        "rotation": 0,
        "style": {
          "color": styleColor,
          "size": "m",
          "isFilled": false,
          "dash": "draw",
          "scale": _round2(scale),
          "textAlign": "start",
          "font": "script"
        },
        "points": points,
        "isComplete": true,
        "size": [_round2(maxDx), _round2(maxDy)],
        "userId": userId,
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "label": "",
        "labelPoint": [0.5, 0.5]
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildTextAnnotationPayload(TextDrawable drawable) {
    final text = drawable.text.trim();
    if (text.isEmpty) return null;

    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";

    final maxWidth = controller.virtualCanvasSize?.width ?? double.infinity;
    final size = drawable.getSize(maxWidth: maxWidth);
    final topLeft = drawable.position - Offset(size.width / 2, size.height / 2);

    final colorName = _bbbColorName(drawable.style.color ?? Colors.black);
    final pageIndex = currentPage.value;

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "text",
        "name": "Text",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(drawable.rotationAngle),
        "text": text,
        "style": {
          "color": colorName,
          "size": "m",
          "isFilled": false,
          "dash": "draw",
          "scale": 1,
          "font": "draw",
          "textAlign": "middle"
        },
        "userId": userId,
        "size": [_round2(size.width), _round2(size.height)],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        }
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildRectangleAnnotationPayload(
      RectangleDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "Rectangle",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildArrowAnnotationPayload(ArrowDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final angle = drawable.rotationAngle;
    final unit = Offset.fromDirection(angle, 1);
    final half = unit * (drawable.length / 2 * drawable.scale);
    final start = drawable.position - half;
    final end = drawable.position + half;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth, preferMedium: true);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "arrow",
        "name": "Arrow",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(start.dx), _round2(start.dy)],
        "rotation": 0,
        "bend": 0,
        "decorations": {"end": "arrow"},
        "style": {
          "isFilled": false,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "handles": {
          "start": {"id": "start", "index": 0, "point": [0, 0], "canBind": true},
          "end": {
            "id": "end",
            "index": 1,
            "point": [_round2(dx), _round2(dy)],
            "canBind": true
          },
          "bend": {
            "id": "bend",
            "index": 2,
            "point": [_round2(dx / 2), _round2(dy / 2)],
            "canBind": true
          }
        },
        "size": [_round2(dx.abs()), _round2(dy.abs())],
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildTriangleAnnotationPayload(
      TriangleDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "triangle",
        "name": "Triangle",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildEllipseAnnotationPayload(OvalDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "ellipse",
        "name": "Ellipse",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildRhombusAnnotationPayload(
      RhombusDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "Rhombus",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildTrapezoidAnnotationPayload(
      TrapezoidDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "Trapezoid",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildHexagonAnnotationPayload(HexagonDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role = websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "Hexagon",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildCloudAnnotationPayload(CloudDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role =
        websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "Cloud",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildStarAnnotationPayload(StarDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role =
        websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final isFilled = drawable.paint.style == PaintingStyle.fill;
    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "Star",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": isFilled,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildXBoxAnnotationPayload(XBoxDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role =
        websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "XBox",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": false,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  Map<String, dynamic>? _buildCheckBoxAnnotationPayload(
      CheckBoxDrawable drawable) {
    final id = generateRandomId(21);
    _localDrawablesById[id] = drawable;

    final userId = websocket.myDetails?.fields?.userId ??
        websocket.meetingDetails?.internalUserId ??
        "";
    final role =
        websocket.myDetails?.fields?.role ?? websocket.meetingDetails?.role;
    final isModerator = role == "MODERATOR";
    final pageIndex = currentPage.value;

    final width = (drawable.size.width * drawable.scale).abs();
    final height = (drawable.size.height * drawable.scale).abs();
    final topLeft = drawable.position - Offset(width / 2, height / 2);

    final colorName = _bbbColorName(drawable.paint.color);
    final (sizeName, scale) =
        _bbbSizeAndScaleFromStrokeWidth(drawable.paint.strokeWidth);

    return {
      "id": id,
      "annotationInfo": {
        "id": id,
        "type": "rectangle",
        "name": "CheckBox",
        "parentId": "1",
        "childIndex": 0,
        "point": [_round2(topLeft.dx), _round2(topLeft.dy)],
        "rotation": _round2(_rotationFromRadians(drawable.rotationAngle)),
        "size": [_round2(width), _round2(height)],
        "style": {
          "isFilled": false,
          "size": sizeName,
          "scale": _round2(scale),
          "color": colorName,
          "textAlign": "start",
          "font": "draw",
          "dash": "draw"
        },
        "label": "",
        "labelPoint": [0.5, 0.5],
        "isModerator": isModerator,
        "meta": {
          "pageId": "page:page",
          "pageIndex": pageIndex,
          "whiteboardId": "unknown-wb",
          "ownerUserId": userId
        },
        "userId": userId,
      },
      "wbId": "unknown-wb",
      "userId": userId
    };
  }

  double _round2(double v) => (v * 100).roundToDouble() / 100;

  double _rotationToRadians(int? value) {
    if (value == null) return 0.0;
    final v = value.toDouble();
    if (v.abs() > 7) {
      return v * 3.141592653589793 / 180.0;
    }
    return v;
  }

  double _rotationFromRadians(double value) {
    if (value.abs() <= 7) {
      return value * 180.0 / 3.141592653589793;
    }
    return value;
  }

  (String, double) _bbbSizeAndScaleFromStrokeWidth(double strokeWidth,
      {bool preferMedium = false}) {
    final s = strokeWidth <= 4
        ? (preferMedium ? "small" : "s")
        : strokeWidth <= 8
            ? (preferMedium ? "medium" : "m")
            : strokeWidth <= 14
                ? (preferMedium ? "large" : "l")
                : (preferMedium ? "x-large" : "xl");
    final normalized = _normalizeStyleSize(s);
    final base = normalized == "s"
        ? 4.0
        : normalized == "m"
            ? 6.0
            : normalized == "l"
                ? 10.0
                : 14.0;
    final scale = _clampDouble(strokeWidth / base, min: 0.25, max: 6);
    return (s, scale);
  }

  String _normalizeStyleSize(String? size) {
    switch (size?.toLowerCase()) {
      case "s":
      case "small":
        return "s";
      case "m":
      case "medium":
        return "m";
      case "l":
      case "large":
        return "l";
      case "xl":
      case "x-large":
        return "xl";
      default:
        return "m";
    }
  }

  double _fontSizeForStyleSize(String? size) {
    switch (size?.toLowerCase()) {
      case "s":
        return 14;
      case "m":
        return 18;
      case "l":
        return 24;
      case "xl":
        return 32;
      default:
        return 18;
    }
  }

  double _clampDouble(double v, {required double min, required double max}) {
    if (v < min) return min;
    if (v > max) return max;
    return v;
  }

  String _toolNameForDrawable(FreeStyleDrawable drawable) {
    final c = drawable.color;
    final isHighlightColor =
        c.value == const Color(0xFFFFD400).value || c.value == Colors.yellow.value;
    if (isHighlightColor || drawable.strokeWidth >= 18) {
      return "Highlight";
    }
    return "Draw";
  }

  String _bbbColorName(Color color) {
    final hsv = HSVColor.fromColor(color);
    if (hsv.saturation < 0.15) {
      return hsv.value < 0.35 ? "black" : "white";
    }
    final h = hsv.hue;
    if (h >= 45 && h < 75) return "yellow";
    if (h >= 75 && h < 165) return "green";
    if (h >= 165 && h < 255) return "blue";
    if (h >= 255 && h < 345) return "purple";
    return "red";
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
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

  void _upsertTextAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;
    final text = info.text?.trim();
    if (text == null || text.isEmpty) return;

    final point = info.point;
    if (point == null || point.length < 2) return;

    final sizeList = info.size;
    final width = (sizeList != null && sizeList.isNotEmpty) ? sizeList[0] : 0.0;
    final height = (sizeList != null && sizeList.length > 1) ? sizeList[1] : 0.0;
    final topLeft = Offset(point[0], point[1]);
    final center = topLeft + Offset(width / 2, height / 2);

    final rotation = _rotationToRadians(info.rotation);
    final styleSize = info.style?.size;
    final baseFontSize = _fontSizeForStyleSize(styleSize);
    final scale = info.style?.scale ?? 1.0;

    final drawable = TextDrawable(
      text: text,
      position: center,
      rotation: rotation,
      scale: scale,
      style: TextStyle(
        fontSize: baseFontSize,
        color: _annotationColor(info),
        fontWeight: FontWeight.w400,
      ),
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertRectangleAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style =
          (info.style?.isFilled == true) ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = RectangleDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertArrowAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    if (point == null || point.length < 2) return;

    final startOrigin = Offset(point[0], point[1]);
    final handles = info.handles;
    final startHandle = handles?["start"]?.point;
    final endHandle = handles?["end"]?.point;
    if (endHandle == null || endHandle.length < 2) return;

    final start = startOrigin +
        Offset(
          (startHandle != null && startHandle.length > 1) ? startHandle[0] : 0,
          (startHandle != null && startHandle.length > 1) ? startHandle[1] : 0,
        );
    final end = startOrigin + Offset(endHandle[0], endHandle[1]);
    final delta = end - start;
    if (delta.distance <= 0) return;

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final decorationEnd = info.decorations?["end"]?.toLowerCase();
    final isArrow = decorationEnd == "arrow";
    final drawable = isArrow
        ? ArrowDrawable(
            length: delta.distance,
            position: start + delta / 2,
            rotationAngle: delta.direction,
            paint: paint,
            hidden: false,
          )
        : LineDrawable(
            length: delta.distance,
            position: start + delta / 2,
            rotationAngle: delta.direction,
            paint: paint,
            hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertTriangleAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style =
          (info.style?.isFilled == true) ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = TriangleDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertEllipseAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style =
          (info.style?.isFilled == true) ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = OvalDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertRhombusAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style =
          (info.style?.isFilled == true) ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = RhombusDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertTrapezoidAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style =
          (info.style?.isFilled == true) ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = TrapezoidDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertHexagonAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style =
          (info.style?.isFilled == true) ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = HexagonDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertCloudAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style = (info.style?.isFilled == true)
          ? PaintingStyle.fill
          : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = CloudDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertStarAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style = (info.style?.isFilled == true)
          ? PaintingStyle.fill
          : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = StarDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
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

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  void _upsertXBoxAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = XBoxDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
    );

    _upsertObjectDrawableWithIds(annotation, info, drawable);
  }

  void _upsertCheckBoxAnnotationDrawable(Annotations annotation) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final drawable = CheckBoxDrawable(
      size: Size(width, height),
      position: center,
      rotationAngle: _rotationToRadians(info.rotation),
      paint: paint,
      hidden: false,
    );

    _upsertObjectDrawableWithIds(annotation, info, drawable);
  }

  void _upsertDirectionArrowAnnotationDrawable(
      Annotations annotation, String name) {
    final info = annotation.fields?.annotationInfo;
    if (info == null) return;

    final point = info.point;
    final sizeList = info.size;
    if (point == null || point.length < 2) return;
    if (sizeList == null || sizeList.length < 2) return;

    final topLeft = Offset(point[0], point[1]);
    final width = sizeList[0].abs();
    final height = sizeList[1].abs();
    final center = topLeft + Offset(width / 2, height / 2);

    final strokeWidth = _strokeWidthFromStyle(info.style);
    final paint = Paint()
      ..color = _annotationColor(info)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final length = (name == "arrowleft" || name == "arrowright") ? width : height;
    final rotation = name == "arrowleft"
        ? 3.141592653589793
        : name == "arrowup"
            ? -3.141592653589793 / 2
            : name == "arrowdown"
                ? 3.141592653589793 / 2
                : 0.0;

    final drawable = ArrowDrawable(
      length: length,
      position: center,
      rotationAngle: rotation,
      paint: paint,
      hidden: false,
    );

    _upsertObjectDrawableWithIds(annotation, info, drawable);
  }

  void _upsertObjectDrawableWithIds(
      Annotations annotation, AnnotationInfo info, ObjectDrawable drawable) {
    final ids = <String>{
      if (annotation.id != null) annotation.id!,
      if (annotation.fields?.id != null) annotation.fields!.id!,
      if (info.id != null) info.id!,
    };

    for (final id in ids) {
      _removeAnnotationDrawable(id);
      _annotationDrawablesById[id] = drawable;
    }

    final outerId = annotation.id;
    final innerId = info.id;
    if (outerId != null &&
        innerId != null &&
        outerId != innerId &&
        _localDrawablesById.containsKey(innerId)) {
      final localDrawable = _localDrawablesById.remove(innerId);
      if (localDrawable != null) _localDrawablesById[outerId] = localDrawable;
    }

    controller.addDrawables([drawable], newAction: true);
  }

  double _strokeWidthFromStyle(Style? style) {
    final normalized = _normalizeStyleSize(style?.size);
    final base = normalized == "s"
        ? 4.0
        : normalized == "l"
            ? 10.0
            : normalized == "xl"
                ? 14.0
                : 6.0;
    final scale = style?.scale ?? 1.0;
    return (base * scale).clamp(1.0, 60.0);
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

  void selectToolSelect() {
    controller.shapeFactory = null;
    controller.freeStyleMode = FreeStyleMode.none;
    controller.deselectObjectDrawable();
  }

  void selectToolHand() {
    controller.shapeFactory = null;
    controller.freeStyleMode = FreeStyleMode.none;
    controller.deselectObjectDrawable();
  }

  void selectToolPen() {
    controller.shapeFactory = null;
    controller.freeStyleMode = FreeStyleMode.draw;
    controller.deselectObjectDrawable();
  }

  void selectToolHighlighter() {
    controller.shapeFactory = null;
    controller.freeStyleMode = FreeStyleMode.draw;
    controller.freeStyleColor = const Color(0xFFFFD400);
    controller.freeStyleStrokeWidth = 20;
    controller.deselectObjectDrawable();
  }

  void selectToolEraser() {
    controller.shapeFactory = null;
    controller.freeStyleMode = FreeStyleMode.erase;
    controller.deselectObjectDrawable();
  }

  void selectToolShape(ShapeFactory? factory) {
    controller.deselectObjectDrawable();
    controller.freeStyleMode = FreeStyleMode.none;
    controller.shapeFactory = factory;
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
