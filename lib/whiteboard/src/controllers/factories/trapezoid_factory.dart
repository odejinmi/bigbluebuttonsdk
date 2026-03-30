import 'dart:ui';

import '../drawables/shape/trapezoid_drawable.dart';
import 'shape_factory.dart';

class TrapezoidFactory extends ShapeFactory<TrapezoidDrawable> {
  TrapezoidFactory() : super();

  @override
  TrapezoidDrawable create(Offset position, [Paint? paint]) {
    return TrapezoidDrawable(size: Size.zero, position: position, paint: paint);
  }
}
