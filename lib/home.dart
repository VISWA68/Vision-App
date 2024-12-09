import 'package:flutter/material.dart';
import 'package:vision_app/face.dart';
import 'package:vision_app/image.dart';
import 'package:vision_app/text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    //BarcodeScannerPage(),
    FaceDetectionPage(),
    ImageLabelerPage(),
    TextRecognitionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Vision Features'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Face Detection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label),
            label: 'Image Labeling',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: 'Text Recognition',
          ),
        ],
      ),
    );
  }
}
