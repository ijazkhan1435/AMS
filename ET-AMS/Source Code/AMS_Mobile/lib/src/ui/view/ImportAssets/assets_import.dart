import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/controllers/assetsImport_controller.dart';
import 'package:flutter_application_1/src/controllers/import_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/commonBtn.dart';
import 'package:flutter_application_1/src/ui/widgets/modelbottomSheet.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';

class AssetsImport extends StatelessWidget {
  final AssetsImportController controller = Get.put(AssetsImportController());
  final ImportController _ = Get.put(ImportController());

  RxInt selectedLocationID=0.obs;
  var NewData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [

                  TextFormFildWidgets(
                    read: true,
                    title: 'Site',
                    iconButton: IconButton(
                      onPressed: () {
                        // print(controller.site);
                        appBottomSheet(controller.site, (index) {
                          Get.back();
                          controller.siteController.text =controller.site[index]['siteDescription'];
                          controller.siteIndex = controller.site[index]['siteID'];
                          // controller.saveSelectedDetails(
                          //   'site',
                          //   controller.siteIndex,
                          //   site[index],
                          // );
                          // controller.saveSelectedDetails();
                          print("Selected Site: ${controller.siteController.text}");
                          print("Selected Site ID: ${controller.siteIndex}");
                        },'siteDescription');
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                    txtcontroller: controller.siteController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormFildWidgets(
                    title: 'Location',
                    read: true,
                    iconButton: IconButton(
                      onPressed: () {
                        controller.filterLocation = [];
                        for (var i = 0; i < controller.locationcheck.length; i++) {
                          if (controller.locationcheck[i]['siteID'] == controller.siteIndex) {
                            controller.filterLocation.add(controller.locationcheck[i]);
                          }
                        }
                        print('Filtered Locations: ${controller.filterLocation}');
                        print('object');
                        appBottomSheet(controller.filterLocation, (index) {
                          Get.back();
                          controller.locationController.text = controller.filterLocation[index]['locationDescription'];
                          controller.locationId = controller.filterLocation[index]['locationID'];
                          // controller.saveSelectedDetails();
                          print("Selected Location: ${controller.locationController.text}");
                          print("Selected Location ID: ${controller.locationId}");
                        }, 'locationDescription');
                      },
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                    txtcontroller: controller.locationController,
                  ),

                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: Get.width,
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  print("Site Index: ${controller.siteIndex}");
                  print("Location ID: ${controller.locationId}");
                   controller.saveSelectedDetails();

                  Timer(Duration(seconds: 0), () {
                    // _.deleteAndRecreateTable('assets');
                    _.fetchData(controller.siteIndex, controller.locationId);
                    controller.get();
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: UIDataColors.commonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'Import Assets',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

            ),
          ),
        ],
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
            'IMPORT ASSETS',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Colors.black),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
