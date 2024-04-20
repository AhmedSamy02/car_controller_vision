import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';

late List<CameraDescription> cameras;
final getIt = GetIt.instance;
const String kHomeScreen = 'home_screen';
const String kInitSlidersScreen = 'init_sliders_screen';
const String kInitImageScreen = 'init_image_screen';
const String kInitImagePreviewScreen = 'init_image_preview_screen';
const String kDetectionScreen = 'detection_screen';
