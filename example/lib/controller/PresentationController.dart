import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class PresentationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();

  final _slideposition = 1.obs; // Initial zoom level (100%)
  set slideposition(value) => _slideposition.value = value;
  int get slideposition => _slideposition.value;

  final _selecttoupload = PlatformFile(
    name: '',
    size: 0,
  ).obs; // Initial zoom level (100%)
  set selecttoupload(value) => _selecttoupload.value = value;
  PlatformFile get selecttoupload => _selecttoupload.value;

  final _toupload = <PlatformFile>[].obs; // Initial zoom level (100%)
  set toupload(value) => _toupload.value = value;
  List<PlatformFile> get toupload => _toupload.value;
}
