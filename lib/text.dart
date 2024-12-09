import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextRecognitionPage extends StatefulWidget {
  @override
  _TextRecognitionPageState createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  final ImagePicker _picker = ImagePicker();
  String _recognizedText = "No text recognized";
  bool _isLoading = false;

  Future<void> pickImage(ImageSource source) async {
    final XFile? imageFile = await _picker.pickImage(source: source);

    if (imageFile != null) {
      setState(() {
        _isLoading = true;
      });

      final inputImage = InputImage.fromFilePath(imageFile.path);

      // Initialize the text recognizer
      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      // Process the image
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      textRecognizer.close();

      setState(() {
        _recognizedText = recognizedText.text.isNotEmpty
            ? recognizedText.text
            : "No text found in the image.";
        _isLoading = false;
      });
    } else {
      setState(() {
        _recognizedText = "No image selected.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Recognition"),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.camera),
                    child: Text("Capture Image"),
                  ),
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery),
                    child: Text("Pick Image from Gallery"),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        _recognizedText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
