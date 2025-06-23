import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_application_1/src/utils/helpers/api_helper.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';
import 'package:get/get.dart';

import 'dashboard_controller.dart';

class ImportController extends GetxController {
  final DatabaseHelper dbHelper = Get.find<DatabaseHelper>();
  final DashboardController dc = Get.find<DashboardController>();

  DatabaseHelper db = DatabaseHelper();
  var selectedRadio = 'Option1'.obs;
  List finalData = [];
  List status = [];
  RxBool exportCheck = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> deleteAndRecreateTable(String table) async {
    await db.deleteTable(table);
    await db.createTable(table);
  }


  Future<void> fetchData(a, b) async {
    RxInt insertedCount = 0.obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Assets Import',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Obx(() => Column(
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(height: 10),
                Text(
                  "Loading ${insertedCount.value} assets...",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            )),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {
      String url = '/api/Location/ImportAssetsbySiteAndLocation?siteId=$a&locationId=$b';

      dynamic assetsRes = await apiFetcher('Get', url);

      if (assetsRes != null && assetsRes.isNotEmpty) {
        for (var i = 0; i < assetsRes.length; i++) {
          Map<String, dynamic> assetData = {
            'assetTagId': assetsRes[i]['assetTagId'],
            'assetId': assetsRes[i]['assetId'],
            'assetsStatus': assetsRes[i]['assetsStatus'],
            'locationID': assetsRes[i]['locationID'],
            'locationDescription': assetsRes[i]['locationDescription'],
            'siteID': assetsRes[i]['siteID'],
            'assetDescription': assetsRes[i]['assetDescription'],
            'cost': assetsRes[i]['cost'],
            'image': assetsRes[i]['image'],
            'createdDate': assetsRes[i]['createdDateTime'],
            'isActive': assetsRes[i]['isActive'],
            'categoryDescription': assetsRes[i]['categoryDescription'],
            'categoryID': assetsRes[i]['categoryId'],
            'employeeID': assetsRes[i]['employeeID'],
            'siteDescription': assetsRes[i]['siteDescription'],
          };

          await dbHelper.insertAssets(assetData);

          insertedCount.value = i + 1;
        }

        DashboardController dashboardController = Get.find<DashboardController>();
        await dashboardController.getData();
      } else {
        Get.snackbar(
          "Error",
          "No assets found or failed to fetch data.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Network Error Please Check your Connection",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      Get.back();
    }
  }



  Future<void> fetchLocationData() async {
    try {
      dynamic locationRes = await apiFetcher(
        'Get',
        '/api/Location/ImportAllLocations',
      );
      if (locationRes != null) {
        for (var i = 0; i < locationRes.length; i++) {
          Map<String, dynamic> locationData = {
            'locationID': locationRes[i]['locationID'],
            'locationDescription': locationRes[i]['locationDescription'],
            'siteID': locationRes[i]['siteID'],
            'siteDescription': locationRes[i]['siteDescription'],
          };
          await dbHelper.insertLocation(locationData);
        }
        Get.snackbar(
          'Success',
          'Locations fetched and saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network Error Please Check your Connection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchSiteData() async {

    try {
      dynamic siteRes =await apiFetcher('Get', '/api/Location/GetSites');
      if (siteRes != null) {
        for (var site in siteRes) {
          Map<String, dynamic> siteData = {
            'siteID': site['siteId'],
            'siteDescription': site['description'],
          };
          await dbHelper.insertSite(siteData);
        }
        Get.snackbar(
          'Success',
          'Site fetched and saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network Error Please Check your Connection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchCategoryData() async {
    try {
      dynamic categoryRes = await apiFetcher('Get', '/api/Location/GetCategories');
      if (categoryRes != null) {
        for (var category in categoryRes) {
          Map<String, dynamic> categoryData = {
            'categoryID': category['categoryId'],
            'categoryDescription': category['description'],
          };
          await dbHelper.insertCategory(categoryData);
        }
        Get.snackbar(
          'Success',
          'Categories fetched and saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network Error Please Check your Connection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

