import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/dashboard_controller.dart';
import 'package:flutter_application_1/src/utils/helpers/api_helper.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';

import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ViewAssetsController extends GetxController {
  DashboardController dc = Get.find<DashboardController>();
  final TextEditingController siteController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  DatabaseHelper db = Get.put(DatabaseHelper());

  dynamic data = [];

  int? locationId;
  int? index;
  int siteIndex=1;
  List locationcheck=[];
  List filterLocation=[];

  dynamic Location = [];
  dynamic site = [].obs;
  dynamic location = [].obs;
  RxList<dynamic> filteredData = <dynamic>[].obs;

  RxList<String> getlocation = <String>[].obs;
  RxList<String> getlocationdescription = <String>[].obs;
  RxList<String> getsite = <String>[].obs;
  RxBool isLoading = true.obs;
  RxString selectedStatus = ''.obs;


  final RxString result = ''.obs;
  List check=[];
  dynamic scanId = '';

  scanData(id) {
    isLoading.value = true;
    check.add(id);
    bool foundCheck = false;
    String searchId = id.trim().toLowerCase();
    for (var i = 0; i < data.length; i++) {
      // print(data.length);
      if (searchId == data[i]['assetTagID'].toString().trim().toLowerCase()) {
        // print(i);
        foundCheck = true;
        dynamic obj = data[i];
        print(obj);
        data.removeAt(i);
        data.insert(0, obj);
        break;
      }
    }
    if (!foundCheck) {
      check = [];
      print('not found');
      Get.defaultDialog(
        title: "Oops, Not Found",
        content: Text('Please Try Again'),
      );
    }
    filteredData.assignAll(data);
    isLoading.value = false;

  }

  @override
  void onInit() async {
    getData();
    getLocation();
    getLocationDescription();
    // getSite();
    super.onInit();
  }

  Future<void> viewAsset() async {
    var res = await Get.to<String>(() => SimpleBarcodeScannerPage());
    if (res != null) {
      scanData(res);
    }
  }

  getData() async {
    List all = await db.getTasks('assets');
    data =List.from(all);
    filteredData.assignAll(data);
    isLoading.value = false;
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

  filterAsset(String siteDes,String locationDes,String Status){
    if(siteDes.isEmpty && locationDes.isEmpty && Status.isEmpty){

      filteredData.assignAll(data);
      // log("====111 ${filteredData.length}");
    }else{
      filteredData.value=data.where((value)=>value["siteDescription"].toString().trim().toLowerCase()==siteDes.trim().toLowerCase() && value["locationDescription"].toString().trim().toLowerCase()==locationDes.trim().toLowerCase() && value["assetsStatus"].toString().trim().toLowerCase()==Status.trim().toLowerCase()).toList();

    // log("=== filter data ${filteredData.length}");
    }

  }

}
