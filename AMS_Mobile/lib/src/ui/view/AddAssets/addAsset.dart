import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/addAsset_controller.dart';
import 'package:flutter_application_1/src/controllers/dashboard_controller.dart';
import 'package:flutter_application_1/src/controllers/tolltip_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/commonBtn.dart';
import 'package:flutter_application_1/src/ui/widgets/container.dart';
import 'package:flutter_application_1/src/ui/widgets/modelbottomSheet.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddAssets extends StatelessWidget {
  final AddAssetsController controller = Get.put(AddAssetsController());
  final DashboardController dashboardController =
  Get.find<DashboardController>();
  TooltipController tooltipController = Get.put(TooltipController());
  bool showTextField = true;
  RxList<String> category=<String>['Electronics','Furniture','Vehicles','Machinery','Office Supplies','Stationery'].obs;
  RxList<String> site=<String>['ET Lahore','ET Karachi','ET Riyadh'].obs;
  RxList<String> location=<String>['IT Department','HR Department','Admin Department',].obs;
  RxList<String> depreciation=<String>['Digits Method','Straight line Method','Monthly Depreciation','Rate of Depreciation'].obs;

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () {
    //   tooltipController.showTooltip('This screen us used to add Assets in the list.');
    // });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormFildWidgets(
                      title: 'Asset Tag ID:*',
                      iconButton: IconButton(
                        onPressed: () {
                          controller.viewAsset();
                        },
                        iconSize: 22,
                        icon: const Icon(Icons.center_focus_strong_outlined),
                        color: UIDataColors.commonColor,
                      ),
                      txtcontroller: controller.assetTagIdController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Asset Tag ID is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormFildWidgets(
                      read: true,
                      title: 'Purchased Date',
                      iconButton: IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            var formattedDate =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            controller.purchasedDateController.text = formattedDate;
                          }
                        },
                        icon: const Icon(Icons.date_range),
                      ),
                      txtcontroller: controller.purchasedDateController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Purchased Date is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // TextFormFildWidgets(
                    //   read: true,
                    //   title: 'Category',
                    //   iconButton: IconButton(
                    //     onPressed: () async {
                    //       if (controller.categoryList.isEmpty) {
                    //         await controller.getCategories();
                    //       }
                    //       print(controller.categoryList);
                    //       appBottomSheet(controller.categoryList, (index) {
                    //         Get.back();
                    //         controller.categoryController.text = controller.categoryList[index]['categoryDescription'];
                    //         controller.selectedCategoryID = controller.categoryMap.entries
                    //             .firstWhere((entry) => entry.value == controller.categoryList[index]['categoryDescription'])
                    //             .key;
                    //
                    //       },'categoryDescription'
                    //       );
                    //
                    //     },
                    //     icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    //   ),
                    //   txtcontroller: controller.categoryController,
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Category is required';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    TextFormFildWidgets(
                      read: true,
                      title: 'Category',
                      iconButton: IconButton(
                        onPressed: () async {
                          if (controller.categoryList.isEmpty) {
                            await controller.getCategories();
                          }
                          print(controller.categoryList);

                          appBottomSheet(controller.categoryList, (index) {
                            Get.back();
                            controller.categoryController.text = controller.categoryList[index]['categoryDescription'];
                            controller.selectedCategoryID = controller.categoryList[index]['categoryID'];

                            print('Selected Category ID: ${controller.selectedCategoryID}');
                          }, 'categoryDescription');
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      ),
                      txtcontroller: controller.categoryController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Category is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormFildWidgets(
                      title: 'Description',
                      txtcontroller: controller.descriptionController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormFildWidgets(
                      title: 'Cost',
                      txtcontroller: controller.costController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Cost is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    TextFormFildWidgets(
                      title: 'Created Date',
                      read: true,
                      iconButton: IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            DateTime dateTime = pickedDate;
                            var formattedDate =
                                "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
                            controller.createdDateController.text = formattedDate.toString();
                          }
                        },
                        icon: const Icon(Icons.date_range),
                      ),
                      txtcontroller: controller.createdDateController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Created Date is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ContWidgets(text: 'ASSETS LOCATION'),
                    SizedBox(
                      height: 20,
                    ),
                    // TextFormFildWidgets(
                    //   read: true,
                    //   title: 'Site',
                    //   iconButton: IconButton(
                    //     onPressed: () {
                    //       appBottomSheet(site, (index) {
                    //         Get.back();
                    //         controller.siteController.text = site[index];
                    //         controller.siteIndex = index + 1;
                    //       });
                    //     },
                    //     icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    //   ),
                    //   txtcontroller: controller.siteController,
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Site is required';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // TextFormFildWidgets(
                    //   title: 'Location',
                    //   read: true,
                    //   iconButton: IconButton(
                    //     onPressed: () {
                    //       controller.filterLocation = [];
                    //       for (var i = 0; i < controller.locationcheck.length; i++) {
                    //         if (controller.locationcheck[i]['siteID'] == controller.siteIndex) {
                    //           controller.filterLocation.add(controller.locationcheck[i]['locationDescription']);
                    //         }
                    //       }
                    //       appBottomSheet(controller.filterLocation, (index) {
                    //         Get.back();
                    //         controller.locationController.text = controller.filterLocation[index];
                    //         print(controller.locationcheck);
                    //         for (var i = 0; i < controller.locationcheck.length; i++) {
                    //           if (controller.locationcheck[i]['locationDescription'] == controller.locationController.text) {
                    //             controller.locationId = controller.locationcheck[i]['locationID'];
                    //             break;
                    //           }
                    //         }
                    //         print('sssssdss${controller.locationId}');
                    //       });
                    //     },
                    //     icon: Icon(Icons.keyboard_arrow_down_outlined),
                    //   ),
                    //   txtcontroller: controller.locationController,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please select a Location';
                    //     }
                    //     return null;
                    //   },
                    // ),

                    TextFormFildWidgets(
                      read: true,
                      title: 'Site',
                      iconButton: IconButton(
                        onPressed: () {
                          print(dashboardController.selectDetails);
                          appBottomSheet(
                            // dashboardController.selectDetails
                            //     .map((e) => e['siteDescription'])
                            //     .toSet()
                            //     .toList(),
                            dashboardController.selectDetails,
                                (index) {
                              Get.back();
                              String selectedSite = dashboardController
                                  .selectDetails
                                  .map((e) => e['siteDescription'])
                                  .toSet()
                                  .toList()[index];
                              int? selectedSiteId = dashboardController
                                  .selectDetails
                                  .firstWhere((e) =>
                              e['siteDescription'] ==
                                  selectedSite)['siteID'];
                              controller.siteController.text =
                                  selectedSite.trim();
                              controller.siteIndex =
                                  selectedSiteId ?? -1;
                              controller.filterLocation =
                                  dashboardController.selectDetails
                                      .where((e) =>
                                  e['siteID'] == selectedSiteId)
                                      .map((e) =>
                                  e)
                                      .toList();
                              controller.locationController.clear();
                              controller.locationId = null;
                              print('Selected Site: $selectedSite');
                              print('Site ID: $selectedSiteId');
                              print(
                                  'Filtered Locations: ${controller.filterLocation}');
                              controller.update();
                            },'siteDescription',
                          );
                        },
                        icon: const Icon(
                            Icons.keyboard_arrow_down_outlined),
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
                    SizedBox(
                      height: 20,
                    ),
                    ContWidgets(
                      text: 'ASSETS IMAGE',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      height: 270,
                      width: 400,
                      child: Obx(() {
                        return controller.imageFile.value == null
                            ? Center(child: Text('No image selected.'))
                            : Image.file(controller.imageFile.value!);
                      }),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      width: 170,
                      child: ElevatedButton(
                        onPressed: () =>
                            controller.pickImage(ImageSource.camera),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                UIDataColors.commonColor)),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'UPLOAD IMAGE',
                              style:
                              TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ContWidgets(text: 'DEPRECIATION'),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Depreciation",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: RadioListTile(
                            title: Text('Yes'),
                            value: 'Option1',
                            groupValue: controller.selectedRadio.value,
                            onChanged: (value) {
                              controller.setSelectedRadio(value as String);
                              print(
                                  'Selected Radio Value: ${controller.selectedRadio.value}');
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            title: const Text('No'),
                            value: 'Option2',
                            groupValue: controller.selectedRadio.value,
                            onChanged: (value) {
                              controller.setSelectedRadio(value as String);
                              controller.update();
                              print(
                                  'Selected Radio Value: ${controller.selectedRadio.value}');
                            },
                          ),
                        ),
                      ],
                    ),
                    if(controller.selectedRadio.value=="Option1")
                      Visibility(
                        visible: showTextField,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormFildWidgets(
                                read: true,
                                title: 'Depreciation Method',
                                iconButton: IconButton(onPressed: (){
                                  appBottomSheet(depreciation,(index){
                                    Get.back();
                                    controller.depreciationController.text=   depreciation[index];
                                  });
                                }, icon: Icon(Icons.keyboard_arrow_down_sharp)),
                                txtcontroller: controller.depreciationController,
                                onPressd: () {
                                  appBottomSheet(depreciation,(index){
                                    Get.back();
                                    controller.depreciationController.text=   depreciation[index];
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormFildWidgets(
                                txtcontroller: controller.totalCostController,
                                title: 'Total Cost(USD)*',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormFildWidgets(
                                txtcontroller: controller.assetsLifeController,
                                title: 'Asset Life(Month)*',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormFildWidgets(
                                txtcontroller: controller.salvageController,
                                title: 'Salvage Value(USD)*',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormFildWidgets(
                                  txtcontroller: controller.dateAcquiredController,
                                  iconButton: IconButton(onPressed: ()async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2050));
                                    if (pickedDate != null) {
                                      DateTime dateTime = pickedDate;
                                      var formattedDate =
                                          "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

                                      controller.dateAcquiredController.text =
                                          formattedDate.toString();
                                    }
                                  },
                                      icon: Icon(Icons.date_range)),
                                  title: 'Date Acquired',
                                  icon: Icons.date_range),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: CommonBtn(
                  title: 'SAVE',  // Use 'title' instead of 'buttonText'
                  onPressd: () {
                    controller.save();
                  },
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
            'ADD ASSET',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}