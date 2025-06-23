
import 'package:get/get.dart';

class NotFoundController extends GetxController {
  var missing = <dynamic>[].obs;

  void setMissingAssets(List<dynamic> assets) {
    missing.assignAll(assets);
  }
}

