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
typedef _c_init = Bool Function(
    Pointer<Uint8> PngBytes, Int inBytesCount, Int threshold);
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
    Int detectStraightLines_line_width);

// Dart functions signatures
typedef _dart_version = Pointer<Uint8> Function();
typedef _dart_destroy = bool Function();
typedef _dart_init = bool Function(
    Pointer<Uint8> PngBytes, int inBytesCount, int threshold);
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
    int detectStraightLines_line_width);

// Create dart functions that invoke the C function
final _version = nativeLib.lookupFunction<_c_version, _dart_version>('version');
final _init = nativeLib.lookupFunction<_c_init, _dart_init>('initImage');
final _destroyImage =
    nativeLib.lookupFunction<_c_destroy, _dart_destroy>('destroyImage');
final _preprocessImage =
    nativeLib.lookupFunction<_c_preprocess_image, _dart_preprocess_image>(
        'preprocessImage');

class NativeOpencv {
  static const MethodChannel _channel = MethodChannel('native_opencv');
  static int imLength = 0;
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  bool initImage(Uint8List img, {int threshold = 100}) {
    imLength = img.length;
    var imgBuffer = malloc.allocate<Uint8>(img.length);
    imgBuffer.asTypedList(img.length).setAll(0, img);
    var b = _init(imgBuffer, img.length, threshold);

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
      int detectStraightLines_line_width) {
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
        detectStraightLines_line_width);
    return img.asTypedList(imLength);
  }
}
