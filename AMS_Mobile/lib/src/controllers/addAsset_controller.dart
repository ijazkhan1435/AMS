

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/foundAssetsController.dart';
import 'package:flutter_application_1/src/models/task_model.dart';
import 'package:flutter_application_1/src/utils/helpers/db_helper.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import 'dashboard_controller.dart';

class AddAssetsController extends GetxController {
  DatabaseHelper db = Get.put(DatabaseHelper());

  var arg = Get.arguments;
  final TextEditingController assetTagIdController = TextEditingController();
  final TextEditingController purchasedDateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController createdDateController = TextEditingController();
  final TextEditingController siteController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController depreciationController = TextEditingController();
  final TextEditingController totalCostController = TextEditingController();
  final TextEditingController assetsLifeController = TextEditingController();
  final TextEditingController salvageController = TextEditingController();
  final TextEditingController dateAcquiredController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxString result = ''.obs;
  int? locationId;
  int? index;
  int siteIndex = 1;
  List locationcheck = [];
  List categorychk = [];
  List filterLocation = [];
  dynamic location = [].obs;
  dynamic site = [].obs;
  dynamic category = [].obs;
  RxList<String> getlocation = <String>[].obs;
  RxList<String> getlocationdescription = <String>[].obs;
  RxList<String> getsite = <String>[].obs;
  RxList categoryList =[].obs;
  RxBool isLoading = true.obs;
  var categoryMap = <int, String>{};
  int? selectedCategoryID;

  @override
  void onInit() {
    super.onInit();
    assetTagIdController.text = arg ?? '';

    DashboardController dashboardController = Get.find<DashboardController>();

    if (dashboardController.selectDetails.isNotEmpty) {
      var firstSite = dashboardController.selectDetails.first;
      siteController.text = firstSite['siteDescription'];
      siteIndex = firstSite['siteID'];

      filterLocation = dashboardController.selectDetails
          .where((e) => e['siteID'] == siteIndex)
          .toList();

      if (filterLocation.isNotEmpty) {
        locationController.text = filterLocation.first['locationDescription'];
        locationId = filterLocation.first['locationID'];
      }
    }

    getLocation();
    getSite();
    getLocationDescription();
    getCategories();
  }


  Future<void> viewAsset() async {
    var res = await Get.to<String>(() => SimpleBarcodeScannerPage());
    if (res != null) {
      assetTagIdController.text = res;
    }
  }

  bool validateInputs() {
    if (assetTagIdController.text.isEmpty) {
      Get.snackbar('Error', 'Asset Tag ID is required.');
      return false;
    }
    if (siteController.text.isEmpty) {
      Get.snackbar('Error', 'Site is required.');
      return false;
    }
    if (locationController.text.isEmpty) {
      Get.snackbar('Error', 'Location is required.');
      return false;
    }
    if (categoryController.text.isEmpty) {
      Get.snackbar('Error', 'Category is required.');
      return false;
    }
    if (descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Description is required.');
      return false;
    }
    if (costController.text.isEmpty) {
      Get.snackbar('Error', 'Cost is required.');
      return false;
    }
    if (createdDateController.text.isEmpty) {
      Get.snackbar('Error', 'Created Date is required.');
      return false;
    }
    if (depreciationController.text.isEmpty) {
      Get.snackbar('Error', 'Depreciation is required.');
      return false;
    }
    return true;
  }


  save() async {
    if (!formKey.currentState!.validate()) return;

    final newAsset = Task(
      siteID: siteIndex.toString(),
      locationID: locationId.toString(),
      categoryID: selectedCategoryID?.toString() ?? 'NA',
      assetTagID: assetTagIdController.text,
      assetsStatus: 'New Assets',
      purchasedDate: purchasedDateController.text.isEmpty ? 'NA' : purchasedDateController.text,
      categoryDescription: categoryController.text.isEmpty ? 'NA' : categoryController.text,
      assetDescription: descriptionController.text.isEmpty ? 'NA' : descriptionController.text,
      cost: costController.text.isEmpty ? 'NA' : costController.text,
      createdDate: createdDateController.text.isEmpty ? 'NA' : createdDateController.text,
      siteDescription: siteController.text.isEmpty ? 'NA' : siteController.text,
      locationDescription: locationController.text.isEmpty ? 'NA' : locationController.text,
      depreciation: selectedRadio.value == 'Option2' ? 'No' : 'Yes',
      depreciationMethod: depreciationController.text.isEmpty ? 'NA' : depreciationController.text,
      image: pickedFile?.path ?? 'na',
    );

    await db.insertTask(newAsset);

    final dashboardController = Get.find<DashboardController>();
    dashboardController.newAssets.add(newAsset);


    Get.put(FoundAssetsController()).getData();
    dashboardController.getData();

    Get.back(result: {
      'siteID': siteIndex,
      'locationID': locationId,
    });
  }

  var imageFile = Rx<File?>(null);
  var selectedRadio = 'Option2'.obs;
  var showTextField = true.obs;
  var pickedFile;

  void pickImage(ImageSource source) async {
    pickedFile = await ImagePicker().pickImage(source: source);
    imageFile.value = pickedFile != null ? File(pickedFile.path) : null;
  }

  void deleteImage() {
    imageFile.value = null;
  }

  void setSelectedRadio(String value) {
    selectedRadio.value = value;
    if (value == 'Option1') {
      showTextField.value = true;
    } else {
      showTextField.value = false;
    }
  }

  getLocationDescription() async {
    List all = await db.getTasks('location');
    location.value = List.from(all);
    locationcheck = all;
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


  getCategories() async {
    isLoading.value = true;
    try {
      List all = await db.getTasks('category');

      if (all == null || all.isEmpty) {
        isLoading.value = false;
        return;
      }

      category.value = List.from(all);
      categorychk = all;
      categoryList.clear();
      categoryMap.clear();
categoryList.value=all;
      for (var item in all) {
        var categoryID = item["categoryID"];
        var categoryDescription = item["categoryDescription"];
        if (categoryDescription != null && categoryID != null) {
          categoryList.add(item);
          categoryMap[categoryID] = categoryDescription;
        } else {
        }
      }

    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    assetTagIdController.dispose();
    purchasedDateController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    costController.dispose();
    createdDateController.dispose();
    siteController.dispose();
    locationController.dispose();
    depreciationController.dispose();
    totalCostController.dispose();
    assetsLifeController.dispose();
    salvageController.dispose();
    dateAcquiredController.dispose();
    super.onClose();
  }
}


