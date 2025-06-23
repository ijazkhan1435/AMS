import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/assetsImport_controller.dart';
import 'package:flutter_application_1/src/controllers/import_controller.dart';
import 'package:flutter_application_1/src/controllers/tolltip_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/commonBtn.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../../controllers/assetsImport_controller.dart';
import '../../../controllers/dashboard_controller.dart';

class Import extends StatelessWidget {
  final ImportController controller = Get.put(ImportController());
  // final AssetsImportController _controller=Get.find<AssetsImportController>();
  TooltipController tooltipController = Get.put(TooltipController());

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () {
    //   tooltipController
    //       .showTooltip('Using this screen we can import/export data to audit.');
    // });
    RxBool isloading = false.obs;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Import/Export',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(84, 75, 21, 140),
              ),
            ).marginSymmetric(vertical: 80),
            Obx(
              () => isloading.value
                  ? CircularProgressIndicator(color: Colors.blue,).marginOnly(bottom: 20,)
                  : CommonBtn(
                      title: 'Import Data',
                      onPressd: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.blue.shade100,
                              title: Center(
                                  child: Text(
                                'Select Import Option',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      isloading.value = true;
                                      await controller
                                          .deleteAndRecreateTable('location');
                                      await controller.deleteAndRecreateTable('category');
                                      await controller.deleteAndRecreateTable('site');
                                      Timer(Duration(seconds: 2), () async {
                                        await controller.fetchLocationData();
                                        await controller.fetchCategoryData();
                                        await controller.fetchSiteData();
                                        // await _controller.fetchSiteData();
                                        DashboardController dashboardController = Get.find<DashboardController>();
                                        await dashboardController.getData();
                                        isloading.value = false;
                                        // Get.offNamedUntil(
                                        //     Routes.dashboard, (route) => false);
                                      });
                                    },
                                    child: Text(
                                      'Import Location',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      isloading.value = true;
                                      // await controller.deleteAndRecreateTable('assets');

                                      Timer(Duration(seconds: 0), () {
                                        isloading.value = false;
                                        // controller.fetchLocationData();
                                        // controller.fetchData();
                                        Get.offAndToNamed(Routes.assetsImport);
                                      });
                                    },
                                    child: Text(
                                      'Import Assets',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })).marginOnly(bottom: 20),
            ),


            // Obx(
            //       () => controller.exportCheck.value?CircularProgressIndicator(): InkWell(
            //     onTap: () async {
            //       // Get.toNamed(Routes.assetsExport);
            //       // await controller.fetchExportData();
            //     },
            //     child: CommonBtn(title: 'Export Data'),
            //   ),
            // ),

            Obx(
              () => controller.exportCheck.value?CircularProgressIndicator(): InkWell(
                onTap: () async {
                  Get.toNamed(Routes.assetsExport);
                  // await controller.fetchExportData();
                },
                child: CommonBtn(title: 'Export Data'),
              ),
            ),
            SizedBox(height: 20,),

            InkWell(
              onTap: () async {
                bool? isDeleteConfirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you really want to delete the data?'),
                      actions:[
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),

                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (isDeleteConfirmed ?? false) {
                  Timer(Duration(seconds: 0), () async {
                    await controller.deleteAndRecreateTable('assets');
                    // await controller.deleteAndRecreateTable('location');
                    // await controller.deleteAndRecreateTable('category');
                    // await controller.deleteAndRecreateTable('site');
                    Get.find<DashboardController>().clearPreferences();
                    // Get.snackbar('Success', 'All data cleared from SharedPreferences');

                    // await controller.
                    // DashboardController
                    // dashboardController =
                    // Get.find<DashboardController>().getData();
                    // await dashboardController.getData();
                    // isloading.value = false;
                    Get.offNamedUntil(
                        Routes.dashboard, (route) => false);
                  });
                  Get.snackbar(
                      'Success',
                      'Rest Data successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white
                  );
                }
              },
              child: CommonBtnn(title: 'Reset Data'),
            )

          ],
        ),
      ),
      appBar: appbar(),
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
            'IMPORT/EXPORT',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
