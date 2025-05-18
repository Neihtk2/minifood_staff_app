import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/routes/app_routes.dart';
import 'package:minifood_staff/core/services/fcm_service.dart';
import 'package:minifood_staff/data/sources/remote/api_service.dart';
import 'package:minifood_staff/modules/views/shipping/controller/shipping_controller.dart';

import 'core/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FCMService.initialize();
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.subscribeToTopic('all');
  await GetStorage.init();
  Get.put(ApiService());
  // Get.put(ShippingController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 915),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouterName.LOGIN,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
