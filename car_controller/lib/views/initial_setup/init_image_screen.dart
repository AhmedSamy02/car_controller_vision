import 'dart:io';

import 'package:camera/camera.dart';
import 'package:car_controller/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InitImageScreen extends StatefulWidget {
  const InitImageScreen({super.key});

  @override
  State<InitImageScreen> createState() => _InitImageScreenState();
}

class _InitImageScreenState extends State<InitImageScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );
    controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double zoomLevel = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Init Image',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      )),
      body: Center(
        child: !controller.value.isInitialized
            ? const CircularProgressIndicator()
            : Stack(
                children: [
                  controller.buildPreview(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 7.0,
                        bottom: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                double maxZoom =
                                    await controller.getMaxZoomLevel();
                                if (zoomLevel >= maxZoom) return;
                                zoomLevel = zoomLevel + maxZoom / 20;
                                controller.setZoomLevel(zoomLevel);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(14),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final image = await picker.pickImage(
                                    source: ImageSource.camera);
                                
                                var lis = await image!.readAsBytes();
                                print('Taken Successfully = ${lis.length}');
                                Navigator.pushNamed(
                                  context,
                                  kInitSlidersScreen,
                                  arguments: lis,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(14),
                              ),
                              child: const Icon(Icons.camera_alt),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (zoomLevel <= 1.0) return;
                              zoomLevel = zoomLevel -
                                  (await controller.getMaxZoomLevel() / 10);
                              controller.setZoomLevel(zoomLevel);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(14),
                            ),
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
