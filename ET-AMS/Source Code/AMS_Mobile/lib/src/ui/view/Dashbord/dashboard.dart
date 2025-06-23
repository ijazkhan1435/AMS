import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/controllers/dashboard_controller.dart';
import 'package:flutter_application_1/src/services/rfid_service.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/appImages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController _ = Get.find<DashboardController>();

   _.updateChartData();
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitDialog(context);
        return shouldExit;
      },
      child: Scaffold(
          drawer: drawer(_),
          appBar: appbar(_),
          body: RefreshIndicator(
              onRefresh: () => _.getData(),
              child: Obx(
                () => _.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : body(_),
              ))),
    );
  }
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    ) ??
        false;
  }

  SingleChildScrollView body(DashboardController _) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.viewAssets);
            },
            child: Center(
              child: Container(
                width: Get.width - 30,
                height: 90,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        UIDataColors.commonColor,
                        Color.fromARGB(193, 0, 0, 0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.2, 2.9],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Assets',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Obx(() => Text(
                              '${_.assets.length}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28),
                            ))
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/dashboard/purple-bg-images.svg',
                      height: 75,
                    )
                  ],
                ).marginOnly(left: 10),
              ).marginOnly(bottom: 10, top: 15),
            ),
          ),
          InkWell(
            onTap: () async {
              // _.db.deleteTable('tasks');
              var battery;
              battery = await RfidService.showRSSI();
              print('$battery dddddddd');

            },
            child: Center(
              child: Container(
                width: Get.width - 26,
                height: 90,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        Color.fromARGB(255, 38, 0, 144),
                        Color.fromARGB(193, 0, 0, 0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.2, 2.9],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width / 1.6,
                          child: Text(
                            'No of Sites',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                        Text(
                            '${_.uniqueSiteCount}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 28),
                          )
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/dashboard/purple-bg-images.svg',
                      height: 75,
                    )
                  ],
                ).marginOnly(left: 10),
              ).marginOnly(bottom: 10),
            ),
          ),
          Center(
            child: Container(
              width: Get.width - 30,
              height: 90,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color.fromARGB(255, 0, 135, 16),
                      Color.fromARGB(193, 0, 0, 0)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.2, 2.9],
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'No of Location',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                       Text(
                          '${_.selectDetails.length}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 28),
                        )

                    ],
                  ),
                  SvgPicture.asset(
                    'assets/images/dashboard/purple-bg-images.svg',
                    height: 75,
                  )
                ],
              ).marginOnly(left: 10),
            ).marginOnly(bottom: 10),
          ),
          Text(
            'AUDIT BY LAST SUMMARY',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
          ).marginOnly(left: 15, top: 15),
          chart(_),
          Container(
            height: 100,
            width: Get.width,
            color: Color.fromARGB(25, 158, 158, 158),
            child: Wrap(
              children: [
                Row(
                  children: [
                    Wrap(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.yellow,
                          ),
                        ),
                        Text('Check Out').marginOnly(left: 7),
                      ],
                    ).marginOnly(left: 35, top: 17),

                    Wrap(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.blue,
                          ),
                        ),
                        Text('Check In').marginOnly(left: 7),
                      ],
                    ).marginOnly(left: 35, top: 17),
                    Wrap(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color.fromARGB(255, 124, 225, 187),
                            // color: Colors.green
                          ),
                        ),
                        Text('Found').marginOnly(left: 7),
                      ],
                    ).marginOnly(left: 35, top: 17),
                  ],
                ),
                Row(children: [
                  Wrap(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            // color: Color.fromARGB(255, 159, 153, 139),
                            color: Colors.black
                        ),
                      ),
                      Text('Dispose').marginOnly(left: 7),
                    ],
                  ).marginOnly(left: 35, top: 17),
                  SizedBox(width: 13,),
                  Wrap(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            // color: Color.fromARGB(255, 159, 153, 139),
                            color: Colors.red
                        ),
                      ),
                      Text('Lost').marginOnly(left: 7),
                    ],
                  ).marginOnly(left: 35, top: 17),
                  SizedBox(width: 27),
                  Wrap(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            // color: Color.fromARGB(255, 159, 153, 139),
                            color: Colors.purple
                        ),
                      ),
                      Text('New').marginOnly(left: 7),
                    ],
                  ).marginOnly(left: 35, top: 17),
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }

  SfCircularChart chart(DashboardController _) {
    return SfCircularChart(
      series: <CircularSeries<ChartData, String>>[
        DoughnutSeries<ChartData, String>(
          dataSource: _.data,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          radius: '80%',
          explode: true,
          explodeGesture: ActivationMode.singleTap,
          explodeOffset: '5%',
          dataLabelMapper: (ChartData data, _) => data.isEmpty ? '0' : '${data.y.toInt()}',
          dataLabelSettings: const DataLabelSettings(
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            isVisible: true,
          ),
          name: 'Gold',
        )
      ],
    );
  }

  PreferredSize appbar(DashboardController _) {
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
          title: Center(
            child: InkWell(
              onTap: () {
                // _.db.delettte();
                // _.db.initializeDatabase();
                // Get.toNamed(Routes.import);
                // print(_.cheackOut.length);
                print(_.newAssets.length);
                // print(_.selectDetails);

              },
              child: Text(
                'HOME',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.scan);
              },
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: UIDataColors.commonColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                    child: Icon(
                  Icons.center_focus_strong_outlined,
                  size: 24,
                  color: Colors.white,
                )),
              ).marginOnly(right: 18),
            ),
          ],
        ),
      ),
    );
  }

  Drawer drawer(DashboardController _) {
    return Drawer(
        backgroundColor: UIDataColors.commonColor,
        width: Get.width / 1.5,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    Get.offAndToNamed(Routes.profile);
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                        // color: Color.fromARGB(141, 224, 224, 224),
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                        child: Image.asset(AppImage.logo4,
                      height: 70,
                      width: 60,
                      // color: Color.fromARGB(195, 246, 246, 246),
                    )),
                  ).marginOnly(top: 50),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'IjazKhan',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color.fromARGB(98, 255, 255, 255),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _.assetsCheck.toggle();
                },
                child: Row(
                  children: [
                    Text(
                      'Asset',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ).marginOnly(top: 20),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                    ).marginOnly(top: 20),
                  ],
                ),
              ),
              Obx(
                () => _.assetsCheck.value
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Get.offAndToNamed(Routes.addAsset);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color:
                                      const Color.fromARGB(170, 255, 255, 255),
                                ),
                                Text(
                                  'Add Asset',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ).marginOnly(left: 10)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Get.offAndToNamed(Routes.viewAssets);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 18,
                                  color:
                                      const Color.fromARGB(170, 255, 255, 255),
                                ),
                                Text(
                                  'View Assets',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ).marginOnly(left: 10)
                              ],
                            ).marginOnly(left: 3),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color.fromARGB(98, 255, 255, 255),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Get.offAndToNamed(Routes.scan);
                },
                child: Text(
                  'Assets Audit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Divider(
              //   color: Color.fromARGB(98, 255, 255, 255),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     Get.offAndToNamed(Routes.bluetooth);
              //   },
              //   child: Text(
              //     'My Devices',
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Divider(
              //   color: Color.fromARGB(98, 255, 255, 255),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     Get.offAndToNamed(Routes.scanHistory);
              //   },
              //   child: Text(
              //     'Scan History',
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Divider(
                color: Color.fromARGB(98, 255, 255, 255),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Get.offAndToNamed(Routes.import);
                },
                child: Text(
                  'Import/Export',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Divider(
              //   color: Color.fromARGB(98, 255, 255, 255),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     Get.toNamed(Routes.readWriteRfid);
              //   },
              //   child: Text(
              //     'Write RFID',
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color.fromARGB(98, 255, 255, 255),
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
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ).marginOnly(top: 10),
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
                                    color: Colors.white, fontSize: 16),
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
                                                    .withOpacity(_
                                                            .cs
                                                            .DatabaseStatus
                                                            .value
                                                        ? 1
                                                        : 0),
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
                                    color: Colors.white, fontSize: 16),
                              ).marginOnly(left: 10)
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color.fromARGB(98, 255, 255, 255),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: 'Log Out',
                    content: Text('Are you sure u want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          GetStorage box = GetStorage();
                          await box.remove('auth');
                          Get.offAllNamed(Routes.login);
                        },
                        child: Text('Log out'),
                      ),
                    ],
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                color: Color.fromARGB(98, 255, 255, 255),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.about);
                  // Get.toNamed(Routes.readWriteRfid);
                },
                child: Text(
                  'About Us',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                color: Color.fromARGB(98, 255, 255, 255),
              ),
              // InkWell(
              //   onTap: () {
              //     // Get.toNamed(Routes.readWriteRfid);
              //   },
              //   child: Text(
              //     'Contact Us',
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              // SizedBox(height: 10,),
              // Divider(
              //   color: Color.fromARGB(98, 255, 255, 255),
              // ),
              // InkWell(
              //   onTap: () {
              //     // Get.toNamed(Routes.readWriteRfid);
              //   },
              //   child: Text(
              //     ' Privacy Policy',
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              SizedBox(height: 20),
              Text('Version:17-Jun-2025(0.0.2)',style: TextStyle(color: Colors.white),),
              Text('EmergTech Pvt. Ltd.',style: TextStyle(color: Colors.white),),

            ],
          ).marginSymmetric(horizontal: 40),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color,this.isEmpty);

  final String x;
  final double y;
  final Color color;
  final bool isEmpty;
}

 