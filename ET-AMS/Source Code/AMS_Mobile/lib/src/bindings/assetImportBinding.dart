import 'package:get/get.dart';

import '../controllers/assetsImport_controller.dart';

class AssetsImportBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetsImportController>(()=>AssetsImportController());

    // Get.put<AssetsImportController>(AssetsImportController(), permanent: true);
  }
}
