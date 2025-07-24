import 'package:get/get.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../utils/meetingdetails.dart';

class Texttospeech extends GetxController{
  // final _speechToText = SpeechToText().obs;
  // set speechToText (value) => _speechToText.value = value;
  // SpeechToText get speechToText => _speechToText.value;
  //
  // var _locales = <LocaleName>[].obs;
  // set locales (value) => _locales.value = value;
  // List<LocaleName> get locales => _locales.value;
  //
  // final _selectedLocale = LocaleName("","").obs;
  // set selectedLocale (value) => _selectedLocale.value = value;
  // LocaleName get selectedLocale => _selectedLocale.value;

  var _speechEnabled = false.obs;
  set speechEnabled (value) => _speechEnabled.value = value;
  get speechEnabled => _speechEnabled.value;

  final _lastWords = ''.obs;
  set lastWords (value) => _lastWords.value = value;
  get lastWords => _lastWords.value;

  var _socket = Rx<Socket?>(null);
  set socket(value) => _socket.value = value;
  Socket? get socket => _socket.value;

  var _meetingdetails =  Rx<Meetingdetails?>(null);
  set meetingdetails(value) => _meetingdetails.value = value;
  get meetingdetails => _meetingdetails.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

 void start({required Meetingdetails meetingdetails}){
   print('text to speech connecting');
    this.meetingdetails = meetingdetails;
   // Dart client
   socket = io('https://k4caption.konn3ct.ng');
   socket!.onConnect((_) {
     print('connect');
     startListening();
     // socket?.emit('msg', 'test');
     socket?.emit("join_room", meetingdetails.meetingId);
   });
   socket?.on('event', (data) => print(data));
   socket?.on("receive_captions", (arg)=> print(arg));
   socket?.onDisconnect((_) => print('disconnect'));
   socket?.onConnectError((handler){print("sockect io connection error");print(handler);});
   socket?.on('fromServer', (_) => print(_));
 }


  void sendmessage({required String message}){
    socket?.emit("send_captions", {
      "text": message,
      "user": meetingdetails?.fullname,
      "meetingID": meetingdetails?.meetingID,
      "date": DateTime.now().toIso8601String()
    });
  }

  void initSpeech() async {
    print("Initializing speech-to-text");
    // speechEnabled = await speechToText.initialize(
    //   onError: (error) => print("Speech recognition error: $error"),
    // );
    // if (speechEnabled) {
    //   locales = await speechToText.locales();
    //   selectedLocale = locales[0];
    // }
  }

  void startListening() async {
    if (!speechEnabled) return;
    print("Starting speech recognition");
    // await speechToText.listen(
    //   onResult: _onSpeechResult,
    //   localeId: selectedLocale.localeId,
    // );
  }

  void stopListening() async {
    // print("Stopping speech recognition");
    // await speechToText.stop();
  }


  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   lastWords = result.recognizedWords;
  //   print("Recognized words: $lastWords");
  // }

}