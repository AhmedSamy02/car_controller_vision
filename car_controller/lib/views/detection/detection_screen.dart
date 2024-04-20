import 'package:camera/camera.dart';
import 'package:car_controller/constants.dart';
import 'package:car_controller/services/isolates_creation.dart';
import 'package:flutter/material.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  late CameraController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final stopwatch = Stopwatch();
    stopwatch.start();

    CreateIsolates.createIsolate();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller.startImageStream((CameraImage image) async {
        
        // CreateIsolates.sendToIsolate(image.planes[0].bytes);
      });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Screen'),
      ),
      body: CameraPreview(_controller),
    );
  }
}
