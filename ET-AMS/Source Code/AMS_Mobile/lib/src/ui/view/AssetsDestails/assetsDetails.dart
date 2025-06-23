import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/assetsDetailsController.dart';
import 'package:flutter_application_1/src/controllers/dashboard_controller.dart';
import 'package:flutter_application_1/src/controllers/viewAssets_controller.dart';
import 'package:flutter_application_1/src/ui/view/AssetsDestails/bottomBar.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/foundAssetsController.dart';
import '../../../utils/helpers/db_helper.dart';

class AssetsDetails extends StatelessWidget {
  // final AssetsDetailsController controller = Get.put(AssetsDetailsController());

  final FoundAssetsController _ = Get.put(FoundAssetsController());
  final DashboardController dc = Get.find<DashboardController>();

  DatabaseHelper db = Get.put(DatabaseHelper());
  @override
  Widget build(BuildContext context) {
    var arg = Get.arguments;

    return Scaffold(
      appBar: appbar(arg),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    print('hhhhhh$arg');
                    Get.back();
                    await db.updateAssetStatus(arg['assetTagID'], 'Check out');
                    dc.cheackOut.add(arg);
                    log("==== check out arg $arg");

                    final prefs = await SharedPreferences.getInstance();
                    String? existingData = prefs.getString('checkedOutAssets');
                    List<dynamic> existingList = existingData != null ? jsonDecode(existingData) : [];
                    existingList.add(arg);
                    await prefs.setString('checkedOutAssets', jsonEncode(existingList));

                    _.getData();
                    // Get.find<ViewAssetsController>().getData();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.reply_rounded,
                          size: 30, color: UIDataColors.commonColor),
                      Text('CheckOut',
                          style: TextStyle(
                              fontSize: 13, color: UIDataColors.commonColor)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    log("=== arg ${arg}");
                    Get.back();
                    await db.updateAssetStatus(arg['assetTagID'], 'Check in');
                    dc.cheackin.add(arg);

                    final prefs = await SharedPreferences.getInstance();
                    String? existingData = prefs.getString('checkedInAssets');
                    List<dynamic> existingList = existingData != null ? jsonDecode(existingData) : [];
                    existingList.add(arg);
                    await prefs.setString('checkedInAssets', jsonEncode(existingList));

                    _.getData();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.reply_rounded,
                          size: 30, color: UIDataColors.commonColor),
                      Text('Checked IN',
                          style: TextStyle(
                              fontSize: 13, color: UIDataColors.commonColor)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    await db.updateAssetStatus(arg['assetTagID'], 'Dispose');
                    dc.dispos.add(arg);

                    final prefs = await SharedPreferences.getInstance();
                    String? existingData = prefs.getString('disposedAssets');
                    List<dynamic> existingList = existingData != null ? jsonDecode(existingData) : [];
                    existingList.add(arg);
                    await prefs.setString('disposedAssets', jsonEncode(existingList));

                    _.getData();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.delete_rounded,
                          size: 28, color: UIDataColors.commonColor),
                      Text('Dispose',
                          style: TextStyle(
                              fontSize: 13, color: UIDataColors.commonColor)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    await db.updateAssetStatus(arg['assetTagID'], 'Lost');
                    dc.lost.add(arg);

                    final prefs = await SharedPreferences.getInstance();
                    String? existingData = prefs.getString('lostAssets');
                    List<dynamic> existingList = existingData != null ? jsonDecode(existingData) : [];
                    existingList.add(arg);
                    await prefs.setString('lostAssets', jsonEncode(existingList));

                    _.getData();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.help_center_rounded,
                          size: 30, color: UIDataColors.commonColor),
                      Text('Lost',
                          style: TextStyle(
                              fontSize: 13, color: UIDataColors.commonColor)),
                    ],
                  ),
                ),
              ],
            ).marginSymmetric(horizontal: 30, vertical: 10),
            if (arg['image'] != null)
              Container(
                height: 250,
                width: Get.width,
                color: Color.fromARGB(34, 158, 158, 158),
                child: arg['image'] == 'na'
                    ? Icon(
                        Icons.image,
                        size: 75,
                        color: const Color.fromARGB(123, 158, 158, 158),
                      )
                    : arg['image'][0] == 'a'
                        ? Image.asset(arg['image'])
                        : Image.file(File(arg['image'])),
              ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asset Tag ID:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text('${arg['assetTagID']}')
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(6),
                //     color: Color.fromARGB(255, 0, 213, 39),
                //   ),
                //   child: Text(
                //     'Available',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // )
              ],
            ).marginSymmetric(horizontal: 20, vertical: 20),
            InkWell(
              // onTap: () {
              //   Get.toNamed(Routes.location,arguments: arg['assetID']);
              //   print(arg['assetTagID']);
              // },

              onTap: () {
                print("Asset Tag ID: ${arg['assetTagID']}");
                if (arg['assetTagID'] != null) {
                  Get.toNamed(Routes.location, arguments: [arg['assetTagID'],1]);
                } else {
                  print("Error: Asset Tag ID is NULL!");
                }
              },

              child: Container(
                // padding: EdgeInsets.symmetric(horizontal: 60,vertical: 2),
                width: Get.width - 40,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: UIDataColors.commonColor,
                ),
                child: Text(
                  'LOCATE ASSET',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ).marginOnly(bottom: 25),
            ),
            if (arg["assetTagID"] != null)
              des('AssetTagID', '${arg['assetTagID']}', 2),
            if (arg["assetID"] != null) des('AssetID', '${arg["assetID"]}', 1),
            if (arg["assetsStatus"] != null)
              des('AssetsStatus', '${arg["assetsStatus"]}', 2),
            if (arg["LocationDescription"] != 'NA')
              des('LocationDescription', '${arg['locationDescription']}', 1),
            if (arg["AssetDescription"] != 'NA')
              des('AssetDescription', '${arg['assetDescription']}', 2),
            if (arg["LocationIsActive"] != null)
              des('LocationIsActive', '${arg['locationIsActive']}', 1),
            if (arg["LocationCreatedBy"] != null)
              des('LocationCreatedBy', '${arg['locationCreatedBy']}', 2),
            if (arg["Cost"] != 'NA') des('Cost', '${arg['cost']}', 1),
            if (arg["siteDescription"] != 'NA')
              des('SiteDescription', '${arg["siteDescription"]}', 2),
            if (arg["categoryDescription"] != 'NA')
              des('CategoryDescription', '${arg["categoryDescription"]}', 1),

            if (arg["LocationCreateTimeStamp"] != 'NA')
              des('LocationCreateTimeStamp',
                  '${arg['locationCreateTimeStamp']}', 2),
            if (arg["AssetCreatedBy"] != null)
              des('AssetCreatedBy', '${arg['assetCreatedBy']}', 1),
            if (arg["SiteID"] != null) des('SiteID', '${arg['siteID']}', 2),
            if (arg["LocationID"] != null)
              des('LocationID', '${arg['locationID']}', 1),
            if (arg["HistoryCreateTimeStamp"] != null)
              des('HistoryCreateTimeStamp', '${arg['historyCreateTimeStamp']}',
                  2),
            if (arg["Image"] != 'na') des('Image', '${arg['image']}', 1),
            if (arg["AssetBarcode"] != null)
              des('AssetBarcode', '${arg['assetBarcode']}', 2),
            if (arg["AssetTagID"] != null)
              des('AssetTagID', '${arg['assetTagID']}', 1),
            if (arg["IsDepreciation"] != 'NA')
              des('IsDepreciation', '${arg['isDepreciation']}', 2),
            if (arg["AssetCategoryID"] != null)
              des('AssetCategoryID', '${arg['assetCategoryID']}', 1),
            if (arg["HistoryRemarks"] != null)
              des('HistoryRemarks', '${arg["historyRemarks"]}', 2),
            if (arg["AssetCreateTimeStamp"] != 'NA')
              des('AssetCreateTimeStamp', '${arg["assetCreateTimeStamp"]}', 1),
            if (arg["Remarks"] != null) des('Remarks', '${arg["remarks"]}', 2),
            if (arg["assetIsActive"] != null)
              des('AssetIsActive', '${arg["assetIsActive"]}', 1),
            if (arg["siteCreatedBy"] != null)
              des('SiteCreatedBy', '${arg["siteCreatedBy"]}', 2),
            if (arg["employeeName"] != null)
              des('EmployeeName', '${arg["employeeName"]}', 1),
            if (arg["statusDescription"] != null)
              des('StatusDescription', '${arg["statusDescription"]}', 2),
            if (arg["purchasedDate"] != null)
              des('PurchasedDate', '${arg["purchasedDate"]}', 1),
            if (arg["createdDate"] != null)
              des('CreatedDate', '${arg["createdDate"]}', 2),
            if (arg["depreciationMethod"] != null)
              des('DepreciationMethod', '${arg["depreciationMethod"]}', 1),
          ],
        ),
      ),
      // bottomNavigationBar: bottombar(0),
    );
  }

  Container des(String key, String value, int check) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 10),
      color: check > 1
          ? Color.fromARGB(255, 239, 239, 239)
          : Color.fromARGB(255, 255, 255, 255),
      child: Row(
        children: [
          SizedBox(
              width: Get.width / 2.5,
              child: Text(
                '$key:',
                style: TextStyle(fontWeight: FontWeight.w600),
              )).marginOnly(left: 20),
          Expanded(
              child: Text(
            '$value',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ).marginOnly(left: 20))
        ],
      ),
    );
  }

  PreferredSize appbar(var arg) {
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
              'ASSETS DETAILS',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          // actions: [
          //   Center(
          //       child: InkWell(
          //     onTap: () {
          //
          //       // log("====12334");
          //       // log("==========12334567"+arg["assetDescription"]);
          //       // print(arg["employeeName"]!);
          //       // log(arg.toString());
          //       Get.toNamed(Routes.editAssets, arguments: arg);
          //
          //       // Get.toNamed(Routes.editAssets);
          //     },
          //     child: Icon(
          //       Icons.add,
          //       size: 30,
          //       color: UIDataColors.commonColor,
          //     ),
          //   )).marginOnly(right: 18),
          // ],
        ),
      ),
    );
  }
}
