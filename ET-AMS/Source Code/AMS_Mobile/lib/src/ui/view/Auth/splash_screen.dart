import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/controllers/login_controller.dart';
import 'package:get/get.dart';

import '../../../utils/routes/routes.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    Get.lazyPut(()=>LoginScreenController());

    // Timer(Duration(seconds: 3), () {
    //   Get.toNamed(Routes.login);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: Image.asset("assets/images/logos/emergtech_logo.png",
            height: 150,
            width: 250,),
          ),
          // SizedBox(
          //   height: 30,
          // ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.black,
                  height: 90,
                  width: 2,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assets",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Management",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "System",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 70,
          ),
          Text(
            "VERSION: 0.0.2",
            style: TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
          ),

          // Center(child: LottieBuilder.asset("assets/Lottie/Animation - 1715594393337.json"),),
        ],
      ),
      nextScreen: LogIn(),
      splashIconSize: 420,
      duration: 100,
      backgroundColor: Colors.white,
    );
  }
}
