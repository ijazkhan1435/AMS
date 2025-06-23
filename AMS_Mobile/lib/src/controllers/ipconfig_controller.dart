import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/connectivityService.dart';
import '../utils/routes/routes.dart';

class IpConfigController extends GetxController {
  GetStorage box =GetStorage();
  ConnectivityService cs = Get.put(ConnectivityService());
  TextEditingController ip = TextEditingController();
  RxBool connectivityCheck=false.obs;
  save() {
    if (ip.text != '') {
      box.write('ip', ip.text);
      // Get.toNamed(Routes.login);
    }else{
      Get.snackbar('Error',
          'Please enter IpAddress',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}