import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ui/widgets/commonBtn.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';

import '../../../controllers/checkout_controller.dart';
import '../../../utils/helpers/api_helper.dart';
import '../../widgets/modelbottomSheet.dart';

class CheckOut extends StatefulWidget {
   CheckOut({super.key});
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final checkoutController controller = Get.put(checkoutController());
  RxList<String> site=<String>['ET Lahore','ET Karachi','ET Riyadh'].obs;

  late TextEditingController tagId;
   late TextEditingController updatedLocation;

  var arg=Get.arguments;

  static const String option1 = 'Option 1';
  static const String option2 = 'Option 2';

  String selectedRadio = option1;

  bool showTextField = false;

  @override
  void initState() {
    super.initState();
    log('Received arguments: $arg');
    tagId = TextEditingController(
      text: arg != null && arg['assetTagID'] != null ? arg['assetTagID'] : "",
    );
    updatedLocation = TextEditingController(
      text: arg != null && arg['locationDescription'] != null ? arg['locationDescription'] : "",
    );
  }

       void updateAssetLocation( assetTagID, status, [newLocation]) async {
    try {
          dynamic response = await apiFetcher(
            'Post',
            '/api/Location/UpdateAssetStatusAndLocation?assetTagId=$assetTagID&statusID=$status&locationID=$newLocation',
          );
        } catch (e) {
    }
  }

  void setSelectedRadio(String value) {
    setState(() {
      selectedRadio = value;
      if (value == option2) {
        showTextField = true;
      } else {
        showTextField = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormFildWidgets(title: "CheckOut Date*", icon: Icons.date_range,onPressd: ()async{
                DateTime? pickedDate = await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if(pickedDate != null){
                }
              }),
              SizedBox(height: 20,),
              Text('CheckOut to'),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Flexible(
                    child: RadioListTile(
                      title:  Text('Employe'),
                      value: option1,
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setSelectedRadio(value as String);
                      },
                    ),
                  ),
                  Flexible(
                    child: RadioListTile(
                      title: const Text('Site/Location'),
                      value: option2,
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setSelectedRadio(value as String);
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showTextField,
                child: TextFormFildWidgets(
                  read: true,
                  title: 'Site',
                  iconButton: IconButton(
                    onPressed: () {
                      appBottomSheet(site, (index) {
                        Get.back();
                        controller.siteController.text = site[index];
                        controller.siteIndex = index + 1;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                  txtcontroller: controller.siteController,
                ),
              ),

              SizedBox(height: 20,),

              TextFormFildWidgets(
                title: 'Location',
                read: true,
                iconButton: IconButton(
                  onPressed: () {
                    controller.filterLocation = [];
                    for (var i = 0; i < controller.locationcheck.length; i++) {
                      if (controller.locationcheck[i]['siteID'] == controller.siteIndex) {
                        controller.filterLocation.add(controller.locationcheck[i]['locationDescription']);
                      }
                    }
                    appBottomSheet(controller.filterLocation, (index) {
                      Get.back();
                      controller.locationController.text = controller.filterLocation[index];
                      for (var i = 0; i < controller.locationcheck.length; i++) {
                        if (controller.locationcheck[i]['locationDescription'] ==  controller.locationController.text) {
                          controller.locationId=controller.locationcheck[i]['locationID'];
                          break;
                        }
                      }
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                ),
                txtcontroller: controller.locationController,
              ),

              SizedBox(height: 20,),
              TextFormFildWidgets(title: 'Due Date', icon: Icons.date_range,onPressd: ()async{
                DateTime? pickedDate = await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050));
                if(pickedDate != null){
                }
              },),
              SizedBox(height: 20,),
              TextFormFildWidgets(title: 'Note', ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(width:  MediaQuery.of(context).size.height /5,
                    height: 50,

                    child: TextButton(
                      onPressed: (){
                        Get.toNamed(Routes.addSite);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: UIDataColors.commonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,)),
                      child: const Text('ADD SITE',
                          style: TextStyle(color: Colors.white,fontSize: 16)),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width:  MediaQuery.of(context).size.height /5,
                    height: 50,
                    child: TextButton(
                      onPressed: (){
                        Get.toNamed(Routes.addLocation);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: UIDataColors.commonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,)),
                      child: const Text('ADD LOCATION',
                          style: TextStyle(color: Colors.white,fontSize: 16)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              CommonBtn(
                title: 'CHECK OUT',
                onPressd: () async{
                  updateAssetLocation(arg['assetTagID'],showTextField?3:2,controller.locationId);
                  log('======$updateAssetLocation');
                  Get.back();
                  Get.back();
                  // Get.back();
                },
              )

            ],
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
            'CHECKOUT',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
  Future appBottomSheet(dynamic list, Function(int)? onTap) {
    return Get.bottomSheet(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[300]!, Colors.grey[600]!],
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        height: 300.0,
        child: ListWheelScrollView(
          diameterRatio: 1,
          itemExtent: 40.0,
          physics: FixedExtentScrollPhysics(),
          overAndUnderCenterOpacity: 0.5,
          children: List.generate(
            list.length,
                (index) => GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap(index);
                }
                controller.index=index+1;
              },
              child: Container(
                // color: Colors.white,
                child: ListTile(
                  selectedTileColor: Colors.blue,
                  title: Center(
                    child: Text(
                      list[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

}
