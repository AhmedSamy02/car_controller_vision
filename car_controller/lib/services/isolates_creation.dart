import 'dart:isolate';

import 'package:car_controller/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_opencv/native_opencv.dart';

class CreateIsolates {
  CreateIsolates._();
  static final CreateIsolates instance = CreateIsolates._();
  static late SendPort detectionSendPort;
  static late ReceivePort detectionRecievePort;
  static void detection(SendPort mainSendPort) async {
    /// Set up a receiver port for Mike
    ReceivePort detectionReceivePort = ReceivePort();

    /// Send Mike receivePort sendPort via mySendPort
    mainSendPort.send(detectionReceivePort.sendPort);

    /// Listen to messages sent to Mike's receive port
    detectionReceivePort.listen((message) {
      // if (message.length == 0) {
      //   detectionReceivePort.close();
      // }
      if (message is Uint8List) {
        print('I recieved List of length = ${message.length}');
        var opencv = getIt.get<NativeOpencv>();
        // Future.delayed(Durations.extralong4);
        int result = opencv.speedup(message);

        print('Result = $result');
      }
    });
  }

  static Future<void> createIsolate() async {
    ReceivePort mainReceivePort = ReceivePort();
    Isolate.spawn<SendPort>(detection, mainReceivePort.sendPort);
    detectionSendPort = await mainReceivePort.first;
    detectionRecievePort = ReceivePort();
  }

  static Future<void> sendToIsolate(Uint8List image) async {
    detectionSendPort.send(image);
  }
}
