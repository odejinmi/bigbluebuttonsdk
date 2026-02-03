import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class PresentationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();

  var _slideposition = 1.obs; // Initial zoom level (100%)
  set slideposition(value) => _slideposition.value = value;
  get slideposition => _slideposition.value;

  var _selecttoupload = PlatformFile(
    name: '',
    size: 0,
  ).obs; // Initial zoom level (100%)
  set selecttoupload(value) => _selecttoupload.value = value;
  get selecttoupload => _selecttoupload.value;

  var _toupload = <PlatformFile>[].obs; // Initial zoom level (100%)
  set toupload(value) => _toupload.value = value;
  get toupload => _toupload.value;
}
