import 'package:get/get.dart';

class SwitchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _switchValueJoined = false.obs;
  set switchValueJoined(value) => _switchValueJoined.value = value;
  get switchValueJoined => _switchValueJoined.value;

  final _switchValueLeave = false.obs;
  set switchValueLeave(value) => _switchValueLeave.value = value;
  get switchValueLeave => _switchValueLeave.value;

  final _switchValueNewMessage = false.obs;
  set switchValueNewMessage(value) => _switchValueNewMessage.value = value;
  get switchValueNewMessage => _switchValueNewMessage.value;

  final _isHandRaisedSwitchOn = false.obs;
  set isHandRaisedSwitchOn(value) => _isHandRaisedSwitchOn.value = value;
  get isHandRaisedSwitchOn => _isHandRaisedSwitchOn.value;

  final _switchValueError = false.obs;
  set switchValueError(value) => _switchValueError.value = value;
  get switchValueError => _switchValueError.value;

  final _switchValueActiveSpeaker = false.obs;
  set switchValueActiveSpeaker(value) =>
      _switchValueActiveSpeaker.value = value;
  get switchValueActiveSpeaker => _switchValueActiveSpeaker.value;

  final _switchValueAudioOnly = false.obs;
  set switchValueAudioOnly(value) => _switchValueAudioOnly.value = value;
  get switchValueAudioOnly => _switchValueAudioOnly.value;

  final _switchValueMuteAllUsers = false.obs;
  set switchValueMuteAllUsers(value) => _switchValueMuteAllUsers.value = value;
  get switchValueMuteAllUsers => _switchValueMuteAllUsers.value;

  final _switchValueMuteExceptPresenter = false.obs;
  set switchValueMuteExceptPresenter(value) =>
      _switchValueMuteExceptPresenter.value = value;
  get switchValueMuteExceptPresenter => _switchValueMuteExceptPresenter.value;

  final _switchValueLockViewers = false.obs;
  set switchValueLockViewers(value) => _switchValueLockViewers.value = value;
  get switchValueLockViewers => _switchValueLockViewers.value;

  final _switchValuehideparticipantslist = false.obs;
  set switchValuehideparticipantslist(value) =>
      _switchValuehideparticipantslist.value = value;
  get switchValuehideparticipantslist => _switchValuehideparticipantslist.value;

  final _switchValuediasblecamera = false.obs;
  set switchValuediasblecamera(value) =>
      _switchValuediasblecamera.value = value;
  get switchValuediasblecamera => _switchValuediasblecamera.value;

  final _switchValuediasablepublicchat = false.obs;
  set switchValuediasablepublicchat(value) =>
      _switchValuediasablepublicchat.value = value;
  get switchValuediasablepublicchat => _switchValuediasablepublicchat.value;

  final _switchValuedisableprivatechat = false.obs;
  set switchValuedisableprivatechat(value) =>
      _switchValuedisableprivatechat.value = value;
  get switchValuedisableprivatechat => _switchValuedisableprivatechat.value;

  final _selectedRadioValue = 1.obs;
  set selectedRadioValue(value) => _selectedRadioValue.value = value;
  get selectedRadioValue => _selectedRadioValue.value;
}
