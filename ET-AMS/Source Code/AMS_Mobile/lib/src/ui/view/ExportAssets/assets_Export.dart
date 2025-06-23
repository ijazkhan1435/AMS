import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/assetExport_Controller.dart';
import 'package:flutter_application_1/src/controllers/dashboard_controller.dart';
import 'package:flutter_application_1/src/controllers/import_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/modelbottomSheet.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AssetsExport extends StatelessWidget {
  final AssetsExportController controller = Get.put(AssetsExportController());
  final ImportController importController = Get.put(ImportController());
  final DashboardController dashboardController =
  Get.find<DashboardController>();

  final RxList<String> site = <String>['ET Lahore', 'ET Karachi', 'ET Riyadh'].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                TextFormFildWidgets(
                  read: true,
                  title: 'Site',
                  iconButton: IconButton(
                    onPressed: () {
                      print(dashboardController.selectDetails);

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

                          controller.filterLocation = dashboardController.selectDetails
                              .where((e) => e['siteID'] == selectedSiteId)
                              .toList();

                          controller.locationController.clear();
                          controller.locationId = null;

                          print('Selected Site: $selectedSite');
                          print('Site ID: $selectedSiteId');
                          print('Filtered Locations: ${controller.filterLocation}');

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
                            controller.filterLocation[index]['locationDescription'];
                            int? selectedLocationId =
                            dashboardController.selectDetails
                                .firstWhere((e) =>
                            e['locationDescription'] ==
                                selectedLocation)['locationID'];
                            controller.locationController.text =
                                selectedLocation;
                            controller.locationId = selectedLocationId;
                            print(
                                'Selected Location: $selectedLocation');
                            print('Location ID: $selectedLocationId');
                            controller.update();
                          },'locationDescription');
                    },
                    icon: const Icon(
                        Icons.keyboard_arrow_down_outlined),
                  ),
                  txtcontroller: controller.locationController,
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: Get.width,
              child: TextButton(
                onPressed: () async {
                  if (controller.siteIndex == null || controller.locationId == null) {
                    Get.snackbar(
                      "Error",
                      "Please select both site and location.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  await controller.fetchExport(
                    siteId: controller.siteIndex!,
                    locationId: controller.locationId!,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: UIDataColors.commonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  'Export Assets',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )


        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Export Assets',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 3,
    );
  }

  void _showLoader() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }
}
