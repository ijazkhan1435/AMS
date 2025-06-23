import 'dart:developer';

import 'package:flutter/services.dart';

class RfidService {
  static const MethodChannel _channel = MethodChannel('rfid');

  static Future<String?> getServiceVersion() async {
    final String? version = await _channel.invokeMethod('getServiceVersion');
    return version;
  }

  static Future<String?> getInstance() async{
    print('instant');
    final String? result = await _channel.invokeMethod('getInstance');
    return result;
  }

  static Future<String?> getConnectionStatus() async {
    print('object');
    final String? conn = await _channel.invokeMethod('getConnectionStatus');
    return conn;
  }

  static Future<int?> getReaderbatterylevel() async {
    // print('object');
    final int? battery = await _channel.invokeMethod('getBatteryLevel');
    print('fff');

    return battery;
  }

  static Future<String?> startInventory() async {
    final String? result = await _channel.invokeMethod('startInventory');
    return result;
  }

  static Future<String?> stopInventory() async {
    final String? result = await _channel.invokeMethod('stopInventory');
    return result;
  }

  static Future<String?> readTag() async {
    try {
      final String? result = await _channel.invokeMethod('readTag');
      return result;
    } on PlatformException catch (e) {
      print("Failed to read tag: '${e.message}'.");
      return null;
    }
  }
  static Future<String?> showRSSI() async {
    try {
      final String? result = await _channel.invokeMethod('showRssi');
      log("========result $result");
      return result;
    } on PlatformException catch (e) {
      print("Failed to read tag: '${e.message}'.");
      return null;
    }
  }

  static Future<String?> startLocating() async {
    try {
      final String? result = await _channel.invokeMethod('startLocating');
      log("Start Locating result: $result");
      return result;
    } on PlatformException catch (e) {
      print("Failed to start locating: '${e.message}'.");
      return null;
    }
  }

  static void setTagReadHandler(Function(String) handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onTagRead') {
        handler(call.arguments as String);
      }
    });
  }
}
