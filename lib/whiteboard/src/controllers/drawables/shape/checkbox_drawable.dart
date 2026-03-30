import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../object_drawable.dart';
import '../sized2ddrawable.dart';
import 'shape_drawable.dart';

class CheckBoxDrawable extends Sized2DDrawable implements ShapeDrawable {
  @override
  Paint paint;

  CheckBoxDrawable({
    Paint? paint,
    required super.size,
    required super.position,
    super.rotationAngle,
    super.scale,
    super.assists,
    super.assistPaints,
    super.locked,
    super.hidden,
  }) : paint = paint ?? ShapeDrawable.defaultPaint;

  @protected
  @override
  EdgeInsets get padding => EdgeInsets.all(paint.strokeWidth / 2);

  @override
  void drawObject(Canvas canvas, Size size) {
    final drawingSize = this.size * scale;
    final rect = Rect.fromCenter(
      center: position,
      width: drawingSize.width,
      height: drawingSize.height,
    );
    if (rect.width <= 0 || rect.height <= 0) return;

    canvas.drawRect(rect, paint);

    final markPaint = Paint()
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final inset = math.min(rect.width, rect.height) * 0.2;
    final p1 = Offset(rect.left + inset, rect.center.dy);
    final p2 = Offset(rect.left + rect.width * 0.42, rect.bottom - inset);
    final p3 = Offset(rect.right - inset, rect.top + inset);

    canvas.drawLine(p1, p2, markPaint);
    canvas.drawLine(p2, p3, markPaint);
  }

  @override
  CheckBoxDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    Size? size,
    Paint? paint,
    bool? locked,
  }) {
    return CheckBoxDrawable(
      hidden: hidden ?? this.hidden,
      assists: assists ?? this.assists,
      position: position ?? this.position,
      rotationAngle: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      paint: paint ?? this.paint,
      locked: locked ?? this.locked,
    );
  }

  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    final size = super.getSize();
    return Size(size.width, size.height);
  }
}
