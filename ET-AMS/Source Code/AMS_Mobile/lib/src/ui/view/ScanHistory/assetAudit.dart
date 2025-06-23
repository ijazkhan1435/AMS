import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/assetsImport_controller.dart';
import 'package:flutter_application_1/src/controllers/scan_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/modelbottomSheet.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:info_popup/info_popup.dart';

import '../../../controllers/dashboard_controller.dart';

class ScanScreen extends StatelessWidget {
  final ScanController controller = Get.put(ScanController());
  final AssetsImportController assetsImportController =
      Get.put(AssetsImportController());
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  // RxList<String> site = <String>['ET Lahore', 'ET Karachi', 'ET Riyadh'].obs;
  // TooltipController tooltipController = Get.put(TooltipController());
  // fetchAuditDetails _=Get.put(fetchAuditDetails());
  static RxString selectedValue = 'selectedValue'.obs;
  static RxString selectedValue2 = 'selectedValue2'.obs;
  static RxString selectedValue3 = 'selectedValue3'.obs;
  RxString selectedRadio = ''.obs;
  void setSelectedRadio(String value) {}

  // get title => null;

  @override
  Widget build(BuildContext context) {
    // controller.fetchAuditDetails();
    // Future.delayed(Duration.zero, () {
    //   tooltipController.showTooltip(
    //       'This screen is used to scan assets using RFID reader or barcode scanner.');
    // });
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          Get.toNamed(Routes.dashboard);
          Get.find<DashboardController>().getData();
          // print('object');
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: appbar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Choose Audit Option',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: RadioListTile(
                                title: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/logos/rfid_reader.png',
                                      width: 25,
                                      height: 30,
                                      // color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Audit with RFID Reader',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.info),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                // title: Text("data"),
                                                backgroundColor: Colors.white,
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/logos/cypherlab.jpg',
                                                      width: 300,
                                                      height: 200,
                                                      // color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text('Integrated only with CipherLab RS35-UHF',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Close"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    // InfoPopupWidget(
                                    //   contentTitle: 'Integrated only with CipherLab RS36-UHF',
                                    //   child: Icon(
                                    //     Icons.info,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                value: 'Option1',
                                groupValue: controller.selectedRadio.value,
                                onChanged: (value) {
                                  controller.setSelectedRadio(value as String);
                                  controller.scanCheck = true;
                                  print(
                                      'Selected Radio Value: ${controller.scanCheck}');
                                },
                              ),
                            ),
                          ],
                        ),
                        Center(
                            child: Text(
                          '${controller.deviceStatus}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: controller.deviceStatus == 'Connected'
                                  ? Colors.green
                                  : Colors.grey),
                        )),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Flexible(
                          child: RadioListTile(
                            title: Row(
                              children: [
                                Image.asset(
                                  'assets/images/logos/barcode.png',
                                  width: 25,
                                  height: 70,
                                  // color: Colors.black,
                                ),
                                SizedBox(width: 9),
                                Text(
                                  'Audit with QR Code/Barcode ',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            value: 'Option2',
                            groupValue: controller.selectedRadio.value,
                            onChanged: (value) {
                              controller.setSelectedRadio(value as String);
                              controller.scanCheck = false;
                              controller.update();
                              // print(
                              //     'Selected Radio Value: ${controller.scanCheck}');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Choose Site and Location to start audit',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            SizedBox(height: 10),
                            TextFormFildWidgets(
                              read: true,
                              title: 'Site',
                              iconButton: IconButton(
                                onPressed: () {
                                  // print(dashboardController.selectDetails);

                                  Set<String> seenSites = {};
                                  List<Map<String, dynamic>> uniqueSites = [];

                                  for (var site in dashboardController.selectDetails) {
                                    String siteDescription = site['siteDescription'].toString().trim();
                                    int siteID = site['siteID'];

                                    if (!seenSites.contains(siteDescription)) {
                                      seenSites.add(siteDescription);
                                      uniqueSites.add({'siteID': siteID, 'siteDescription': siteDescription});
                                    }
                                  }

                                  appBottomSheet(
                                    uniqueSites,
                                        (index) {
                                      Get.back();

                                      var selectedSiteData = uniqueSites[index];
                                      String selectedSite = selectedSiteData['siteDescription'];
                                      int? selectedSiteId = selectedSiteData['siteID'];

                                      controller.siteController.text = selectedSite;
                                      controller.siteIndex = selectedSiteId ?? -1;

                                      // Filter locations based on selected siteID
                                      controller.filterLocation = dashboardController.selectDetails
                                          .where((e) => e['siteID'] == selectedSiteId)
                                          .toList();

                                      // Clear location fields
                                      controller.locationController.clear();
                                      controller.locationId = null;

                                      // print('Selected Site: $selectedSite');
                                      // print('Site ID: $selectedSiteId');
                                      // print('Filtered Locations: ${controller.filterLocation}');

                                      controller.update();
                                    },
                                    'siteDescription',
                                  );
                                },
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                              ),
                              txtcontroller: controller.siteController,
                            ),





                            SizedBox(height: 20),
                            TextFormFildWidgets(
                              read: true,
                              title: 'Location',
                              iconButton: IconButton(
                                onPressed: () {
                                  if (controller.siteIndex == null) {
                                    Get.snackbar(
                                      'Validation Error',
                                      'Please select a site first.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }
                                  appBottomSheet(controller.filterLocation,
                                      (index) {
                                    Get.back();
                                    String selectedLocation =
                                        controller.filterLocation[index]
                                            ['locationDescription'];
                                    int? selectedLocationId =
                                        dashboardController.selectDetails
                                            .firstWhere((e) =>
                                                e['locationDescription'] ==
                                                selectedLocation)['locationID'];
                                    controller.locationController.text =
                                        selectedLocation;
                                    controller.locationId = selectedLocationId;
                                    // print(
                                    //     'Selected Location: $selectedLocation');
                                    // print('Location ID: $selectedLocationId');
                                    controller.update();
                                  }, 'locationDescription');
                                },
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_outlined),
                              ),
                              txtcontroller: controller.locationController,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.height / 8),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          if (controller.siteController.text.isEmpty ||
                              controller.locationController.text.isEmpty) {
                            Get.snackbar(
                              'Validation Error',
                              'Please select both site and location before starting the audit.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            controller.startScan(
                                controller.siteIndex, controller.locationId!);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'Start Audit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 3.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: AppBar(
          title: Text(
            "ASSET AUDIT",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
      ),
    );
  }
}
