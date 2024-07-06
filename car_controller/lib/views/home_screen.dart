import 'package:camera/camera.dart';
import 'package:car_controller/constants.dart';
import 'package:car_controller/controllers/serial_bluetooth.dart';
import 'package:car_controller/views/initial_setup/init_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_opencv/native_opencv.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool b = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(() async {
      cameras = await availableCameras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Controller'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  kDetectionScreen,
                );
              },
              child: const Text('Image Detection'),
            ),
            ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final image =
                      await picker.pickImage(source: ImageSource.camera);
                  var lis = await image!.readAsBytes();
                  // var b = NativeOpencv();
                  // Future.delayed(Durations.extralong4);
                  print('Taken Successfully = ${lis.length}');
                  var opencv = getIt.get<NativeOpencv>();
                  var result = opencv.initImage(lis);
                  print('Result = $result');

                  Navigator.pushNamed(
                    context,
                    kInitImagePreviewScreen,
                    arguments: result,
                  );
                },
                child: const Text('Init Image')),
            ElevatedButton(
                onPressed: () {
                  SerialBluetooth.sendValue("1");
                },
                child: const Text('Send 1')),
            ElevatedButton(
                onPressed: () {
                  SerialBluetooth.sendValue("0");
                },
                child: const Text('Send 0')),
            ElevatedButton(onPressed: () {}, child: const Text('Disconnect')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Start scanning
          await SerialBluetooth.connect();
        },
        child: const Icon(Icons.bluetooth),
      ),
    );
  }
}
