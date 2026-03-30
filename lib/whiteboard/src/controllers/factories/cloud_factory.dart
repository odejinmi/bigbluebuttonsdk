import 'dart:ui';

import '../drawables/shape/cloud_drawable.dart';
import 'shape_factory.dart';

class CloudFactory extends ShapeFactory<CloudDrawable> {
  CloudFactory() : super();

  @override
  CloudDrawable create(Offset position, [Paint? paint]) {
    return CloudDrawable(size: Size.zero, position: position, paint: paint);
  }
}
