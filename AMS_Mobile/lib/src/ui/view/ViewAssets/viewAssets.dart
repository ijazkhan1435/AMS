import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/dashboard_controller.dart';
import 'package:flutter_application_1/src/controllers/viewAssets_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/modelbottomSheet.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';

import '../ScanHistory/bottombar.dart';

class ViewAssets extends StatelessWidget {
  final ViewAssetsController controller = Get.put(ViewAssetsController());
  final DashboardController dashboardController =
  Get.find<DashboardController>();
  // RxList<String> site=<String>['ET Lahore','ET Karachi','ET Riyadh'].obs;
  @override
  Widget build(BuildContext context) {
    ViewAssetsController _ = Get.find<ViewAssetsController>();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: appbar(),
      body: Obx(
        () => _.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : body(_),
      ),
      // bottomNavigationBar: historyBottom(0),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Icon(Icons.filter_list),
        ),
      ),
      endDrawer: _Drawer(context),
    );
  }

  Widget _Drawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        SizedBox(height: 40,),
        Container(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
        )),
        Container(
          width: 250, // Specify a width
          child:
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
        ),

        SizedBox(
          height: 20,
        ),
        Container(
          width: 250,
          child:
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
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "STATUS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    InkWell( onTap: (){
                      controller.selectedStatus.value = 'Check in';
                      log('checkin${controller.selectedStatus.value}');
                      controller.filterAsset(controller.siteController.text,controller.locationController.text,controller.selectedStatus.value);

                      Get.back();
                      },
                      child: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(child: Text('Check in')),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(onTap: (){
                      controller.selectedStatus.value = 'Check out';
                      log('${controller.selectedStatus.value}');
                      controller.filterAsset(controller.siteController.text,controller.locationController.text,controller.selectedStatus.value);
                      Get.back();

                      },
                      child: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(child: Text('Check out')),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    InkWell(onTap: (){
                      controller.selectedStatus.value = 'Dispose';
                      log('${controller.selectedStatus.value}');

                      controller.filterAsset(controller.siteController.text,controller.locationController.text,controller.selectedStatus.value);
                      Get.back();
                      },
                      child: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(child: Text('Dispose')),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(onTap: (){
                      controller.selectedStatus.value = 'Lost';
                      controller.filterAsset(controller.siteController.text,controller.locationController.text,controller.selectedStatus.value);

                      Get.back();
                      },
                      child: Container(
                        height: 20,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(child: Text('Lost')),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(onTap: (){
                      controller.selectedStatus.value = 'New Assets';
                      controller.filterAsset(controller.siteController.text,controller.locationController.text,controller.selectedStatus.value);

                      Get.back();
                    },
                      child: Container(
                        height: 20,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(child: Text('New')),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),


                SizedBox(height: 30,),

                InkWell(onTap: ()async{
                  controller .getData();
                  // log('${controller.selectedStatus.value}');
                  // log('===oo ${controller.siteController.text} dd  ${controller.locationController.text}oo ${controller.selectedStatus.value}');
                  // controller.filterAsset(controller.siteController.text,controller.locationController.text,controller.selectedStatus.value);
                  Get.back();
                },
                  child: Text(
                    'CLEAR FILTER',
                    style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                )

              ],
            ),
          ),
        ),
      ],
    ));
  }

  SingleChildScrollView body(ViewAssetsController _) {
    // print('jhgcf');
    // log(_.data[0]["siteDescription"]+"====="+controller.siteController.text);


    // log(controller.filteredData[0]["siteDescription"]+"====="+controller.siteController.text);

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
                print('sdfgdsertdgf$value');
                _.scanData(value);
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
                    _.viewAsset();
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
                onTap: (){
                  _.getData();
                },
                child: Text(
                  // 'Results: ${_.data?.length} Assets',
                  'Results: ${_.filteredData.length} Assets',
                ),
              ),
              // InkWell(
              //     onTap: () {}, child: Icon(Icons.format_list_numbered_rounded))
            ],
          ).marginSymmetric(horizontal: 15).marginOnly(bottom: 10),
          Container(
            padding: EdgeInsets.only(bottom: 80),
            height: Get.height / 1.2,
            width: Get.width,
            child: ListView.builder(
              itemCount: _.filteredData.length,
              // itemCount: _.filteredData.isNotEmpty ? _.filteredData.length : 0,
              itemBuilder: (BuildContext context, ind) {
                // if (_.filteredData.isEmpty) {
                //   return Center(child: Text('No data available'));
                // }


                log(_.data[ind]["siteDescription"]+"====="+controller.siteController.text);
                // var filterData = _.data;
                var itemData = _.filteredData[ind];
                // var itemData = filterData[ind] ?? {};
                var statusCheck = _.dc.found.any((foundItem) =>
                foundItem['assetTagID'] == itemData['assetTagID']);
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
                                '• ${itemData['assetsStatus'] ?? 'Not Found' }',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: statusCheck
                                      ? Colors.green
                                      : Colors.orange,
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
                                  Icon(Icons.description_outlined, size: 17)
                                      .marginOnly(right: 5),
                                  Text('Description:'),
                                  // Spacer(),
                                  SizedBox(width:Get.width/17),
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
                                  Icon(Icons.add_location_alt, size: 17)
                                      .marginOnly(right: 5),
                                  Text('Site:'),
                                  SizedBox(width:Get.width/5.4),
                                  // Spacer(),
                                  Expanded(
                                    child: Text(
                                      '${itemData['siteDescription']?.trim() ?? 'No Site'}',
                                      overflow: TextOverflow.ellipsis,
                                    
                                    ),
                                  ),
                                ],
                              ).marginOnly(top: 5, bottom: 5),
                      // Row(
                      //   children: [
                      //     Icon(Icons.add_location_alt, size: 17).marginOnly(right: 5),
                      //     Text('Site:'),
                      //     SizedBox(width: 5),
                      //     Flexible(
                      //       child: Text(
                      //         '${itemData['siteDescription']?.trim() ?? 'No Site'}',
                      //         overflow: TextOverflow.ellipsis,
                      //         maxLines: 1,
                      //       ),
                      //     ),
                      //   ],
                      // ).marginOnly(top: 5, bottom: 5),

                      Row(
                                children: [
                                  Icon(Icons.maps_home_work_outlined, size: 17)
                                      .marginOnly(right: 5),
                                  Text('Location:'),
                                  SizedBox(width:Get.width/9),
                                  // Spacer(),
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
                                  Icon(Icons.category, size: 17)
                                      .marginOnly(right: 5),
                                  Text('Category:'),
                                  SizedBox(width:Get.width/10),
                                  // Spacer(),
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
              'View ASSETS',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
