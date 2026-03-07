import 'package:floraheart/Controllers/Auth_controller/google_controller.dart';
import 'package:floraheart/Controllers/Auth_controller/login_controller.dart';
import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/View/Widgets/custom_form_field.dart';
import 'package:floraheart/View/Widgets/custom_google_login.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = LoginController();

  @override
  void initState() {
    super.initState();

    // // connect UI controllers to LoginController
    // controller.emailController = TextEditingController();
    // controller.passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.06,
            left: size.width * 0.05,
            child: SvgPicture.asset(
              "assets/PinkDrops.svg",
              width: size.width * 0.16,
            ),
          ),

          Positioned(
            bottom: -25,
            right: 0,
            child: SvgPicture.asset(
              "assets/PinkFlower.svg",
              width: size.width * 0.40,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),

                  Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),

                  SizedBox(height: 7),

                  Text(
                    "Sign In to access your profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  SizedBox(height: 40),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      label: "Email Address",
                      hintText: "Enter Your Email",
                      controller: controller.emailController,
                    ),
                  ),

                  SizedBox(height: 15),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      label: "Password",
                      hintText: "••••••••",
                      controller: controller.passwordController,
                      isPassword: true,
                    ),
                  ),

                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutesName.forgotPasswordScreen);
                            // GetPage(
                            //   name: '/forgot-password',
                            //   page: () => ForgotPasswordScreen(),
                            // );
                          },
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                              color: AppColors.grey, // use primary instead of grey
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      label: "Sign In",
                      ontap: () {
                        controller.login(context);
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutesName.signupScreen);
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or Sign in with",
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: CustomGoogleLogin(label: "Google"),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomGoogleLogin(
                      label: "Google",
                      onTap: () {
                        GoogleLoginController().signInWithGoogle(context);
                      },
                    ),
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
