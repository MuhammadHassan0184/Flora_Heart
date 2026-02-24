
import 'package:floraheart/View/Auth/login_screen.dart';
import 'package:floraheart/View/Auth/signup_screen.dart';
import 'package:floraheart/View/Blogs/all_blogs_screen.dart';
import 'package:floraheart/View/Blogs/blogs_detail_screen.dart';
import 'package:floraheart/View/Calendar/calendar_screen.dart';
import 'package:floraheart/View/detail/today_screen.dart';
import 'package:floraheart/View/DashBoard/home_screen.dart';
import 'package:floraheart/View/DashBoard/main_screen.dart';
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
    GetPage(name: AppRoutesName.mainScreen, page: ()=> MainScreen()),
    GetPage(name: AppRoutesName.homeScreen, page: ()=> HomeScreen()),
    GetPage(name: AppRoutesName.calendarScreen, page: ()=> CalendarScreen()),
    GetPage(name: AppRoutesName.todayScreen, page: ()=> TodayScreen()),
    GetPage(name: AppRoutesName.allBlogsScreen, page: ()=> AllBlogsScreen()),
    GetPage(name: AppRoutesName.blogsDetailScreen, page: ()=> BlogsDetailScreen()),
  ];
}