import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Texttospeech extends GetxController{
  final _speechToText = SpeechToText().obs;
  set speechToText (value) => _speechToText.value = value;
  SpeechToText get speechToText => _speechToText.value;

  var _locales = <LocaleName>[].obs;
  set locales (value) => _locales.value = value;
  List<LocaleName> get locales => _locales.value;

  final _selectedLocale = LocaleName("","").obs;
  set selectedLocale (value) => _selectedLocale.value = value;
  LocaleName get selectedLocale => _selectedLocale.value;

  var _speechEnabled = false.obs;
  set speechEnabled (value) => _speechEnabled.value = value;
  get speechEnabled => _speechEnabled.value;

  final _lastWords = ''.obs;
  set lastWords (value) => _lastWords.value = value;
  get lastWords => _lastWords.value;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  void initSpeech() async {
    print("Initializing speech-to-text");
    speechEnabled = await speechToText.initialize(
      onError: (error) => print("Speech recognition error: $error"),
    );
    if (speechEnabled) {
      locales = await speechToText.locales();
      selectedLocale = locales[0];
    }
  }

  void startListening() async {
    if (!speechEnabled) return;
    print("Starting speech recognition");
    await speechToText.listen(
      onResult: _onSpeechResult,
      localeId: selectedLocale.localeId,
    );
  }

  void stopListening() async {
    print("Stopping speech recognition");
    await speechToText.stop();
  }

  void toggleSpeechRecognition(bool isInCall) {
    if (isInCall) {
      stopListening();
    } else {
      startListening();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    print("Recognized words: $lastWords");
  }

}