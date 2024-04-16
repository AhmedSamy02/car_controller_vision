import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SerialBluetooth {
  static BluetoothConnection? _connection;
  static const String address = '98:D3:B1:FD:73:E3';
  void sendValue(String value) {
    _connection?.output.add(utf8.encode(value));
  }
  

  static Future<void> connect() async {
    try {
      _connection = await BluetoothConnection.toAddress(address);
      Fluttertoast.showToast(
          msg: 'Connected to the device',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      _connection?.input?.listen((event) {
        print(String.fromCharCodes(event));
      }).onDone(() {
        print('Disconnected remotely');
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
      Fluttertoast.showToast(
          msg: 'Can\'t Connect',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future<void> disconnect() async {
    try {
      await _connection!.finish();
      Fluttertoast.showToast(
          msg: 'Disconnected from the device',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (exception) {
      print('Cannot disconnect, exception occured');
      Fluttertoast.showToast(
          msg: 'Can\'t Disconnect',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
