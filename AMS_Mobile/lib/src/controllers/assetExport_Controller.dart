import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/helpers/api_helper.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';
import 'package:get/get.dart';

import 'dashboard_controller.dart';

class AssetsExportController extends GetxController {
  final TextEditingController siteController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final DatabaseHelper dbHelper = Get.put(DatabaseHelper());
  final DashboardController dc = Get.find<DashboardController>();

  int? locationId;
  int siteIndex = 1;
  List locationcheck = [];
  List filterLocation = [];
  List finalData = [];
  List status = [];

  @override
  void onInit() async {
    super.onInit();
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      await getLocation();
      await getLocationDescriptions();
    } catch (e) {
      // print('Error loading data: $e');
    }
  }

  Future<void> getLocation() async {
    try {
      List<Map<String, dynamic>> allLocations =
          await dbHelper.getTasks('location');
      if (allLocations.isEmpty) {
        // print('No locations found.');
        return;
      }
      locationcheck = allLocations;
    } catch (e) {
      // print('Error in getLocation: $e');
    }
  }

  Future<void> getLocationDescriptions() async {
    try {
      for (var location in locationcheck) {
        if (location.containsKey("locationDescription")) {
          filterLocation.add(location["locationDescription"]);
        }
      }
    } catch (e) {
      // print('Error in getLocationDescriptions: $e');
    }
  }

  Future<void> fetchExport(
      {required int siteId, required int locationId}) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await makeData(siteId, locationId);
// log('hhhhhhhhhhhhh$finalData');
      setStatus();

      if (finalData.isEmpty) {
        Get.back();
        throw Exception("No assets found for the selected site and location.");
      }

      if (status.isEmpty) {
        Get.back();
        throw Exception("No statuses available for export.");
      }

      DateTime date = DateTime.now();
      var formattedDate = date.toUtc().toIso8601String();

      final exportData = await apiFetcher(
        'Post',
        '/api/ReportsDetailPage/ExecuteAuditSP',
        {
          "assets": finalData,
          "assetStatuses": status,
          "createdBy": 2,
          "assignedTo": 2,
          "locationId": locationId,
          "categoryID": finalData.first['categoryID'],
          "siteId": siteId,
          "statusId": 1,
          "createdDateTime": formattedDate,
        },
      );

      Get.back();

      if (exportData.statusCode == 200) {
        final body = jsonDecode(exportData.body);
        Get.dialog(AlertDialog(
          title: const Text("Success"),
          content: Text(
              "Assets exported successfully!\nYour audit ID is ${body['auditMId']}"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ));
      } else {
        throw Exception("Failed to export assets");
      }
    }
    catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Please Check Your Connection",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // log("Actual error: $e");
    }

  }

  Future<void> makeData(int siteId, int locationId) async {
    finalData = [];

    List<Map<String, dynamic>> assets = await dbHelper.getTasks('assets');
    // print('site: $siteId and locationId: $locationId');
    // log('Raw Assets Data from DB: $assets');

    List<String> newAssets = [];

    for (var asset in assets) {
      if (int.parse(asset['siteID'] ?? '0') == siteId &&
          int.parse(asset['locationID'] ?? '0') == locationId)

      {

        var obj = {
          "assetTagId": asset['assetTagID'] ?? "TAGNULL",
          "assetDescription": asset['assetDescription'] ?? "TAGNULL",
          "cost": int.parse(asset['cost'] ?? "0"),
          "isDepreciation": false,
          "categoryID": num.parse(asset['categoryID'] ?? "1"),
          // "categoryID": int.tryParse(asset['categoryID'] ?? "1") ?? 1,

          "isActive": true,
          "createdBy": "2",
          "aseetBarcode": "1001",
          "purchaseDate": "2024-11-19T11:03:02.793Z",
          "siteId": siteId,
          "locationId": locationId,
        };
        // print("aaaaaaaaaaaaaa${asset['assetTagID']}");
        // print("aaaaaaaaaaaaaa${asset['categoryID']}");

        finalData.add(obj);
        newAssets.add(asset['assetTagID'] ?? "TAGNULL");
      }
    }
    // log('filtered data $finalData');
    // print('Saved Tags: $newAssets');
  }

  void setStatus() {
    status = [];
    final Map<String, int> statusMap = {};

    void addStatusWithPriority(String assetTagId, int newAssets) {
      if (finalData.any((data) => data['assetTagId'] == assetTagId) &&
          !statusMap.containsKey(assetTagId)) {
        statusMap[assetTagId] = newAssets;
      }
    }

    for (var asset in dc.found) {
      addStatusWithPriority(asset['assetTagID'], 6);
    }
    for (var asset in dc.cheackOut) {
      addStatusWithPriority(asset['assetTagID'], 2);
    }
    for (var asset in dc.cheackin) {
      addStatusWithPriority(asset['assetTagID'], 3);
    }
    for (var asset in dc.lost) {
      addStatusWithPriority(asset['assetTagID'], 4);
    }
    for (var asset in dc.dispos) {
      addStatusWithPriority(asset['assetTagID'], 8);
    }

    for (var assetTagId in dc.newAssets) {
      if (finalData.any((data) => data['assetTagId'] == assetTagId)) {
        addStatusWithPriority(assetTagId, 5);
      }
    }

    for (var asset in dc.notfound) {
      addStatusWithPriority(asset['assetTagID'], 7);
    }

    status = statusMap.entries
        .map((entry) => {"assetTagId": entry.key, "statusId": entry.value})
        .toList();

    // log('Final Status: $status');
  }
}
