import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:get/get.dart';
import '../../../controllers/foundAssetsController.dart';
import 'bottombar.dart';

class NotFound extends StatelessWidget {
  final FoundAssetsController controller = Get.put(FoundAssetsController());

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
          title: const Text('Not Found Assets'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Obx(() => controller.isLoadingNot.value
            ? CircularProgressIndicator()
            : Column(
                children: [
                  InkWell(
                    onTap: () {
                      // controller.notFoundSet();
                    },
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: const [
                          Icon(Icons.warning, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(
                                  'Assets that are available in the database but not found during the scan.')),
                        ],
                      ),
                    ).marginOnly(bottom: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(alignment: Alignment.bottomLeft,
                      child: Text(
                        'Result: ${controller.dc.notfound.length}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return controller.dc.notfound.isEmpty
                          ? Center(
                              child: Container(
                                width: Get.width * 0.9,
                                child: const Text(
                                  'No assets were found that exist in the database but were not found during the scan.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.dc.notfound.length,
                              itemBuilder: (context, index) {
                                final asset = controller.dc.notfound[index];
                                print(asset);
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
                                                  'Asset tag ID: ${controller.dc.notfound[index]['assetTagID']}',
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
                                                      ' ${controller.dc.notfound[index]['assetDescription']?.trim()}',
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
                                                    ' ${controller.dc.notfound[index]['siteDescription']?.trim()}',
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
                                                    ' ${controller.dc.notfound[index]['locationDescription']}',
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
                                                      ' ${controller.dc.notfound[index]['categoryDescription']}',
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
                            );
                    }),
                  ),
                ],
              )),
        bottomNavigationBar: historyBottom(2),
      ),
    );
  }
}
