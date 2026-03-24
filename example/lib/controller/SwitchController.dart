import 'package:get/get.dart';

class SwitchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _switchValueJoined = false.obs;
  set switchValueJoined(value) => _switchValueJoined.value = value;
  bool get switchValueJoined => _switchValueJoined.value;

  final _switchValueLeave = false.obs;
  set switchValueLeave(value) => _switchValueLeave.value = value;
  bool get switchValueLeave => _switchValueLeave.value;

  final _switchValueNewMessage = false.obs;
  set switchValueNewMessage(value) => _switchValueNewMessage.value = value;
  bool get switchValueNewMessage => _switchValueNewMessage.value;

  final _isHandRaisedSwitchOn = false.obs;
  set isHandRaisedSwitchOn(value) => _isHandRaisedSwitchOn.value = value;
  bool get isHandRaisedSwitchOn => _isHandRaisedSwitchOn.value;

  final _switchValueError = false.obs;
  set switchValueError(value) => _switchValueError.value = value;
  bool get switchValueError => _switchValueError.value;

  final _switchValueActiveSpeaker = false.obs;
  set switchValueActiveSpeaker(value) =>
      _switchValueActiveSpeaker.value = value;
  bool get switchValueActiveSpeaker => _switchValueActiveSpeaker.value;

  final _switchValueAudioOnly = false.obs;
  set switchValueAudioOnly(value) => _switchValueAudioOnly.value = value;
  bool get switchValueAudioOnly => _switchValueAudioOnly.value;

  final _switchValueMuteAllUsers = false.obs;
  set switchValueMuteAllUsers(value) => _switchValueMuteAllUsers.value = value;
  bool get switchValueMuteAllUsers => _switchValueMuteAllUsers.value;

  final _switchValueMuteExceptPresenter = false.obs;
  set switchValueMuteExceptPresenter(value) =>
      _switchValueMuteExceptPresenter.value = value;
  bool get switchValueMuteExceptPresenter => _switchValueMuteExceptPresenter.value;

  final _switchValueLockViewers = false.obs;
  set switchValueLockViewers(value) => _switchValueLockViewers.value = value;
  bool get switchValueLockViewers => _switchValueLockViewers.value;

  final _switchValuehideparticipantslist = false.obs;
  set switchValuehideparticipantslist(value) =>
      _switchValuehideparticipantslist.value = value;
  bool get switchValuehideparticipantslist => _switchValuehideparticipantslist.value;

  final _switchValuediasblecamera = false.obs;
  set switchValuediasblecamera(value) =>
      _switchValuediasblecamera.value = value;
  bool get switchValuediasblecamera => _switchValuediasblecamera.value;

  final _switchValuediasablepublicchat = false.obs;
  set switchValuediasablepublicchat(value) =>
      _switchValuediasablepublicchat.value = value;
  bool get switchValuediasablepublicchat => _switchValuediasablepublicchat.value;

  final _switchValuedisableprivatechat = false.obs;
  set switchValuedisableprivatechat(value) =>
      _switchValuedisableprivatechat.value = value;
  bool get switchValuedisableprivatechat => _switchValuedisableprivatechat.value;

  final _selectedRadioValue = 1.obs;
  set selectedRadioValue(value) => _selectedRadioValue.value = value;
  int get selectedRadioValue => _selectedRadioValue.value;
}
