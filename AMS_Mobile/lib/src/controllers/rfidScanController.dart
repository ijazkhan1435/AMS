

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utils/helpers/api_helper.dart';
import '../utils/routes/routes.dart';

class RfidScanController extends GetxController {
  static const platform = MethodChannel('rfid');
  RxList tagList = [].obs;
  RxList foundAssets = [].obs;
  RxList missingAssets = [].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    platform.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onTagRead':
        if (!tagList.contains(call.arguments as String)) {
          tagList.add(call.arguments as String);
        }
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }



}
