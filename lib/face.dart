import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String _results = "No faces detected";
  bool _isProcessing = false;

  // Function to pick an image
  Future<void> pickImage(ImageSource source) async {
    final XFile? imageFile = await _picker.pickImage(source: source);

    if (imageFile != null) {
      setState(() {
        _selectedImage = File(imageFile.path);
      });
    }
  }

  // Function to process the image
  Future<void> processImage(File imageFile) async {
    setState(() {
      _isProcessing = true;
    });

    final inputImage = InputImage.fromFilePath(imageFile.path);

    final faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);
    faceDetector.close();

    setState(() {
      _isProcessing = false;

      if (faces.isNotEmpty) {
        _results = "Detected ${faces.length} face(s)\n\n";
        for (var face in faces) {
          _results +=
              "Bounding Box: ${face.boundingBox}\nSmiling Probability: ${face.smilingProbability ?? 'N/A'}\n";
        }
      } else {
        _results = "No faces detected.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Detection"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Column(
                children: [
                  Image.file(
                    _selectedImage!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => processImage(_selectedImage!),
                    child: const Text("Process Image"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.camera),
              child: const Text("Capture Image"),
            ),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.gallery),
              child: const Text("Pick Image from Gallery"),
            ),
            const SizedBox(height: 20),
            if (_isProcessing)
              const CircularProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _results,
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
