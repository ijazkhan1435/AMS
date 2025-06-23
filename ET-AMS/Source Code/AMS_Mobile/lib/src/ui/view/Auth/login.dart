import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/login_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/commonBtn.dart';
import 'package:flutter_application_1/src/utils/routes/routes.dart';
import 'package:flutter_application_1/src/ui/widgets/container_widget.dart';
import 'package:flutter_application_1/src/ui/widgets/textformfild_widgets.dart';
import 'package:flutter_application_1/src/utils/uidata/color.dart';
import 'package:get/get.dart';

import '../../../utils/uidata/appImages.dart';
import '../../../utils/uidata/color.dart';
import '../../../utils/uidata/color.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    LoginScreenController _ = Get.find<LoginScreenController>();
    return Scaffold(
      backgroundColor: UIDataColors.commonColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: Get.height/3.5,
                color: UIDataColors.commonColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Asset Management System",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
                    // Text("AMS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                  ],
                )),
            Container(
              width: Get.width,
              height: Get.height/1.3,
              // color: Colors.white,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset("assets/images/logos/emergtech_logo.png",
                      height: Get.height/14,
                      width: Get.width/2,
                      // height: MediaQuery.of(context).size.height*0.2,
                      // width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(height: 10,),
                    Text("Login",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color:UIDataColors.commonColor)),
                TextFormFildWidgets(

                            txtcontroller: _.email,
                    focusNode: _.emailFocusNode,
                            title: 'Email ID',
                            iconButton: IconButton(onPressed: (){},  icon:  const Icon(Icons.email,color: Colors.grey,))),

                        SizedBox(height: 10,),
                        TextFormFildWidgets(
                            txtcontroller: _.password,
                            focusNode: _.passwordFocusNode,
                            title: 'Password',
                            iconButton: IconButton(onPressed: (){},  icon: const Icon(Icons.lock,color: Colors.grey,))),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Please Enter Your Credentials to get Access',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.ipConfig);
                              },
                              child: Text(
                                'Server Connectivity',
                                style: TextStyle(
                                  color: UIDataColors.commonColor,
                                  fontSize: 14,
                                ),
                              )),
                        ),
                        SizedBox(height: 20,),


                    // Obx(()=>_.loginCheck.value
                    //       ? Center(child: CircularProgressIndicator())
                    //       : CommonBtn(
                    //     title: 'Login',
                    //     onPressd: () {
                    //       _.submit(_.email.text, _.password.text);
                    //     },
                    //   )
                    // ),

                    CommonBtn(
                      title: 'Login',
                      onPressd: () {
                        _.logIn();
                        // _.submit(_.email.text, _.password.text);
                      },
                    ),

                    // TextButton(
                        //     onPressed: () {
                        //       Get.toNamed(Routes.signUp);
                        //     },
                        //     child: Text(
                        //       "Dont Have ant Account? SignUp",
                        //       style: TextStyle(
                        //         decoration: TextDecoration.underline,
                        //         color: Color(0xff4c505b),
                        //         fontSize: 18,
                        //       ),
                        //
                        //     )),
                        SizedBox(height: 15,),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Text('Release:17-Jun-2025(0.0.2)',style: TextStyle(color: UIDataColors.commonColor),)),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(AppImage.logo4,
                        //     height: Get.height/12,
                        //     width: Get.width/10),

                        Text('EmergTech Pvt.Ltd.',style: TextStyle(color: UIDataColors.commonColor,),),
                      ],
                    ),
                  ],
                 ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
