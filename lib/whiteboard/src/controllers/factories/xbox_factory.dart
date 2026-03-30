import 'dart:ui';

import '../drawables/shape/xbox_drawable.dart';
import 'shape_factory.dart';

class XBoxFactory extends ShapeFactory<XBoxDrawable> {
  XBoxFactory() : super();

  @override
  XBoxDrawable create(Offset position, [Paint? paint]) {
    return XBoxDrawable(size: Size.zero, position: position, paint: paint);
  }
}
