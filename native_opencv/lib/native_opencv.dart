// Load our C lib
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open("libnative_opencv.so")
    : DynamicLibrary.process();

// C Functions signatures
typedef _c_version = Pointer<Uint8> Function();
typedef _c_destroy = Bool Function();
typedef _c_init = Pointer<Uint8> Function(Pointer<Uint8> PngBytes,
    Int inBytesCount, Int threshold, Int height_up, Float height_down);
typedef _c_preprocess_image = Pointer<Uint8> Function(
    Int filterLargeContours_threshold,
    Int RefixThreholds_binary_threshold,
    Int RefixThreholds_size_theshold,
    Int detectStraightLines_dilation_iterations,
    Int detectStraightLines_horizontal_iterations,
    Int detectStraightLines_diagonal1_iterations,
    Int detectStraightLines_diagonal2_iterations,
    Int detectStraightLines_area_threshold,
    Int detectStraightLines_width_threshold,
    Int detectStraightLines_line_width,
    Bool contours_threshold);
typedef _c_speedup = Int Function(
  Pointer<Uint8> PngBytes,
  Int inBytesCount,
);
// Dart functions signatures
typedef _dart_version = Pointer<Uint8> Function();
typedef _dart_destroy = bool Function();
typedef _dart_init = Pointer<Uint8> Function(
  Pointer<Uint8> PngBytes,
  int inBytesCount,
  int threshold,
  int height_up,
  double height_down,
);

typedef _dart_preprocess_image = Pointer<Uint8> Function(
  int filterLargeContours_threshold,
  int RefixThreholds_binary_threshold,
  int RefixThreholds_size_theshold,
  int detectStraightLines_dilation_iterations,
  int detectStraightLines_horizontal_iterations,
  int detectStraightLines_diagonal1_iterations,
  int detectStraightLines_diagonal2_iterations,
  int detectStraightLines_area_threshold,
  int detectStraightLines_width_threshold,
  int detectStraightLines_line_width,
  bool contours_threshold,
);
typedef _dart_speedup = int Function(
  Pointer<Uint8> PngBytes,
  int inBytesCount,
);
// Create dart functions that invoke the C function
final _version = nativeLib.lookupFunction<_c_version, _dart_version>('version');
final _init = nativeLib.lookupFunction<_c_init, _dart_init>('initImage');
final _destroyImage =
    nativeLib.lookupFunction<_c_destroy, _dart_destroy>('destroyImage');
final _preprocessImage =
    nativeLib.lookupFunction<_c_preprocess_image, _dart_preprocess_image>(
        'preprocessImage');
final _speedup = nativeLib.lookupFunction<_c_speedup, _dart_speedup>('speedUp');

class NativeOpencv {
  static const MethodChannel _channel = MethodChannel('native_opencv');

  static int imLength = 0;
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Uint8List initImage(Uint8List img,
      {int threshold = 180, int height_up = 1200, double height_down = 1.8}) {
    imLength = img.length;
    var imgBuffer = malloc.allocate<Uint8>(img.length);
    imgBuffer.asTypedList(img.length).setAll(0, img);
    var b = _init(imgBuffer, img.length, threshold, height_up, height_down);

    malloc.free(imgBuffer);
    return b.asTypedList(img.length);
  }

  int speedup(
    Uint8List img,
  ) {
    imLength = img.length;
    var imgBuffer = malloc.allocate<Uint8>(img.length);
    imgBuffer.asTypedList(img.length).setAll(0, img);
    print(imgBuffer.value);
    var b = _speedup(imgBuffer, img.length);
    malloc.free(imgBuffer);
    return b;
  }

  bool destroyImage() {
    return _destroyImage();
  }

  String cvVersion() {
    return _version().asTypedList(5).map((e) {
      return String.fromCharCode(e);
    }).join('');
  }

  Uint8List preprocessImage(
      int filterLargeContours_threshold,
      int RefixThreholds_binary_threshold,
      int RefixThreholds_size_theshold,
      int detectStraightLines_dilation_iterations,
      int detectStraightLines_horizontal_iterations,
      int detectStraightLines_diagonal1_iterations,
      int detectStraightLines_diagonal2_iterations,
      int detectStraightLines_area_threshold,
      int detectStraightLines_width_threshold,
      int detectStraightLines_line_width,
      bool contours_threshold) {
    var img = _preprocessImage(
        filterLargeContours_threshold,
        RefixThreholds_binary_threshold,
        RefixThreholds_size_theshold,
        detectStraightLines_dilation_iterations,
        detectStraightLines_horizontal_iterations,
        detectStraightLines_diagonal1_iterations,
        detectStraightLines_diagonal2_iterations,
        detectStraightLines_area_threshold,
        detectStraightLines_width_threshold,
        detectStraightLines_line_width,
        contours_threshold);
    return img.asTypedList(imLength);
  }
}
