// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  var present={}.obs;
  OverlayEntry? _overlayEntry;
  List data = [
    {'date': '12/02/2020'},
    {'date': '17/12/2020'},
    {'date': '08/07/2020'}
  ];
  @override
  void onInit() async {
    super.onInit();
    present.value = data.last;
    print(present);
  }
}
