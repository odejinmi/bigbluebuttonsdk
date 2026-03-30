import 'dart:ui';

import '../drawables/shape/checkbox_drawable.dart';
import 'shape_factory.dart';

class CheckBoxFactory extends ShapeFactory<CheckBoxDrawable> {
  CheckBoxFactory() : super();

  @override
  CheckBoxDrawable create(Offset position, [Paint? paint]) {
    return CheckBoxDrawable(size: Size.zero, position: position, paint: paint);
  }
}
