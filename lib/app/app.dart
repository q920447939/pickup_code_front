import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/app/bindings/app_bindings.dart';
import 'package:pickup_code_front/app/routes/app_pages.dart';
import 'package:pickup_code_front/app/theme/app_theme.dart';

class PickupApp extends StatelessWidget {
  const PickupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Pickup Code',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialBinding: AppBindings(),
          initialRoute: AppPages.initial,
          getPages: AppPages.pages,
          builder: (context, widget) => widget ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
