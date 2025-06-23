
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/services/connectivityService.dart';

import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/helpers/api_helper.dart';

class LoginScreenController extends GetxController {
  ConnectivityService cs = Get.put(ConnectivityService());

  GetStorage box = GetStorage();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool loginCheck = false.obs;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void onClose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  submit(email, password) async {
    if (email != '' || password != '') {
      loginCheck.value = true;
      var res = await apiFetcher("Post",'/api/UserProfile/Authenticate',
          {"userName": email, "password": password});

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        box.write('token', data['token']);
        box.write('userId', data['userId']);

        Get.toNamed(Routes.dashboard);
      }
      if (res.statusCode == 401 ||
          res.statusCode == 400 ||
          res.statusCode == 500) {
        Get.snackbar('Error', '${res.body}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
      loginCheck.value = false;
    }
  }

  logIn() async {

    if (email.text == "user" && password.text == "123" ||
        email.text == "admin" && password.text == "123") {
      box.write('auth', true);

      Get.toNamed(Routes.dashboard);
      email.text='';
      password.text='';
    } else {
      Get.snackbar('Oops!', 'Invailed Email or Password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }

  }
  @override
  void onInit() async {
    super.onInit();
  }

}
