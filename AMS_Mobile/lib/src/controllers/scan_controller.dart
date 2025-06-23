
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_application_1/src/services/rfid_service.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/staticData.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../utils/helpers/api_helper.dart';
import 'assetsImport_controller.dart';

class ScanController extends GetxController {
  final TextEditingController siteController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final AssetsImportController assetsImportController = Get.put(AssetsImportController());


  DatabaseHelper db = Get.put(DatabaseHelper());

  int? locationId;
  int? index;
  int siteIndex=1;
  List locationcheck=[];
  List filterLocation=[];


  dynamic deviceStatus = 'Disconnected';
  dynamic Location = [];
  dynamic site = [].obs;
  dynamic location = [].obs;


  RxList<String> getlocation = <String>[].obs;
  RxList<String> getlocationdescription = <String>[].obs;
  RxList<String> getsite = <String>[].obs;
  RxBool isLoading = true.obs;
  bool scanCheck = false;

  var selectedRadio = 'Option2'.obs;
  final RxBool showTextField = true.obs;
  final RxString result = ''.obs;

  void setSelectedRadio(String value) {
    selectedRadio.value = value;
  }

  Future<void> startScan(int siteId,int locationId) async {
    if (scanCheck) {
      Get.toNamed(Routes.rfidScan, arguments: {
        'siteID': siteId,
        'locationID': locationId,
      });
    } else {
      Get.toNamed(Routes.allAssets, arguments: {
        'siteID': siteId,
        'locationID': locationId,
      });
    }
  }

  @override
  void onInit() async {
    rfidAccess();
    getLocation();
    getLocationDescription();
    getSite();

    super.onInit();
  }




  rfidAccess() async {
    if (Platform.isAndroid) {
      deviceStatus = await RfidService.getConnectionStatus();
    }
  }

  @override
  void onClose() {
    siteController.dispose();
    locationController.dispose();
    super.onClose();
  }

  getLocation() async {
    List all = await db.getTasks('location');
    location.value = List.from(all);
    isLoading.value = false;
  }

  getLocationDescription() async {
    List all = await db.getTasks('location');
    location.value = List.from(all);
    locationcheck=all;
    for (var i = 0; i < location.length; i++) {
      getlocationdescription.add(location[i]["locationDescription"]);
    }
    isLoading.value = false;
  }



  getSite() async {
    List all = await db.getTasks('site');
    site.value = List.from(all);
    for (var i = 0; i < site.length; i++) {
      getsite.add(site[i]["siteDescription"]);
    }
    isLoading.value = false;
  }

}



