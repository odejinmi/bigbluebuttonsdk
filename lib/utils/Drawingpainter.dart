import 'package:flutter/material.dart';

import '../view/annotations.dart';
import 'Drawnpath.dart';


class DrawingPainter extends CustomPainter {
  final List<Annotations> paths;
  final List<List<double>> currentPathPoints;
  final Color color;
  final double strokeWidth;
  final String mode;
  final List<DrawAction>? actions;

  DrawingPainter({required this.paths, required this.currentPathPoints, required this.color, required this.strokeWidth, required this.mode, this.actions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw saved paths
    for (var path in paths) {

      double scaleX = size.width / path.fields!.annotationInfo!.size![0];
      double scaleY = size.height / path.fields!.annotationInfo!.size![1];

      double offsetX = path.fields!.annotationInfo!.point![0];
      double offsetY = path.fields!.annotationInfo!.point![1];

      List<List<double>>? adjustedPoints = path.fields!.annotationInfo!.points?.map((point) {
        return [
          (point[0] - offsetX) * scaleX,
          (point[1] - offsetY) * scaleY,
          // (offsetX - point[0])* scaleX,
          // (offsetY - point[1]) * scaleY,
        ];
      }).toList();
      // paint.color = path.fields?.annotationInfo?.type == "delete" ? Colors.transparent : path.color;
      paint.color = path.fields?.annotationInfo?.type == "delete" ? Colors.transparent : Colors.black;
      paint.strokeWidth =  path.fields!.annotationInfo!.style!.scale!.toDouble();

      if (path.fields?.annotationInfo?.type == "draw") {
        _drawLine(canvas, adjustedPoints!, paint);
      } else if (path.fields?.annotationInfo?.type == "triangle") {
// Define the vertices of the triangle
        final path = Path()
          ..moveTo(offsetX, offsetY) // Top vertex
          ..lineTo(offsetX + size.width / 2, offsetY + size.height) // Bottom right vertex
          ..lineTo(offsetX - size.width / 2, offsetY + size.height) // Bottom left vertex
          ..close();

        // Draw the triangle
        canvas.drawPath(path, paint);
        _drawPolygon(canvas, adjustedPoints!, paint);
      } else if (path.fields?.annotationInfo?.type == "rectangle") {
        canvas.drawRect(
          Rect.fromLTWH(path.fields!.annotationInfo!.point![0], path.fields!.annotationInfo!.point![1], path.fields!.annotationInfo!.size![0], path.fields!.annotationInfo!.size![0]),
          paint,
        );
      } else if (path.fields?.annotationInfo?.type == "ellipse") {
        final radiusX = path.fields!.annotationInfo!.radius![0];
        final radiusY = path.fields!.annotationInfo!.radius![1];
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(offsetX, offsetY),
            width: radiusX * 2,
            height: radiusY * 2,
          ),
          paint,
        );
        // _drawOval(canvas, adjustedPoints!, paint);
      } else if (path.fields?.annotationInfo?.type == "text" && actions != null) {
        for (var action in actions!) {
          if (action.text != null) {
            print("typing text here");
            final textPainter = TextPainter(
              text: TextSpan(text: action.text, style: TextStyle(color: Colors.black, fontSize: 16)),
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout();
            textPainter.paint(canvas, action.start);
          }
        }
      }
    }

    // Draw live preview of current shape
    paint.color = color;
    paint.strokeWidth = strokeWidth;
    if (mode == "draw") {
      _drawLine(canvas, currentPathPoints, paint);
    } else if (mode == "triangle" || mode == "rectangle" || mode == "ellipse") {
      if (currentPathPoints.length == 2) {
        // Draw preview shape
        if (mode == "triangle" || mode == "rectangle") {
          _drawPolygon(canvas, _getShapePoints(currentPathPoints), paint);
        } else if (mode == "ellipse") {
          _drawOval(canvas, currentPathPoints, paint);
        }
      }
    }
  }

  void _drawLine(Canvas canvas, List<List<double>> points, Paint paint) {
    if (points.isNotEmpty) {
      final path = Path()..moveTo(points[0][0], points[0][1]);
      for (var point in points.skip(1)) {
        path.lineTo(point[0], point[1]);
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawPolygon(Canvas canvas, List<List<double>> points, Paint paint) {
    if (points.length >= 3) {
      final path = Path()..moveTo(points[0][0], points[0][1]);
      for (var point in points.skip(1)) {
        path.lineTo(point[0], point[1]);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void _drawOval(Canvas canvas, List<List<double>> points, Paint paint) {
    if (points.length == 2) {
      final rect = Rect.fromPoints(Offset(points[0][0],points[0][1]), Offset(points[1][0],points[1][0]));
      canvas.drawOval(rect, paint);
    }
  }

  List<List<double>> _getShapePoints(List<List<double>> currentPoints) {
    if (currentPoints.length != 2) return [];
    final start = Offset(currentPoints[0][0],currentPoints[0][1]);
    final end = Offset(currentPoints[1][0],currentPoints[1][1]);

    if (mode == "triangle") {
      return [
        [start.dx,start.dx],
        [(start.dx + end.dx) / 2, start.dy],
        [end.dx, end.dy]
        // Offset(start.dx, end.dy),
        // Offset((start.dx + end.dx) / 2, start.dy),
        // Offset(end.dx, end.dy),
      ];
    } else if (mode == "rectangle") {
      // return [start, Offset(end.dx, start.dy), end, Offset(start.dx, end.dy)];
      return [[start.dx,start.dy], [end.dx, start.dy], [end.dx,end.dy], [start.dx, end.dy]];
    }
    return [];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

