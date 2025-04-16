import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:html'; // For accessing the camera on the web
import 'dart:ui_web' as ui_web;

class AnotherScreen extends StatelessWidget {
  const AnotherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: GestureToSpeechScreen(),
    );
  }
}

class GestureToSpeechScreen extends StatefulWidget {
  const GestureToSpeechScreen({super.key});

  @override
  _GestureToSpeechScreenState createState() => _GestureToSpeechScreenState();
}

class _GestureToSpeechScreenState extends State<GestureToSpeechScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String gestureText = "Aucun geste détecté";
  late VideoElement _videoElement;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() {
    _videoElement = VideoElement();
    _videoElement.style.width = '100%';
    _videoElement.style.height = '100%';

    ui_web.platformViewRegistry.registerViewFactory(
      'camera-view',
      (int viewId) => _videoElement,
    );

    window.navigator.mediaDevices?.getUserMedia({'video': true}).then((MediaStream stream) {
      _videoElement.srcObject = stream;
      _videoElement.play();
    }).catchError((error) {
      print('Error accessing the camera: $error');
    });
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("fr-FR");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: HtmlElementView(viewType: 'camera-view'),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Color(0xFF006400)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.gesture, color: Color(0xFF006400), size: 24),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          gestureText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    speak(gestureText);
                  },
                  icon: Icon(Icons.mic, color: Colors.white),
                  label: Text(
                    'Parler',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006400),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
