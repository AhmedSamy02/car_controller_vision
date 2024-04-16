import 'package:camera/camera.dart';
import 'package:car_controller/constants.dart';
import 'package:car_controller/controllers/serial_bluetooth.dart';
import 'package:car_controller/views/initial_setup/init_image_screen.dart';
import 'package:flutter/material.dart';

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
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const InitImageScreen();
                }));
              },
              child: const Text('Init Image'),
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text('Image Detection')),
            ElevatedButton(onPressed: () {}, child: const Text('Disconnect'))
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
