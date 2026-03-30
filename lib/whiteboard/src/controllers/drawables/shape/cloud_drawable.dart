import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../object_drawable.dart';
import '../sized2ddrawable.dart';
import 'shape_drawable.dart';

class CloudDrawable extends Sized2DDrawable implements ShapeDrawable {
  @override
  Paint paint;

  CloudDrawable({
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

    final w = rect.width;
    final h = rect.height;
    if (w <= 0 || h <= 0) return;

    final left = rect.left;
    final right = rect.right;
    final top = rect.top;
    final bottom = rect.bottom;
    final midY = rect.center.dy;

    final r1 = mathMin(w, h) * 0.18;
    final r2 = mathMin(w, h) * 0.22;
    final r3 = mathMin(w, h) * 0.20;

    final path = Path();
    path.addOval(Rect.fromCircle(center: Offset(left + w * 0.28, midY), radius: r2));
    path.addOval(Rect.fromCircle(center: Offset(left + w * 0.46, top + h * 0.36), radius: r3));
    path.addOval(Rect.fromCircle(center: Offset(left + w * 0.62, midY), radius: r2));
    path.addOval(Rect.fromCircle(center: Offset(left + w * 0.76, top + h * 0.46), radius: r1));
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left + w * 0.20, midY, right - w * 0.12, bottom - h * 0.12),
        Radius.circular(h * 0.20),
      ),
    );

    canvas.drawPath(path, paint);
  }

  double mathMin(double a, double b) => a < b ? a : b;

  @override
  CloudDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    Size? size,
    Paint? paint,
    bool? locked,
  }) {
    return CloudDrawable(
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
