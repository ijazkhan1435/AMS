import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TooltipController extends GetxController {
  OverlayEntry? _overlayEntry;

  void showTooltip(String message) {
    _overlayEntry = _createOverlayEntry(message);
    Overlay.of(Get.overlayContext!).insert(_overlayEntry!);
    Future.delayed(Duration(seconds: 2), () {
      _overlayEntry?.remove();
    });
  }

  OverlayEntry _createOverlayEntry(String message) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.black,
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
