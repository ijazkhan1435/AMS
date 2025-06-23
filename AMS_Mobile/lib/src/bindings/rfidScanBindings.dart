
import 'package:flutter_application_1/src/controllers/rfidScanController.dart';
import 'package:get/get.dart';

class RfidScanBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<RfidScanController>(() => RfidScanController());
  }

}