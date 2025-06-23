
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/app.dart';
import 'package:flutter_application_1/src/controllers/assetsImport_controller.dart';
import 'package:flutter_application_1/src/services/connectivityService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
void main() {
  HttpOverrides.global = MyHttpOverrides();

   // GetStorage.init();
  runApp(const MyApp());
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {

    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


