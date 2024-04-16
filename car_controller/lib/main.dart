import 'package:car_controller/constants.dart';
import 'package:car_controller/controllers/serial_bluetooth.dart';
import 'package:car_controller/views/home_screen.dart';
import 'package:car_controller/views/initial_setup/init_image_preview.dart';
import 'package:flutter/material.dart';
import 'package:native_opencv/native_opencv.dart';

import 'views/initial_setup/init_image_screen.dart';
import 'views/initial_setup/init_sliders_screen.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: false,
      ),
      routes: {
        kHomeScreen: (context) => const HomeScreen(),
        kInitImageScreen: (context) => const InitImageScreen(),
        kInitSlidersScreen: (context) => const InitSliderScreen(),
        kInitImagePreviewScreen: (context) => const InitImagePreview(),
      },
      initialRoute: kHomeScreen,
    );
  }
}

void setup() {
  getIt.registerSingleton<NativeOpencv>(NativeOpencv());
  getIt.registerSingleton<SerialBluetooth>(SerialBluetooth());
}
