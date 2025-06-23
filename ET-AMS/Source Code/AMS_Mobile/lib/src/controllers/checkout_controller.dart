import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../utils/helpers/db_helper.dart';
class  checkoutController extends GetxController{
  final TextEditingController siteController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  DatabaseHelper db = Get.put(DatabaseHelper());

int? locationId;
  int? index;
  int siteIndex=1;
  List locationcheck=[];
  List filterLocation=[];
  dynamic site = [].obs;
  dynamic location = [].obs;
  RxList<String> getlocation = <String>[].obs;
  RxList<String> getlocationdescription = <String>[].obs;
  RxList<String> getsite = <String>[].obs;
  RxBool isLoading = true.obs;

  getLocationDescription() async {
    List all = await db.getTasks('location');
    location.value = List.from(all);
    locationcheck=all;
    for (var i = 0; i < location.length; i++) {
      getlocationdescription.add(location[i]["locationDescription"]);
    }
    isLoading.value = false;
  }

  getLocation() async {
    List all = await db.getTasks('location');
    location.value = List.from(all);
    isLoading.value = false;
  }

  getSite() async {
    List all = await db.getTasks('location');
    location.value = List.from(all);
    for (var i = 0; i < location.length; i++) {
      getsite.add(location[i]["siteDescription"]);
    }
    isLoading.value = false;
  }

  @override
  void onInit() async {
    getLocation();
    getLocationDescription();
    getSite();
    var arg =Get.arguments;
    super.onInit();
  }
  @override
  void onClose() {
    siteController.dispose();
    locationController.dispose();
    super.onClose();
  }
}