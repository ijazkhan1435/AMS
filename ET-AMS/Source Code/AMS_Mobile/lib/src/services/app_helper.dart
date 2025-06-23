import 'dart:async';
import 'package:flutter/services.dart';

class AppHelper {
  static const MethodChannel _channel = MethodChannel('rfid');


  static Future<bool> initialize() async {
    final bool result = await _channel.invokeMethod('initialize');
    return result;
  }

  static Future<String?> getInstance() async{
    print('instant');
    final String? result = await _channel.invokeMethod('getInstance');
    return result;
  }

  static Future<void> release() async {
    await _channel.invokeMethod('release');
  }

  static Future<bool> getConnectionStatus() async {
    final bool status = await _channel.invokeMethod('getConnectionStatus');
    return status;
  }

  static Future<void> setSoftwareTrigger(bool flag) async {
    await _channel.invokeMethod('setSoftwareTrigger', {'flag': flag});
  }

  static Future<bool> getSoftwareTriggerStatus() async {
    final bool status = await _channel.invokeMethod('getSoftwareTriggerStatus');
    return status;
  }

  static Future<void> setRFIDMode(String mode) async {
    await _channel.invokeMethod('setRFIDMode', {'mode': mode});
  }

  static Future<String> getRFIDMode() async {
    final String mode = await _channel.invokeMethod('getRFIDMode');
    return mode;
  }

  static Future<void> inventory() async {
    await _channel.invokeMethod('inventory');
  }

  static Future<void> cancelInventory() async {
    await _channel.invokeMethod('cancelInventory');
  }

  static Future<bool> readTag(Map<String, dynamic> args) async {
    final bool result = await _channel.invokeMethod('readTag', args);
    return result;
  }

  static Future<bool> writeTag(Map<String, dynamic> args) async {
    final bool result = await _channel.invokeMethod('writeTag', args);
    return result;
  }

  static Future<bool> lockTag(Map<String, dynamic> args) async {
    final bool result = await _channel.invokeMethod('lockTag', args);
    return result;
  }

  static Future<bool> unlockTag(Map<String, dynamic> args) async {
    final bool result = await _channel.invokeMethod('unlockTag', args);
    return result;
  }

  static Future<void> setUntraceableTag(Map<String, dynamic> args) async {
    await _channel.invokeMethod('setUntraceableTag', args);
  }

  static Future<void> setAuthenticateTag(Map<String, dynamic> args) async {
    await _channel.invokeMethod('setAuthenticateTag', args);
  }

  static Future<bool> getIncludedEPCFilter(Map<String, dynamic> args) async {
    final bool result =
        await _channel.invokeMethod('getIncludedEPCFilter', args);
    return result;
  }

  static Future<bool> setIncludedEPCFilter(Map<String, dynamic> args) async {
    final bool result =
        await _channel.invokeMethod('setIncludedEPCFilter', args);
    return result;
  }

  static Future<void> startLog(bool enable) async {
    await _channel.invokeMethod('startLog', {'enable': enable});
  }

  static Future<void> writeLog(String str) async {
    await _channel.invokeMethod('writeLog', {'log': str});
  }

  static Future<void> saveEPC(String epc) async {
    await _channel.invokeMethod('saveEPC', {'epc': epc});
  }

  static Future<String> loadEPC() async {
    final String epc = await _channel.invokeMethod('loadEPC');
    return epc;
  }

}
