import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelerPage extends StatefulWidget {
  @override
  _ImageLabelerPageState createState() => _ImageLabelerPageState();
}

class _ImageLabelerPageState extends State<ImageLabelerPage> {
  final ImagePicker _picker = ImagePicker();
  String _results = "No labels detected";

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      final inputImage = InputImage.fromFilePath(image.path);
      final imageLabeler = GoogleMlKit.vision.imageLabeler();

      final labels = await imageLabeler.processImage(inputImage);
      imageLabeler.close();

      setState(() {
        _results = labels.map((label) => "${label.label} (${label.confidence})").join("\n");
      });
    } else {
      setState(() {
        _results = "No image selected.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Labeling")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.camera),
              child:const Text("Capture Image"),
            ),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.gallery),
              child: const Text("Pick Image from Gallery"),
            ),
            const SizedBox(height: 20),
            Text(_results, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
