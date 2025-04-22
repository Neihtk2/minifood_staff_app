import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/data/sources/remote/api_service.dart';
import 'package:minifood_admin/modules/views/cart/cart_controller.dart';
import 'package:minifood_admin/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_admin/modules/views/order/order_controller.dart';
import 'package:minifood_admin/modules/views/profile/profile_controller.dart';

import 'core/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ApiService());
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
      designSize: const Size(575, 812),
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
