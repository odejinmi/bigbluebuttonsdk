import 'dart:ui';

import '../drawables/shape/star_drawable.dart';
import 'shape_factory.dart';

class StarFactory extends ShapeFactory<StarDrawable> {
  StarFactory() : super();

  @override
  StarDrawable create(Offset position, [Paint? paint]) {
    return StarDrawable(size: Size.zero, position: position, paint: paint);
  }
}
