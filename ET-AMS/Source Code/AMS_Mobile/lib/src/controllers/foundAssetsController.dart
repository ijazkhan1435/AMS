
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/src/controllers/dashboard_controller.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class FoundAssetsController extends GetxController {
  DatabaseHelper db = Get.put(DatabaseHelper());
  DashboardController dc = Get.put(DashboardController());

  RxList<dynamic>data = <dynamic>[].obs;
  RxList filterData = <dynamic>[].obs;
  RxList check = <dynamic>[].obs;

  dynamic scanId = '';
  RxBool isLoading = true.obs;
  RxBool isLoadingNew = true.obs;
  RxBool isLoadingNot = false.obs;

  var arg = Get.arguments;


  foundAssets() async {
    isLoading.value = true;
    data.value = await db.getTasks('assets');
    filterData.clear();
    dc.notfound = [];
    dc.newAssets = [];

    if (arg != null) {
      if (arg['tagList'] is List) {
        Set<String> tagList = Set<String>.from(arg['tagList']);
        filterData.value = data
            .where((asset) => tagList.contains(asset['assetTagID'].toString()) &&
            asset['assetID'] != null)
            .toList();

        dc.found = List.from(filterData);


        for (var asset in filterData) {
          if (asset['status'] != 'Found') {
            await db.updateAssetStatus(asset['assetTagID'], 'Found');
          }
        }

        for (var asset in data) {
          if (!tagList.contains(asset['assetTagID'].toString())) {
            dc.notfound.add(asset);
          }
        }

        for (var tag in tagList) {
          if (!data.any((asset) => asset['assetTagID'].toString() == tag && asset['assetID'] != null)) {
            dc.newAssets.add(tag);
          }
        }
      }
    } else {
      dc.notfound.addAll(data);
    }


    await saveAuditResultsToPrefs(
      found: dc.found,
      notfound: dc.notfound,
      newAssets: dc.newAssets,
    );
    isLoading.value = false;
  }

  Future<void> saveAuditResultsToPrefs({
    required List<dynamic> found,
    required List<dynamic> notfound,
    required List<dynamic> newAssets,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('foundAssets', jsonEncode(found));
    await prefs.setString('notFoundAssets', jsonEncode(notfound));
    await prefs.setString('newAssets', jsonEncode(newAssets));

  }

  scanData(String id, {bool newCheck = false}) async {
    isLoading.value = true;
    String searchId = id.trim().toLowerCase();
    bool foundCheck = false;

    for (var i = 0; i < data.length; i++) {
      if (searchId == data[i]['assetTagID'].toString().trim().toLowerCase()&& data[i]['assetID']!=null) {
        foundCheck = true;

        await db.updateAssetStatus(data[i]['assetTagID'], 'Found');
        var obj = data.removeAt(i);
        data.insert(0, obj);
        dc.found.removeWhere((asset) => asset['assetTagID'] == obj['assetTagID']);
        dc.found.insert(0, obj);
        break;
      }
    }
    if (!foundCheck && newCheck) {
      dc.newAssets.add(id);
    }
    if (!foundCheck) {
      Get.defaultDialog(
        title: "Oops! Not Found",
        content: Text('Please Try Again'),
      );
    }
    dc.found = dc.found.toSet().toList();
    dc.notfound = data.where((asset) => !dc.found.contains(asset)).toList();
    await saveAuditResultsToPrefs(
      found: dc.found,
      notfound: dc.notfound,
      newAssets: dc.newAssets,
    );
    isLoading.value = false;
  }

  Future<void> loadAuditResultsFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? foundString = prefs.getString('foundAssets');
    String? notFoundString = prefs.getString('notFoundAssets');
    String? newAssetsString = prefs.getString('newAssets');

     dc.found = foundString != null ? jsonDecode(foundString) : [];
     dc.notfound = notFoundString != null ? jsonDecode(notFoundString) : [];
    dc.newAssets = newAssetsString != null ? jsonDecode(newAssetsString) : [];



  }



  notFoundSet() {
    isLoadingNot.value = true;
    dc.notfound = [];
    dc.notfound.addAll(data);
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < dc.found.length; j++) {
        if (dc.found[j]['assetTagID'] == data[i]['assetTagID']) {
          dc.notfound.removeAt(i);
          continue;
        }
      }
    }
    isLoadingNot.value = false;
  }

  scanData2() {
    isLoading.value = true;
    getData();
    bool foundCheck = false;

    getData();
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < dc.found.length; j++) {
        if (dc.found[j]['assetTagID'] == data[i]['assetTagID']) {
          foundCheck = true;
          dynamic obj = data[i];

          data.removeAt(i);
          data.insert(0, obj);
          break;
        }
      }
    }
    isLoading.value = false;
    // getData();
  }

  @override
  void onInit() {
    foundAssets();
    getData();
    loadAuditResultsFromPrefs();

    super.onInit();
  }

  Future<void> viewAsset(scanCheck, {argg}) async {
    var res;
    if (scanCheck) {
      res = await Get.to<String>(() => SimpleBarcodeScannerPage());
    }
    if (!scanCheck) {
      res = argg;
    }
    scanData(res, newCheck: scanCheck);
    scanData2();
    getData();
  }



  getData() async {
    isLoading.value = true;
    List all = await db.getTasks('assets');
    data.value = List.from(all);
    isLoading.value = false;
  }


  void updateArguments(newArg) {
    arg = newArg;
    foundAssets();
  }




}

