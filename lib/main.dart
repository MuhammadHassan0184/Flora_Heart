// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:floraheart/config/Routes/routes.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:floraheart/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// final todayDataController = Get.put(TodayDataController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Starting Firebase init...");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized SUCCESSFULLY!");
  } catch (e) {
    print("Firebase Init Error: $e");
  }

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
