import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ui/view/languages.dart';
import 'package:flutter_application_1/src/utils/routes/app_pages.dart';
import 'package:get/get.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      translations: Languages(),
      locale: Locale('en','US'),
      fallbackLocale: Locale('en','US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // fontFamily: 'Popins',
          ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // onUnknownRoute: (RouteSettings rs) => MaterialPageRoute(
      //   builder: (context) {
      //     return ErrorView(
      //         // message: 'Coming Soon!',
      //         );
      //   },
      // ),

    );
  }
}
