
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/helpers/api_helper.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_controller.dart';
class AssetsImportController extends GetxController {
  final TextEditingController siteController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final DashboardController dashboardController = Get.find<DashboardController>();
  final DatabaseHelper dbHelper = Get.find<DatabaseHelper>();
  DatabaseHelper db = Get.put(DatabaseHelper());

  int? locationId;
  int? index;
  int siteIndex=1;
  int? locationIndex;
  List locationcheck=[];
  List filterLocation=[];
  // var siteData = RxMap<String, dynamic>({});
  // var importSiteData = RxMap<String, dynamic>({});
  // RxList<Map<String, dynamic>> resultData = <Map<String, dynamic>>[].obs;

  var selectDetails = [];
  dynamic Location = [];
  RxList site = [].obs;
  dynamic location = [].obs;


  RxList<String> getlocation = <String>[].obs;
  RxList<String> getlocationdescription = <String>[].obs;
  // RxList<String> getsite = <String>[].obs;
  // RxList<ItemModel> getsite = <ItemModel>[].obs;
  RxBool isLoading = true.obs;
  bool scanCheck = false;

  var selectedRadio = 'Option2'.obs;
  final RxBool showTextField = true.obs;
  final RxString result = ''.obs;
  var selectedSites={};
  var selectedLocation={};
  void setSelectedRadio(String value) {
    selectedRadio.value = value;
  }

  @override
  void onInit() async {
    // checkAssetInDatabase();
    getLocation();
    getLocationDescription();
    getSite();
    // getSiteOnline();

    super.onInit();
  }

  @override
  void onClose() {
    siteController.dispose();
    locationController.dispose();
    super.onClose();
  }
  // getSiteOnline()async{
  //   var res =await apiFetcher('Get', '/api/SiteLocation/GetOnlySites');
  //   site.value=res;
  //   // log('message$res');
  //   // print(site);
  //   // site(res);
  // }
  getLocation() async {
    List all = await db.getTasks('location');
    location.value = List.from(all);
    isLoading.value = false;
  }

  // getLocationDescription() async {
  //   List all = await db.getTasks('location');
  //   // print('aaaaaaaaaa${all}');
  //   location.value = List.from(all);
  //   locationcheck=all;
  //   for (var i = 0; i < location.length; i++) {
  //     getlocationdescription.add(location[i]["locationDescription"]);
  //     // print(location[i]["locationDescription"]);
  //   }
  //   isLoading.value = false;
  // }
  getLocationDescription() async {
    List all = await db.getTasks('location');
    locationcheck = all;
    for (var i = 0; i < all.length; i++) {
      getlocationdescription.add(all[i]["locationDescription"]);
    }
    isLoading.value = false;
  }


  getSite() async {
    log("===== calling getSite");
    List all = await db.getTasks('site');
    site.value = List.from(all);

    // for (var i = 0; i < site.length; i++) {
    //   getsite.add(ItemModel ( id: site[i]['siteID'], desc: site[i]["siteDescription"]));
    //   // print(location[i]["siteDescription"]);
    // }
    isLoading.value = false;
  }

  get() async {
    for(var i =0; i<location.length;i++){
      // print(location[i]);
      if(location[i]["siteID"]==siteIndex&&location[i]["locationID"]==locationId){
        dashboardController.selectDetails.add(
            location[i]
        );
      }
    }

    await saveSelectDetailsToPrefs(dashboardController.selectDetails);

    print('object');
    print('selectDetails$selectDetails');
    // print(dashboardController.selectDetails);
  }
// save list to local db

  // Future<void> saveSelectDetailsToPrefs(RxList<Map<String, dynamic>> selectDetails) async {
  //   if (selectDetails.isNotEmpty) {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     // Load existing data (if any)
  //     String? existingData = prefs.getString('selectDetails');
  //     List<Map<String, dynamic>> allDetails = [];
  //
  //     if (existingData != null) {
  //       List<dynamic> decoded = jsonDecode(existingData);
  //       allDetails = List<Map<String, dynamic>>.from(decoded);
  //     }
  //
  //     // Merge: Add new items to existing list
  //     allDetails.addAll(selectDetails);
  //
  //     // Optional: Remove duplicates (if needed)
  //     // Use Set or custom logic here if necessary
  //
  //     // Save updated list back to SharedPreferences
  //     await prefs.setString('selectDetails', jsonEncode(allDetails));
  //     print("Data saved to SharedPreferences.");
  //   } else {
  //     print("selectDetails is empty. Nothing saved.");
  //   }
  // }

  Future<void> saveSelectDetailsToPrefs(RxList<Map<String, dynamic>> selectDetails) async {
    if (selectDetails.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? existingData = prefs.getString('selectDetails');
      List<Map<String, dynamic>> allDetails = [];

      if (existingData != null) {
        List<dynamic> decoded = jsonDecode(existingData);
        allDetails = List<Map<String, dynamic>>.from(decoded);
      }

      for (var detail in selectDetails) {
        if (!allDetails.any((d) =>
        d['siteID'] == detail['siteID'] &&
            d['locationID'] == detail['locationID'])) {
          allDetails.add(detail);
        }
      }

      // Save updated list back
      await prefs.setString('selectDetails', jsonEncode(allDetails));
      print(" Data saved to SharedPreferences without duplicates.");
    } else {
      print(" selectDetails is empty. Nothing saved.");
    }
  }
  Future<void> clearSelectDetailsFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('selectDetails');
    print(" SharedPreferences cleared.");
  }



  void saveSelectedSiteLocation(String selectedSite, String selectedLocation) {
    bool exists = dashboardController.selectDetails.any((item) =>
    item['site'] == selectedSite && item['location'] == selectedLocation);
    if (!exists) {
      dashboardController.selectDetails.add({
        'site': selectedSite,
        'location': selectedLocation
      });
      update();
    }
  }

  void saveSelectedDetails() async {
    if (siteIndex != null && locationId != null) {
      Map<String, dynamic> selectDetailsData = {
        'siteID': siteIndex,
        'siteDescription': siteController.text,
        'locationID': locationId,
        'locationDescription': locationController.text,
      };

      await db.insertSelectDetails(selectDetailsData);
      print(" Site aur Location database mein save ho gayi.");
      // Database se saved data fetch karna
      List<Map<String, dynamic>> savedData = await db.getTasks('selectDetails');
      print("Saved Data: $savedData");
    } else {
      print("Pehle Site aur Location select karein.");
    }
  }


}