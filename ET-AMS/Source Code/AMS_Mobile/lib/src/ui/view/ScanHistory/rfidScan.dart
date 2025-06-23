
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/rfidScanController.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';

class RfidScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RfidScanController _ = Get.find<RfidScanController>();

    final arguments = Get.arguments as Map<String, dynamic>;
    final int siteId = arguments['siteID'];
    final int locationId = arguments['locationID'];

    return Scaffold(
      appBar: appbar(),
      body: Container(
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 300,
                width: Get.width,
                color: UIDataColors.commonColor,
                child: Center(
                  child: Container(
                    height: 180,
                    width: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Text(
                          '${_.tagList.length}',
                          style: TextStyle(fontSize: 40),
                        )),
                        Text('Asset Scanned')
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color.fromARGB(255, 221, 221, 221)),
                  ),
                ),
              ),
              Obx(() => Expanded(
                child: ListView.builder(
                  itemCount: _.tagList.length,
                  itemBuilder: (BuildContext context, index) {
                    return Text(
                      'TagID:  ${_.tagList[index]}',
                      style: TextStyle(
                          color: Color.fromARGB(255, 89, 88, 88),
                          fontWeight: FontWeight.w500),
                    ).marginOnly(left: 30, top: 20);
                  },
                ),
              )),
              InkWell(
                onTap: () {
                  // Get.offNamed(Routes.allAssets,arguments: _.tagList);
                  Get.offNamed(Routes.allAssets, arguments: {
                    'siteID': siteId,
                    'locationID': locationId,
                    'tagList': _.tagList,
                  });
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: UIDataColors.commonColor,
                  ),
                  child: Center(
                      child: Text(
                        'Complete scan',
                        style: TextStyle(color: Colors.white),
                      )),
                ).marginSymmetric(horizontal: 10),
              )
            ],
          )),
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
          title: Center(
            child: Text(
              'SCAN IN PROGRESS',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          actions: [
            Center(
                child: InkWell(
                  onTap: () {

                    Get.toNamed(Routes.addAsset);
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: UIDataColors.commonColor,
                  ),
                )).marginOnly(right: 18),
          ],
        ),
      ),
    );
  }
}