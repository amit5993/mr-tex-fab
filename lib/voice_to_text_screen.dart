// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class VoiceToTextScreen extends StatefulWidget {
//   const VoiceToTextScreen({super.key});
//
//   @override
//   State<VoiceToTextScreen> createState() => _VoiceToTextScreenState();
// }
//
// class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _text = "Press the button and start speaking";
//   double _confidence = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }
//
//   Future<void> _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (status) => print('Status: $status'),
//         onError: (error) => print('Error: $error'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (result) {
//             setState(() {
//               _text = result.recognizedWords;
//               _confidence = result.confidence;
//             });
//           },
//         );
//       } else {
//         setState(() => _isListening = false);
//         print("The user has denied speech recognition permissions.");
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Voice to Text"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             Text(
//               _text,
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _listen,
//               child: Text(_isListening ? "Stop Listening" : "Start Listening"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
