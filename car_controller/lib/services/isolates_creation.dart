import 'dart:isolate';

import 'package:flutter/services.dart';

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
      print('I recieved List of length = ${message.length}');
      if (message.length == 0) {
        detectionReceivePort.close();
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
