import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/foundAssetsController.dart';
import 'package:flutter_application_1/src/ui/view/ScanHistory/bottombar.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:get/get.dart';

class NewAssets extends StatelessWidget {
  const NewAssets({super.key});

  @override
  Widget build(BuildContext context) {
    FoundAssetsController _ = Get.put(FoundAssetsController());
    _.isLoadingNew.value = false;

    List<String> uniqueAssets = _.dc.newAssets
        .map((e) => e.toString())
        .toSet()
        .toList();

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.scan);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Assets'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: Obx(() => _.isLoadingNew.value
            ? const Center(child: CircularProgressIndicator())
            : Container(
          height: Get.height,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: const [
                      Icon(Icons.lightbulb, color: Colors.yellow),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'List of scanned assets that are not in the system and available to add',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${uniqueAssets.length} Assets',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ).marginSymmetric(vertical: 10),
              uniqueAssets.isNotEmpty
                  ? Expanded(
                child: ListView.builder(
                  itemCount: uniqueAssets.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Row(
                      children: [
                        const Text(
                          'TagId:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        Text('${uniqueAssets[i]}'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Get.offAndToNamed(
                              Routes.addAsset,
                              arguments: uniqueAssets[i],
                            );
                          },
                          child: const Text('ADD'),
                        ),
                      ],
                    );
                  },
                ),
              )
                  : const Center(
                child: Text('No new assets found.'),
              ),
            ],
          ).marginOnly(left: 20, right: 20),
        )
        ),
        bottomNavigationBar: historyBottom(3),
      ),
    );
  }
}

// if (searchId == data[i]['assetTagID'].toString().trim().toLowerCase()&& data[i]['assetID']!=null) {