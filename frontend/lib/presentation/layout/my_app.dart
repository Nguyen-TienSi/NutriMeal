import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/core/app_config.dart';
import 'package:nutriai_app/presentation/views/onboarding/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
            primarySwatch: Colors.green,
            useMaterial3: true,
          ),
          builder: (context, child) => LayoutBuilder(
            builder: (context, constraints) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0.sp),
                ),
                child: child!,
              );
            },
          ),
          home: child,
        );
      },
      child: const OnboardingScreen(),
    );
  }
}
