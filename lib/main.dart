// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:floraheart/Controllers/period_controller.dart';
import 'package:floraheart/Controllers/today_controller.dart';
import 'package:floraheart/Controllers/today_data_controller.dart';
import 'package:floraheart/Services/notification_service.dart';
import 'package:floraheart/config/Routes/routes.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:floraheart/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  print("Starting Firebase init...");
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized SUCCESSFULLY!");
  } catch (e) {
    print("Firebase Init Error: $e");
  }

  // Initialize controllers
  Get.put(TodayDataController(), permanent: true);
  final periodCtrl = Get.put(PeriodController(), permanent: true);
  await periodCtrl.loadPeriod(); 
  
  // Initialize TodayController for notifications
  Get.put(TodayController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      // home: SplashScreen(),
      initialRoute: AppRoutesName.splash, // start from splash

      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      getPages: AppRoutes.routes(),
      // initialRoute: AppRoutesName.authgate,
    );
  }
}
