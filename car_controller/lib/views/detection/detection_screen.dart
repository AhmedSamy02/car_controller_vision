import 'package:camera/camera.dart';
import 'package:car_controller/constants.dart';
import 'package:car_controller/controllers/serial_bluetooth.dart';
import 'package:car_controller/services/isolates_creation.dart';
import 'package:flutter/material.dart';
import 'package:native_opencv/native_opencv.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  int timer = 0;
  // bool b = false;
  late CameraController _controller;
  bool result = true;
  @override
  void initState() {
    super.initState();
    CreateIsolates.createIsolate();
    _controller = CameraController(cameras[0], ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.jpeg);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      var opencv = getIt.get<NativeOpencv>();
      _controller.startImageStream((CameraImage image) async {
        // CreateIsolates.sendToIsolate(image.planes[0].bytes);
        var result = opencv.speedup(image.planes[0].bytes);
        SerialBluetooth.sendValue(result != 0 ? "0" : "1");
        debugPrint('Result = $result');
        setState(() {});
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
      body: Column(
        children: [
          CameraPreview(_controller),
          Text(
            'Result = $result',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
