import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'bigbluebuttonsdk.dart';

import 'bigbluebuttonsdk_method_channel.dart';
import 'utils/chatmodel.dart';
import 'utils/meetingdetails.dart';
import 'utils/participant.dart';

abstract class BigbluebuttonsdkPlatform extends PlatformInterface {
  /// Constructs a BigbluebuttonsdkPlatform.
  BigbluebuttonsdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static BigbluebuttonsdkPlatform _instance = MethodChannelBigbluebuttonsdk();

  /// The default instance of [BigbluebuttonsdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelBigbluebuttonsdk].
  static BigbluebuttonsdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BigbluebuttonsdkPlatform] when
  /// they register themselves.
  static set instance(BigbluebuttonsdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Startroom() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  initialize({required String baseurl,required String webrtctoken, required Meetingdetails meetingdetails}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  typing({required String chatid,}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  removepresentation({required String presentationid}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  nextpresentation({required String page}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  whiteboard() {
    throw UnimplementedError('whiteboard() has not been implemented.');
  }

  sendmessage({required String message,required String chatid}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  sendecinema({required String videourl}){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  endecinema(){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  makepresentationdefault({required var presentation}){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  startpoll({required String question, required List options}){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  votepoll({required String poll_id, required String selectedOptionId}){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  muteallusers({required String userid,}){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  createGroupChat({required Participant participant,}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  uploadpresenter({required PlatformFile filename,}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  setemojistatus() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  mutemyself() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  starvirtual({required Uint8List backgroundimage}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  startcaption(){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  stopcaption(){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  stopcamera() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  startcamera() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  stopscreenshare() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  startscreenshare() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  changerole({required String userid, required String role}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  switchVideoQuality({required int width, /*int height,*/ required int frameRate}) {
    throw UnimplementedError('switchVideoQuality() has not been implemented.');
  }

  switchcamera({required String deviceid}) {
    throw UnimplementedError('switchcamera() has not been implemented.');
  }

  switchmicrophone({required String deviceid}) {
    throw UnimplementedError('switchmicrophone() has not been implemented.');
  }

  assignpresenter({required String userid}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  leaveroom() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  removeuser({required String userid,required bool notallowagain}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  List<ChatMessage> getchatMessages({required String chatid,}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  toggleRecording() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  breakeoutroom() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  stoptyping(){
    throw UnimplementedError('initialize() has not been implemented.');
  }

  get participant{
    throw UnimplementedError('initialize() has not been implemented.');
  }

  get mydetails{
    throw UnimplementedError('initialize() has not been implemented.');
  }

  get isWebsocketRunning{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get polljson{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get ispolling{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  set ispolling (value){
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get isrecording{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get pollanalyseparser{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get isscreensharing{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get talking{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get isvideo{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get chatMessages{
    throw UnimplementedError('initialize() has not been implemented.');
  }
  get presentationmodel{
    throw UnimplementedError('initialize() has not been implemented.');
  }

  get ishowecinema{
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<List<MediaDeviceInfo>>  getAvailableCameras (){
    throw UnimplementedError('getAvailableCameras() has not been implemented.');
  }

  Future<List<MediaDeviceInfo>>  getAvailableMicrophones (){
    throw UnimplementedError('getAvailableMicrophones() has not been implemented.');
  }

  Stream<String> get stream{
    throw UnimplementedError('initialize() has not been implemented.');
  }
}
