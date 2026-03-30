import 'dart:ui';

import '../drawables/shape/hexagon_drawable.dart';
import 'shape_factory.dart';

class HexagonFactory extends ShapeFactory<HexagonDrawable> {
  HexagonFactory() : super();

  @override
  HexagonDrawable create(Offset position, [Paint? paint]) {
    return HexagonDrawable(size: Size.zero, position: position, paint: paint);
  }
}
