
import 'package:floraheart/View/Auth/login_screen.dart';
import 'package:floraheart/View/Auth/signup_screen.dart';
import 'package:floraheart/View/OnBoarding/Wrapper/onboarding_wrapper.dart';
import 'package:floraheart/View/Splash/splash_screen.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static routes() => [
    GetPage(
      name: AppRoutesName.onboarding, page: () => OnboardingScreen(),),
    GetPage(name: AppRoutesName.splash, page: ()=> SplashScreen()),
    GetPage(name: AppRoutesName.loginScreen, page: ()=> LoginScreen()),
    GetPage(name: AppRoutesName.signupScreen, page: ()=> SignupScreen()),
    // GetPage(name: AppRoutesName.nameScreen, page: ()=> NameScreen(onNext: () {  },)),
  ];
}