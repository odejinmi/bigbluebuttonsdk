import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../object_drawable.dart';
import '../sized2ddrawable.dart';
import 'shape_drawable.dart';

class RhombusDrawable extends Sized2DDrawable implements ShapeDrawable {
  @override
  Paint paint;

  RhombusDrawable({
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
    final halfW = drawingSize.width / 2;
    final halfH = drawingSize.height / 2;

    final top = Offset(position.dx, position.dy - halfH);
    final right = Offset(position.dx + halfW, position.dy);
    final bottom = Offset(position.dx, position.dy + halfH);
    final left = Offset(position.dx - halfW, position.dy);

    final path = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  RhombusDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    Size? size,
    Paint? paint,
    bool? locked,
  }) {
    return RhombusDrawable(
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
