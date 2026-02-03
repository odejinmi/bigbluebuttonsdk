import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:get/get.dart';

class DeviceSettingsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();
  @override
  void onInit() {
    // Initialize TabController

    getAvailableCameras();
    getAvailableMicrophones();
    getAvailableSpeakers();
    super.onInit();
  }

  var _thirdItemsDropdown = <MediaDeviceInfo>[].obs;
  set thirdItemsDropdown(value) => _thirdItemsDropdown.value = value;
  List<MediaDeviceInfo> get thirdItemsDropdown => _thirdItemsDropdown.value;

  final _thirdDropdownValue = MediaDeviceInfo(
    label: 'Default - Phone mic',
    deviceId: '',
  ).obs;
  set thirdDropdownValue(value) => _thirdDropdownValue.value = value;
  get thirdDropdownValue => _thirdDropdownValue.value;

  var _forthItemsDropdown = <MediaDeviceInfo>[].obs;
  set forthItemsDropdown(value) => _forthItemsDropdown.value = value;
  List<MediaDeviceInfo> get forthItemsDropdown => _forthItemsDropdown.value;

  final _forthDropdownValue = MediaDeviceInfo(
    label: 'Default - Phone mic',
    deviceId: '',
  ).obs;
  set forthDropdownValue(value) => _forthDropdownValue.value = value;
  get forthDropdownValue => _forthDropdownValue.value;

  final _firstItemsDropdown = <MediaDeviceInfo>[].obs;
  set firstItemsDropdown(value) => _firstItemsDropdown.value = value;
  List<MediaDeviceInfo> get firstItemsDropdown => _firstItemsDropdown.value;

  final _secondItemsDropdown = <String>[
    'High Definition',
    'Medium Definition',
    'Low Definition',
  ].obs;
  set secondItemsDropdown(value) => _secondItemsDropdown.value = value;
  List<String> get secondItemsDropdown => _secondItemsDropdown.value;

  final _firstDropdownValue = MediaDeviceInfo(
    label: 'HD Camera',
    deviceId: '',
  ).obs;
  set firstDropdownValue(value) => _firstDropdownValue.value = value;
  get firstDropdownValue => _firstDropdownValue.value;

  final _secondDropdownValue = 'High Definition'.obs;
  set secondDropdownValue(value) => _secondDropdownValue.value = value;
  get secondDropdownValue => _secondDropdownValue.value;

  void getAvailableCameras() async {
    firstItemsDropdown = await bigbluebuttonsdkPlugin.getAvailableCameras();

    // for (var device in videoDevices) {
    //   firstItemsDropdown.add(device.label);
    //   print('Camera: ${device.label} (${device.deviceId})');
    // }

    // if(bigbluebuttonsdkPlugin.getAvailableMicrophones.isEmpty) return;
    firstDropdownValue = firstItemsDropdown.first;
  }

  void getAvailableMicrophones() async {
    thirdItemsDropdown = await bigbluebuttonsdkPlugin.getAvailableMicrophones();

    // for (var device in audioDevices) {
    //   thirdItemsDropdown.add(device.label);
    //   print('Microphone: ${device.label} (${device.deviceId})');
    // }
    // if(bigbluebuttonsdkPlugin.getAvailableMicrophones.isEmpty) return;
    thirdDropdownValue = thirdItemsDropdown.first;
  }

  void getAvailableSpeakers() async {
    forthItemsDropdown = await bigbluebuttonsdkPlugin.getAvailableMicrophones();

    // for (var device in audioDevices) {
    //   forthItemsDropdown.add(device.label);
    //   print('Microphone: ${device.label} (${device.deviceId})');
    // }
    // if(bigbluebuttonsdkPlugin.getAvailableMicrophones.isEmpty) return;
    forthDropdownValue = forthItemsDropdown.first;
  }
}
