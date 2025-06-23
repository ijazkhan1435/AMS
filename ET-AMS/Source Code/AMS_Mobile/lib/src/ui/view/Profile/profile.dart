import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ui/widgets/commonBtn.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/utils/uidata/appImages.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 230,
              width: Get.width,
              color: UIDataColors.commonColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.4),
                            spreadRadius: 4.0,
                            blurRadius: 35.0,
                            offset: Offset(0.0, 10.0),
                          ),
                        ],
                        color: Colors.grey.shade50,
                        // color: Color.fromARGB(255, 166, 145, 189),
                        borderRadius: BorderRadius.circular(60)),
                    child: Center(
                        child: Image.asset(AppImage.logo4,
                        height: 90,
                          width: 90,
                        )
                    //     Icon(
                    //   Icons.person,
                    //   size: 80,
                    //   color: Color.fromARGB(141, 246, 246, 246),
                    // )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Ijaz Khan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ).marginOnly(top: 10)
                ],
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: Get.width / 2.3,
                    child: TextFormFildWidgets(title: 'Ijaz')),
                SizedBox(
                    width: Get.width / 2.3,
                    child: TextFormFildWidgets(title: 'Khan'))
              ],
            ).marginSymmetric(horizontal: 15),
            SizedBox(height: 30,),

            TextFormFildWidgets(title: 'Salesmen')
                .marginSymmetric(horizontal: 15),
            SizedBox(height: 30,),

            TextFormFildWidgets(title: '0300000000')
                .marginSymmetric(horizontal: 15),
            SizedBox(height: 30,),

            TextFormFildWidgets(title: 'Ijaz@gmail.com')
                .marginSymmetric(horizontal: 15),
            SizedBox(height: 30,),

            CommonBtn(title: 'UPDATE',
            onPressd: (){Get.toNamed(Routes.dashboard);
            },
            ),
            SizedBox(height: 30,),



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
            'PROFILE',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
