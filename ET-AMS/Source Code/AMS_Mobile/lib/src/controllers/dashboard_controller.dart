import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/services/connectivityService.dart';
import 'package:flutter_application_1/src/ui/view/Dashbord/dashboard.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  ConnectivityService cs = Get.find<ConnectivityService>();
  DatabaseHelper db = Get.put(DatabaseHelper());
  RxBool assetsCheck = false.obs;
  RxBool connectivityCheck = false.obs;
  late SharedPreferences prefs;

  var found = [];
  var notfound = [];
  var newAssets = [];
  var cheackOut = [];
  var lost = [];
  var dispos = [];
  var cheackin = [];
  // var selectDetails = [];
  RxList<Map<String, dynamic>> selectDetails = <Map<String, dynamic>>[].obs;
  RxList assets = [].obs;
  RxList location = [].obs;
  RxList<dynamic> anotherLocation = <dynamic>[].obs;

  RxBool isLoading = true.obs;
  late List<ChartData> data;


  int get uniqueSiteCount {
    Set<int> uniqueSiteIds = selectDetails.map((e) => e['siteID'] as int).toSet();
    return uniqueSiteIds.length;
  }

  @override
  void onInit()  {
    loadAuditResultsFromPrefs();
    loadSelectDetailsFromPrefs();
    super.onInit();
    sh();
    loadSelectDetails();
    ever(selectDetails, (_) => saveSelectDetails());
    updateChartData();
    getData();
    // print('selectDetails: ${selectDetails}');
    print(found);
  }


  sh() async {
    prefs = await SharedPreferences.getInstance();
    log(prefs.get('found').toString());
  }
  Future<void> loadSelectDetailsFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('selectDetails');

    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      selectDetails.value = List<Map<String, dynamic>>.from(decoded);
      print("Data loaded from SharedPreferences.");
    } else {
      print("No data found in SharedPreferences.");
    }
  }

  Future<void> saveCheckOutAssets(List<dynamic> cheackOut) async {
    print('Saving ${cheackOut.length} checked-out assets'); // 👈 Add this line
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkedOutAssets', jsonEncode(cheackOut));
  }



  Future<void> saveLostAssets(List<dynamic> lost) async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lostAssets', jsonEncode(lost));
    print('Saved lostAssets: ${jsonEncode(lost)}');

  }

  Future<void> saveDisposedAssets(List<dynamic> dispos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('disposedAssets', jsonEncode(dispos));
  }

  Future<void> saveCheckInAssets(List<dynamic> cheackin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkedInAssets', jsonEncode(cheackin));
  }

  void updateChartData() {

    data = [
      ChartData('Found', found.isNotEmpty ? found.length.toDouble() : 1,
          Colors.green, found.isEmpty),
      ChartData(
          'New Assets',
          newAssets.isNotEmpty ? newAssets.length.toDouble() : 1,
          Colors.purple, newAssets.isEmpty),
      ChartData(
          'Checked Out', 
          cheackOut.isNotEmpty ? cheackOut.length.toDouble() : 1,
          Colors.yellow, cheackOut.isEmpty),
      ChartData(
          'Lost', lost.isNotEmpty ? lost.length.toDouble() : 1, Colors.red,lost.isEmpty),
      ChartData('Disposals', dispos.isNotEmpty ? dispos.length.toDouble() : 1,
          Colors.grey,dispos.isEmpty),
      ChartData('Checked In',
          cheackin.isNotEmpty ? cheackin.length.toDouble() : 1, Colors.blue,cheackin.isEmpty),
      // ChartData('Checked In', notfound.length.toDouble()),
    ];

    // print("hgfdgh${data.first.y}");
  }


  Future<void> loadAuditResultsFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? foundString = prefs.getString('foundAssets');
    String? notFoundString = prefs.getString('notFoundAssets');
    String? newAssetsString = prefs.getString('newAssets');
    String? checkedOutAssets = prefs.getString('checkedOutAssets');
    String? checkedInAssets = prefs.getString('checkedInAssets');
    String? disposedAssets = prefs.getString('disposedAssets');
    String? lostAssets = prefs.getString('lostAssets');

    found = foundString != null ? _decodeJson(foundString) : [];
    notfound = notFoundString != null ? _decodeJson(notFoundString) : [];
    newAssets = newAssetsString != null ? _decodeJson(newAssetsString) : [];
    cheackOut = checkedOutAssets != null ? _decodeJson(checkedOutAssets) : [];
    cheackin = checkedInAssets != null ? _decodeJson(checkedInAssets) : [];
    dispos = disposedAssets != null ? _decodeJson(disposedAssets) : [];
    lost = lostAssets != null ? _decodeJson(lostAssets) : [];

    print("Found Assets: $found");
    print("Not Found Assets: $notfound");
    print("New Assets: $newAssets");
    print("cheackOut: $cheackOut");
    print("cheackin: $cheackin");
    print("dispos: $dispos");
    print("lost: $lost");

    updateChartData();
  }

  List<dynamic> _decodeJson(String jsonString) {
    var decoded = jsonDecode(jsonString);
    if (decoded is List) {
      return decoded;
    } else if (decoded is Map) {
      return [decoded];
    }
    return [];
  }


  getData() async {
    isLoading.value = true;
    assets.value = await db.getTasks('assets');
    List<dynamic> fetchedLocation = await db.getTasks('location');
    location.value = fetchedLocation.take(3).toList();
    anotherLocation.value = fetchedLocation.take(6).toList();
    isLoading.value = false;
  }

  void saveSelectDetails() async {
    prefs = await SharedPreferences.getInstance();
    String selectDetailsJson = jsonEncode(selectDetails);
    await prefs.setString('selectDetails', selectDetailsJson);
    log('SelectDetails Saved: $selectDetailsJson');
  }

  void loadSelectDetails() async {
    log('loadSelectDetails called!');

    prefs = await SharedPreferences.getInstance();
    String? selectDetailsJson = prefs.getString('selectDetails');

    if (selectDetailsJson != null) {
      selectDetails = jsonDecode(selectDetailsJson);
      log('SelectDetails Loaded: $selectDetails');
    } else {
      log('No SelectDetails found in SharedPreferences');
    }
  }

  void clearPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    log('SharedPreferences Cleared!');
  }
  void addNewDetail(Map<String, dynamic> newDetail) {
    selectDetails.add(newDetail);
    saveSelectDetails();
  }





}


