import 'package:get/get.dart';

class MisplacedController extends GetxController {
  var misplaced = <dynamic>[].obs;

  void setMissingAssets(List<dynamic> assets) {
    misplaced.assignAll(assets);
  }
}