import 'dart:convert';
import 'dart:ui';


class DrawAction {
  final String mode;
  final Offset start;
  final Offset? end;
  final String? text;

  DrawAction.line(this.start, this.end)
      : mode = "draw",
        text = null;

  DrawAction.text(this.text, this.start)
      : mode = "text",
        end = null;
}


class DrawnPath1 {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final String mode;
  final String? id;

  DrawnPath1({required this.points, required this.color, required this.strokeWidth, required this.mode, this.id});

  Map<String, dynamic> toJson() => {
    'points': points.map((point) => [point.dx, point.dy]).toList(),
    'color': color.value.toRadixString(16),
    'strokeWidth': strokeWidth,
    'mode': mode.toString(),
    'id': id,
  };

  static DrawnPath1 fromJson(Map<String, dynamic> json) {
    return DrawnPath1(
      points: (json['points'] as List)
          .map((point) => Offset(point[0].toDouble(), point[1].toDouble()))
          .toList(),
      color: Color(int.parse(json['color'], radix: 16)),
      strokeWidth: json['strokeWidth'],
      mode: json['mode'],
      id: json['id'],
    );
  }
}
