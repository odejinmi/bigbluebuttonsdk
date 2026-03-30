import 'dart:ui';

import '../drawables/shape/rhombus_drawable.dart';
import 'shape_factory.dart';

class RhombusFactory extends ShapeFactory<RhombusDrawable> {
  RhombusFactory() : super();

  @override
  RhombusDrawable create(Offset position, [Paint? paint]) {
    return RhombusDrawable(size: Size.zero, position: position, paint: paint);
  }
}
