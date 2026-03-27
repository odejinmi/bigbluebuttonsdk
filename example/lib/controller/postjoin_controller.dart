import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bigbluebuttonsdk/bigbluebuttonsdk.dart';
import 'package:bigbluebuttonsdk/utils/diorequest.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/dialogs/cinema.dart';
import '../screens/modal/pollsresult.dart';
import '../screens/modal/pullquestionandanswer.dart';
import 'ChatController.dart';
import 'DeviceSettingsController.dart';
import 'PresentationController.dart';
import 'PullController.dart';
import 'SwitchController.dart';
/// GetX Template Generator - fb.com/htngu.99
///

class postjoinController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  String get obj => _obj.value;

  final _baseurl = ''.obs;
  set baseurl(value) => _baseurl.value = value;
  String get baseurl => _baseurl.value;

  final _amounttodonate = ''.obs;
  set amounttodonate(value) => _amounttodonate.value = value;
  String get amounttodonate => _amounttodonate.value;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  // final HomeController controller = Get.put(HomeController(usersList: usersList));
  // final SwitchController switchcontroller = Get.put(SwitchController());

  final _captionButtonPressed =
      false.obs; // variable to track caption button visibility
  set captionButtonPressed(value) => _captionButtonPressed.value = value;
  bool get captionButtonPressed => _captionButtonPressed.value;

  final _hasUnsavedChanges = true.obs; // variable to track card visibility
  set hasUnsavedChanges(value) => _hasUnsavedChanges.value = value;
  bool get hasUnsavedChanges => _hasUnsavedChanges.value;

  final _arguments = {}.obs;
  set arguments(value) => _arguments.value = value;
  Map<dynamic, dynamic> get arguments => _arguments.value;

  final _donate = false.obs;
  set donate(value) => _donate.value = value;
  bool get donate => _donate.value;

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  bool get isLoading => _isLoading.value;

  final _check = false.obs;
  set check(value) => _check.value = value;
  bool get check => _check.value;

  final _isleaving = "".obs;
  set isleaving(value) => _isleaving.value = value;
  String get isleaving => _isleaving.value;

  final _iscamera = false.obs;
  set iscamera(value) => _iscamera.value = value;
  bool get iscamera => _iscamera.value;

  final _isshareaudio = false.obs;
  set isshareaudio(value) => _isshareaudio.value = value;
  bool get isshareaudio => _isshareaudio.value;

  final bigbluebuttonsdkPlugin = Bigbluebuttonsdk();

  final _meetingdetails = Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  Meetingdetails? get meetingdetails => _meetingdetails.value;

  final _roomdetails = {}.obs;
  set roomdetails(value) => _roomdetails.value = value;
  Map<dynamic, dynamic> get roomdetails => _roomdetails.value;

  final _donationdetails = [].obs;
  set donationdetails(value) => _donationdetails.value = value;
  List<dynamic> get donationdetails => _donationdetails.value;

  final _webrtctoken = "".obs;
  set webrtctoken(value) => _webrtctoken.value = value;
  String get webrtctoken => _webrtctoken.value;


  var chatcontroller = Get.put(ChatController());
  var deviceSettingscontroller = Get.put(DeviceSettingsController());
  var presentationcontroller = Get.put(PresentationController());
  var pullcontroller = Get.put(PullController());
  var switchcontroller = Get.put(SwitchController());

  var formKey = GlobalKey<FormState>();
  Timer? _timer;

  final donationdescriptionController = TextEditingController();
  final donationuniquenumberController = TextEditingController();

  final _iswhiteboard = false.obs;
  set iswhiteboard(value) => _iswhiteboard.value = value;
  bool get iswhiteboard => _iswhiteboard.value;

  late TabController tabController;

  StreamSubscription? _subscription;

  final _muteAll = false.obs;
  set muteAll(value) => _muteAll.value = value;
  bool get muteAll => _muteAll.value;

  final _muteAllExceptPresenter = false.obs;
  set muteAllExceptPresenter(value) => _muteAllExceptPresenter.value = value;
  bool get muteAllExceptPresenter => _muteAllExceptPresenter.value;
  @override
  void onInit() {
    // Initialize TabController
    tabController = TabController(length: 2, vsync: this);
    _initPip();
    super.onInit();
  }

  void _initPip() async {
    if (GetPlatform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        enablePip(autoEnable: true);
      }
    }
  }

  final floating = Floating();

  Future<void> enablePip({bool autoEnable = false}) async {
    final rational = Rational.landscape();
    final screenSize = MediaQuery.of(Get.context!).size *
        MediaQuery.of(Get.context!).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final arguments = autoEnable
        ? OnLeavePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          )
        : ImmediatePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          );

    final status = await floating.enable(arguments);
    debugPrint('PiP enabled? $status');
  }

  void startroom() {
    bigbluebuttonsdkPlugin.initialize(
      baseurl: baseurl,
      webrtctoken: webrtctoken,
      meetingdetails: meetingdetails!,
    );
    bigbluebuttonsdkPlugin.Startroom(
        leavemeeting: (value) {
          if(isleaving.toString().isEmpty){
            isleaving = value;
          }
          // {msg: changed, collection: current-user, id: zpSwyR4fx29EfkvSv, fields: {loggedOut: true}}
          //     {msg: changed, collection: meetings, id: QBbf7iqSYXcSuz23B, fields: {meetingEnded: true, meetingEndedBy: w_tirr8ianrx6x, meetingEndedReason: ENDED_AFTER_USER_LOGGED_OUT}}


              // {"msg":"changed","collection":"meetings","id":"YxSfTK6XyPseW62Ti","fields":{"meetingEnded":true,"meetingEndedBy":"w_cqfbqdc3mmxi","meetingEndedReason":"ENDED_AFTER_USER_LOGGED_OUT"}}
          Get.back(result: isleaving);
        },
        externalvideomeetings: (value) {
          showDialog(
            barrierDismissible: false,
            context: Get.context!,
            builder: (BuildContext context) => ShowVideoScreen(
              videoLink: value,
              ishowecinema: bigbluebuttonsdkPlugin.ishowecinema,
            ),
          );
        },
        polls: (value) {
          if (Get.isBottomSheetOpen == true) {
              Get.back();
            }
            if (value["msg"] == "added") {
              pullcontroller.ispulling = true;
              pullcontroller.pullquestionandanswer = value;
              Get.bottomSheet(Pullquestionandanswer());
            } else if (value["msg"] == "removed"){
              pullcontroller.ispulling = false;
              pullcontroller.pullresult = {};
              if (Get.isBottomSheetOpen == true) {
                Get.back();
              }
            }
        },
        currentpoll: (value) {
          pullcontroller.pullresult = value;
          Get.bottomSheet(Pollsresult());
        },
        breakouts: (value){
          Get.dialog(
            Scaffold(
              // backgroundColor: const Color.fromRGBO(0, 0, 0, 0.76),
              body: Center(
                child: Container(
                  width: 360,
                  height: 664,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(62, 132, 102, 1),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'DURATIONS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.08,
                            letterSpacing: 0.10,
                          ),
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFF5D957E),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '14:39',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(
                                    0.9800000190734863,
                                  ),
                                  fontSize: 30,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0.02,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Room 1 (0)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'View',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Join room |  Join audio',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            // barrierLabel: ' Full Screen Dialog',
            transitionDuration: const Duration(milliseconds: 400),
          );
        }
    );
    // checkdonation();
    // Set up a timer to call checkdonation() every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // obj = "";
      // checkdonation();
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    _timer?.cancel();
    floating.cancelOnLeavePiP();
    // TODO: implement onClose
    super.onClose();
  }

  void checkdonation() async {
    var cmddetails = await Diorequest().get("k4/donation/${roomdetails['id']}");
    if (cmddetails["success"]) {
      if (cmddetails["data"].isNotEmpty) {
        donate = true;
        donationdetails = cmddetails["data"];
      } else {
        donate = false;
      }
      // Get.offNamed(
      // Routes.POSTJOIN, arguments: {"token": webtoken,"meetingdetails":cmddetails["response"]});
      // update();
    } else {
      // print("start the meeting again");
    }
  }
}
