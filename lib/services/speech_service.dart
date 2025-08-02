import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _speechEnabled = false;
  bool _isSpeaking = false;
  String _currentLocale = 'en-US'; // Default to English

  bool get isListening => _speechToText.isListening;
  bool get isSpeaking => _isSpeaking; // Public getter for _isSpeaking

  Future<bool> initialize() async {
    try {
      // Request microphone permission
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }

      _speechEnabled = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) => print('Speech recognition status: $status'),
      );

      if (_speechEnabled) {
        await _flutterTts.setLanguage(_currentLocale);
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setVolume(1.0);
        await _flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
        );
        // Set up TTS handlers
        _flutterTts.setStartHandler(() {
          _isSpeaking = true;
        });
        _flutterTts.setCompletionHandler(() {
          _isSpeaking = false;
        });
        _flutterTts.setErrorHandler((msg) {
          print('TTS error: $msg');
          _isSpeaking = false;
        });
      }

      return _speechEnabled;
    } catch (e) {
      print('Speech service initialization error: $e');
      return false;
    }
  }

  Future<void> setLanguage(String locale) async {
    if (!_speechEnabled) return;
    try {
      _currentLocale = locale;
      await _speechToText.stop();
      await _flutterTts.setLanguage(locale);
      // Verify language support
      bool isLanguageAvailable = await _flutterTts.isLanguageAvailable(locale);
      if (!isLanguageAvailable) {
        print('Language $locale not available for TTS');
      }
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_speechEnabled) {
      print('Speech recognition not initialized');
      return;
    }

    try {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
        localeId: _currentLocale, // Use current locale (e.g., hi-IN)
      );
    } catch (e) {
      print('Error starting speech recognition: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
    } catch (e) {
      print('Error stopping speech recognition: $e');
    }
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop(); // Stop any ongoing speech
      _isSpeaking = true;
      await _flutterTts.speak(text);
    } catch (e) {
      print('Text-to-speech error: $e');
      _isSpeaking = false;
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
    } catch (e) {
      print('Error stopping text-to-speech: $e');
      _isSpeaking = false;
    }
  }
}
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';

// class SpeechService {
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//   bool _isInitialized = false;
//   String _currentLocale = 'en-US'; // Default to English

//   Future<bool> initialize() async {
//     try {
//       if (await Permission.microphone.request().isGranted) {
//         _isInitialized = await _speech.initialize();
//         await _setTtsLanguage(_currentLocale);
//         return _isInitialized;
//       }
//       return false;
//     } catch (e) {
//       print('Speech initialization error: $e');
//       return false;
//     }
//   }

//   Future<void> setLanguage(String locale) async {
//     _currentLocale = locale;
//     if (_isInitialized) {
//       await _speech.stop();
//       await _setTtsLanguage(locale);
//     }
//   }

//   Future<void> _setTtsLanguage(String locale) async {
//     await _tts.setLanguage(locale);
//     await _tts.setSpeechRate(0.5);
//     await _tts.setPitch(1.0);
//   }

//   Future<void> startListening(Function(String) onResult) async {
//     if (!_isInitialized) throw Exception('Speech service not initialized');
//     await _speech.listen(
//       onResult: (result) {
//         if (result.finalResult) {
//           onResult(result.recognizedWords);
//         }
//       },
//       localeId: _currentLocale,
//     );
//   }

//   Future<void> stopListening() async {
//     if (_isInitialized) await _speech.stop();
//   }

//   Future<void> speak(String text) async {
//     if (!_isInitialized) return;
//     await _tts.speak(text);
//   }

//   Future<void> stop() async {
//     await _speech.stop();
//     await _tts.stop();
//   }
// }
/////////////////////
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SpeechService {
//   static final SpeechService _instance = SpeechService._internal();
//   factory SpeechService() => _instance;
//   SpeechService._internal();

//   final SpeechToText _speechToText = SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();
//   bool _speechEnabled = false;
//   bool get isListening => _speechToText.isListening;

//   Future<bool> initialize() async {
//     try {
//       // Request microphone permission
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         return false;
//       }

//       _speechEnabled = await _speechToText.initialize(
//         onError: (error) => print('Speech recognition error: $error'),
//         onStatus: (status) => print('Speech recognition status: $status'),
//       );

//       if (_speechEnabled) {
//         await _flutterTts.setLanguage('en-US');
//         await _flutterTts.setPitch(1.0);
//         await _flutterTts.setSpeechRate(0.5);
//         await _flutterTts.setVolume(1.0);
//         await _flutterTts.setIosAudioCategory(
//           IosTextToSpeechAudioCategory.playback,
//           [
//             IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
//           ],
//           IosTextToSpeechAudioMode.defaultMode,
//         );
//       }

//       return _speechEnabled;
//     } catch (e) {
//       print('Speech service initialization error: $e');
//       return false;
//     }
//   }

//   Future<void> startListening(Function(String) onResult) async {
//     if (!_speechEnabled) {
//       print('Speech recognition not initialized');
//       return;
//     }

//     try {
//       await _speechToText.listen(
//         onResult: (result) {
//           if (result.finalResult) {
//             onResult(result.recognizedWords);
//           }
//         },
//         listenFor: Duration(seconds: 10),
//         pauseFor: Duration(seconds: 5),
//         partialResults: true,
//         cancelOnError: true,
//         listenMode: ListenMode.confirmation,
//       );
//     } catch (e) {
//       print('Error starting speech recognition: $e');
//     }
//   }

//   Future<void> stopListening() async {
//     try {
//       await _speechToText.stop();
//     } catch (e) {
//       print('Error stopping speech recognition: $e');
//     }
//   }

//   Future<void> speak(String text) async {
//     try {
//       await _flutterTts.stop(); // Stop any ongoing speech
//       await _flutterTts.speak(text);
//     } catch (e) {
//       print('Text-to-speech error: $e');
//     }
//   }

//   Future<void> stop() async {
//     try {
//       await _flutterTts.stop();
//     } catch (e) {
//       print('Error stopping text-to-speech: $e');
//     }
//   }
// }
