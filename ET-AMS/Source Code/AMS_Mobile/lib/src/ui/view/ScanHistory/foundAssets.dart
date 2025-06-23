
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:get/get.dart';
import '../../../controllers/foundAssetsController.dart';
import 'bottombar.dart';

class FoundAssets extends StatelessWidget {
  final FoundAssetsController controller = Get.find<FoundAssetsController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAndToNamed(Routes.scan);
        print('object');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Found Assets'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: const [
                  Icon(Icons.lightbulb, color: Colors.yellow),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          'List of assets that are found in the selected Site or Location.')),
                ],
              ),
            ),

             Padding(
               padding: const EdgeInsets.all(12.0),
               child: Align(alignment: Alignment.bottomLeft,
                 child: Text(
                  'Result: ${controller.dc.found.length}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                             ),
               ),
             ),
            SizedBox(height: 10,),
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : controller.dc.found.isEmpty
                  ? Center(
                child: Container(
                  width: Get.width * 0.9,
                  child: const Text(
                    'There are no assets present in the selected Site and Location.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: controller.dc.found.length,
                itemBuilder: (context, index) {
                  final asset = controller.dc.found[index];
                  print(controller.dc.found.length);
                  print('asdfsfs$asset');
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  width: Get.width / 1.7,
                                  child: Text(
                                    'Asset tag ID: ${controller.dc.found[index]['assetTagID']}',
                                    overflow:
                                    TextOverflow.ellipsis,
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
                                    Icon(
                                      Icons.description_outlined,
                                      size: 17,
                                    ).marginOnly(right: 5),
                                    Text('Description:'),
                                    Spacer(),
                                    Expanded(
                                      child: Text(
                                        ' ${controller.dc.found[index]['assetDescription']?.trim()}',
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ).marginOnly(top: 5, bottom: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_location_alt,
                                      size: 17,
                                    ).marginOnly(right: 5),
                                    Text('Site:'),
                                    Spacer(),
                                    Text(
                                      ' ${controller.dc.found[index]['siteDescription']?.trim()}',
                                      overflow:
                                      TextOverflow.ellipsis,
                                    ),
                                  ],
                                ).marginOnly(top: 5, bottom: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .maps_home_work_outlined,
                                      size: 17,
                                    ).marginOnly(right: 5),
                                    Text('Location:'),
                                    Spacer(),
                                    Text(
                                      ' ${controller.dc.found[index]['locationDescription']}',
                                      overflow:
                                      TextOverflow.ellipsis,
                                    )
                                  ],
                                ).marginOnly(top: 5, bottom: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 17,
                                    ).marginOnly(right: 5),
                                    Text('Category:'),
                                    Spacer(),
                                    Expanded(
                                      child: Text(
                                        ' ${controller.dc.found[index]['categoryDescription']}',
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Text(' ${_.data[ind]['categoryDescription']}')
                                  ],
                                ).marginOnly(top: 5, bottom: 13),
                              ],
                            ),
                          )
                        ]).marginSymmetric(horizontal: 15),
                  )
                      .marginOnly(bottom: 10)
                      .marginSymmetric(horizontal: 15);
                },
              )),
            ),
          ],
        ),
        bottomNavigationBar: historyBottom(1),
      ),
    );
  }
}