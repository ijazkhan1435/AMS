

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import '../../../controllers/ipconfig_controller.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/uidata/appImages.dart';
import '../../../utils/uidata/color.dart';


class IpConfig extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    IpConfigController _ = Get.put(IpConfigController());
    _.ip.text = box.read('ip') ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Connectivity',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        centerTitle: true,
        // backgroundColor: AppThemeData.coreDarkBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/logos/emergtech_logo.png',
                      height: Get.height/10,
                      width: Get.width/2,
                      // height: MediaQuery.of(context).size.height*0.2,
                      // width: MediaQuery.of(context).size.width,
                    ),

                  const SizedBox(height: 16),
                    const Text(
                      'Assets Management System',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Opacity(
                opacity: .4,
                child: Container(
                  height: Get.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: _.ip,
                    decoration: InputDecoration(
                      hintText: '192.168.1.14:9009',
                      filled: true,
                      fillColor: Colors.white,
                      // hintStyle: Theme.of(context).textTheme.bodyMedium,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.05,
                          vertical: Get.height * 0.015,),
                    ),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                    backgroundColor: Colors.white),
                    cursorColor: Colors.black,
                    textAlignVertical: TextAlignVertical.center,

                  )

                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: AppThemeData.coreDarkBlue,
                      ),
                      onPressed: () {
                        _.save();
                        // Get.toNamed(Routes.login);
                        box.write('ip', _.ip.text);

                        Get.snackbar(
                          "Success",
                          "IP Address saved successfully!",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      child: const Text('Save',overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: AppThemeData.coreDarkBlue,
                      ),
                      onPressed: ()async{
                        Navigator.pop(context);
                      },
                      child: const Text('Back'),

                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: AppThemeData.coreDarkBlue,
                      ),
                      onPressed: () async {
                        _.connectivityCheck.toggle();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Center(
                              child: CircularProgressIndicator(color: Colors.blue,),
                            );
                          },
                        );
                        await Future.delayed(Duration(seconds: 3));
                        Navigator.of(context).pop();
                        _.cs.connectivityCheck();
                      },
                      child: const Text('Check Connectivity Status'),
                    )
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      _.connectivityCheck.toggle();
                      _.cs.connectivityCheck();
                    },
                    child: Text(
                      'Connectivity Status',
                      style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                    ).marginOnly(top: 20),
                  ),
                  Obx(
                        () => _.connectivityCheck.value
                        ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Obx(() => Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Color.fromARGB(255, 96, 253, 57)
                                          .withOpacity(
                                          _.cs.ServerStatus.value
                                              ? 1
                                              : 0),
                                      blurRadius: 8.0,
                                      spreadRadius: 2.0,
                                    )
                                  ],
                                  color: _.cs.ServerStatus.value
                                      ? Color.fromARGB(126, 54, 244, 60)
                                      : Color.fromARGB(128, 255, 0, 0),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                            )),
                            Text(
                              'Server Status',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ).marginOnly(left: 10)
                          ],
                        ).marginOnly(left: 3),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Obx(() => Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Color.fromARGB(255, 96, 253, 57)
                                          .withOpacity(_.cs.DatabaseStatus.value ? 1 : 0),
                                      blurRadius: 8.0,
                                      spreadRadius: 2.0,
                                      // offset: Offset(4.0, 4.0),
                                    )
                                  ],
                                  color: _.cs.DatabaseStatus.value
                                      ? Color.fromARGB(126, 54, 244, 60)
                                      : Color.fromARGB(128, 255, 0, 0),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                            ).marginOnly(left: 5)),
                            Text(
                              'Database Status',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ).marginOnly(left: 10)
                          ],
                        ),
                      ],
                    )
                        : SizedBox(),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
