import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../object_drawable.dart';
import '../sized2ddrawable.dart';
import 'shape_drawable.dart';

class HexagonDrawable extends Sized2DDrawable implements ShapeDrawable {
  @override
  Paint paint;

  HexagonDrawable({
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

    final inset = drawingSize.width * 0.25;
    final leftInsetX = position.dx - halfW + inset;
    final rightInsetX = position.dx + halfW - inset;
    final leftX = position.dx - halfW;
    final rightX = position.dx + halfW;
    final topY = position.dy - halfH;
    final bottomY = position.dy + halfH;
    final midTopY = position.dy - halfH / 2;
    final midBottomY = position.dy + halfH / 2;

    final path = Path()
      ..moveTo(leftInsetX, topY)
      ..lineTo(rightInsetX, topY)
      ..lineTo(rightX, midTopY)
      ..lineTo(rightInsetX, bottomY)
      ..lineTo(leftInsetX, bottomY)
      ..lineTo(leftX, midBottomY)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  HexagonDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    Size? size,
    Paint? paint,
    bool? locked,
  }) {
    return HexagonDrawable(
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
