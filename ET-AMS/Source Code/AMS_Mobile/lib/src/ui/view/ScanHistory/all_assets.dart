import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/foundAssetsController.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';

import 'bottombar.dart';

class AllAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FoundAssetsController _ = Get.find<FoundAssetsController>();
// print(_.arg);
    print('Data: ${_.data}');


    return WillPopScope(
      onWillPop: () async {
        Get.offAndToNamed(Routes.scan);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
        appBar: appbar(),
        body: Obx(
              () => _.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : body(_),
        ),
        bottomNavigationBar: historyBottom(0),
      ),
    );
  }

  SingleChildScrollView body(FoundAssetsController _) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(0, 5),
                  blurRadius: 15.0,
                ),
              ],
            ),
            child: TextField(
              onSubmitted: (value) {
                _.scanData(value, newCheck: true);
                _.getData();
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle:
                TextStyle(color: const Color.fromARGB(148, 158, 158, 158)),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  iconSize: 22,
                  icon: const Icon(Icons.center_focus_strong_outlined),
                  color: UIDataColors.commonColor,
                  onPressed: () {
                    _.viewAsset(true);
                    _.getData();
                  },
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _.scanData2();
                  _.getData();
                },
                child: Text(
                  'Results: ${_.data.where((element) => element['locationID']?.toString() == _.arg['locationID']?.toString()).length} Assets',
                ),

              ),
            ],
          ).marginSymmetric(horizontal: 15).marginOnly(bottom: 10),
          Container(
            padding: EdgeInsets.only(bottom: 80),
            height: Get.height / 1.2,
            width: Get.width,
            child: ListView.builder(
              itemCount: _.data
                  .where((element) => element['locationID']?.toString() == _.arg['locationID']?.toString())
                  .length,
              itemBuilder: (BuildContext context, ind) {
                var filterData = _.data
                    .where((element) => element['locationID']?.toString() == _.arg['locationID']?.toString())
                    .toList();

                filterData.sort((a, b) {
                  int aFound = (a['assetsStatus'] == 'Found') ? 1 : 0;
                  int bFound = (b['assetsStatus'] == 'Found') ? 1 : 0;
                  return bFound - aFound;
                });


                var itemData = filterData[ind] ?? {};

                var statusCheck = _.dc.found.any((foundItem) => foundItem['assetTagID'] == itemData['assetTagID']);
print(_.data);
                return InkWell(
                  onTap: () async {
                    var result = await Get.toNamed(Routes.assetsDetails, arguments: itemData);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: statusCheck ? Colors.white : Colors.white70,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                width: Get.width / 1.7,
                                child: Text(
                                  'Asset tag ID: ${itemData['assetTagID'] ?? 'N/A'}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '• ${ itemData['assetsStatus'] ?? 'Not Found'}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: itemData['assetsStatus'] == 'Found' ? Colors.green : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ).marginSymmetric(vertical: 10),
                        Divider(),
                        Container(
                          width: Get.width / 1.5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.description_outlined, size: 17).marginOnly(right: 5),
                                  Text('Description:'),
                                  SizedBox(width: Get.width / 17),
                                  Expanded(
                                    child: Text(
                                      '${itemData['assetDescription']?.trim() ?? 'No Description'}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ).marginOnly(top: 5, bottom: 5),
                              Row(
                                children: [
                                  Icon(Icons.add_location_alt, size: 17).marginOnly(right: 5),
                                  Text('Site:'),
                                  SizedBox(width: Get.width / 5.4),
                                  Expanded(
                                    child: Text(
                                      '${itemData['siteDescription']?.trim() ?? 'No Site'}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ).marginOnly(top: 5, bottom: 5),
                      Row(
                                children: [
                                  Icon(Icons.maps_home_work_outlined, size: 17).marginOnly(right: 5),
                                  Text('Location:'),
                                  SizedBox(width: Get.width / 9),
                                  Expanded(
                                    child: Text(
                                      '${itemData['locationDescription'] ?? 'No Location'}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ).marginOnly(top: 5, bottom: 5),
                              Row(
                                children: [
                                  Icon(Icons.category, size: 17).marginOnly(right: 5),
                                  Text('Category:'),
                                  SizedBox(width: Get.width / 10),
                                  Expanded(
                                    child: Text(
                                      '${itemData['categoryDescription'] ?? 'No Category'}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ).marginOnly(top: 5, bottom: 13),
                            ],
                          ),
                        ),
                      ],
                    ).marginSymmetric(horizontal: 15),
                  ).marginOnly(bottom: 10).marginSymmetric(horizontal: 15),
                );
              },
            ),

          )
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
          title: Center(
            child: Text(
              'All ASSETS',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
    );
  }
}
