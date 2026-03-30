import 'dart:ui';

import '../drawables/shape/triangle_drawable.dart';
import 'shape_factory.dart';

class TriangleFactory extends ShapeFactory<TriangleDrawable> {
  TriangleFactory() : super();

  @override
  TriangleDrawable create(Offset position, [Paint? paint]) {
    return TriangleDrawable(size: Size.zero, position: position, paint: paint);
  }
}
