import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ui/widgets/commonBtn.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/api_helper.dart';
class Dispose extends StatefulWidget {
  const Dispose({super.key});

  @override
  State<Dispose> createState() => _DisposeState();
}

class _DisposeState extends State<Dispose> {
  bool showTextField = false;
  var arg=Get.arguments;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appbar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormFildWidgets(title: 'Dispose Date', icon: Icons.date_range,onPressd: ()async{
              DateTime? pickedDate = await showDatePicker(context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2050));
              if(pickedDate != null){
              }
            }),
            SizedBox(height: 20,),

            TextFormFildWidgets(title: 'Disposal reason',),
            Spacer(),
            CommonBtn(title: 'ADD SITE',onPressd: (){
              apiFetcher('Post','/api/Location/UpdateAssetStatusAndLocation?assetTagId=$arg&statusID=${5}',
              );
              // updateAssetLocation(arg['assetID'],showTextField?3:2,6);
              Get.back();
              Get.back();},)
          ],
        ),
      ),
    );
  }

  PreferredSize appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 3.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: AppBar(
          title: Text(
            'DISPOSE',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
