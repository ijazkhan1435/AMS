import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/foundAssetsController.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:get/get.dart';

BottomNavigationBar historyBottom(int page) {
  final FoundAssetsController _ = Get.put(FoundAssetsController());

  return BottomNavigationBar(
    selectedFontSize: 11,
    unselectedLabelStyle: const TextStyle(color: Colors.black, fontSize: 10),
    type: BottomNavigationBarType.fixed,
    currentIndex: page,

    items: [
      BottomNavigationBarItem(
          icon: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.allAssets);
                _.scanData2();
              },
              child: Icon(Icons.note_alt_outlined)),
          label: 'All Assets'),
      BottomNavigationBarItem(
        icon: GestureDetector(
          onTap: () {
            // _.getData();
            Get.toNamed(Routes.foundAssets);
          },
          child: Icon(
            Icons.search,
            // color: Color.fromARGB(255, 54, 54, 54),
          ),
        ),
        label: 'Found',
      ),
      BottomNavigationBarItem(
          icon: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.notFound);
              },
              child: Icon(Icons.description_outlined)),
          label: 'NotFound'),

      BottomNavigationBarItem(
          icon: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.newAssets);
              },
              child: Icon(Icons.star)),
          label: 'New'),

    ],
  );
}
