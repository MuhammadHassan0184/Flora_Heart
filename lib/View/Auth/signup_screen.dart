import 'package:floraheart/View/Widgets/custom_button.dart';
import 'package:floraheart/View/Widgets/custom_form_field.dart';
import 'package:floraheart/View/Widgets/custom_google_login.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:floraheart/config/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
   final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🌸 Top Left Pink Drops
          Positioned(
            top: size.height * 0.06,
            left: size.width * 0.05,
            child: SvgPicture.asset(
              "assets/PinkDrops.svg",
              width: size.width * 0.16,
            ),
          ),

          /// 🌸 Bottom Right Pink Flower
          Positioned(
            bottom: -25,
            right: 0,
            child: SvgPicture.asset(
              "assets/PinkFlower.svg",
              width: size.width * 0.40,
            ),
          ),

          /// 🔹 Your Existing UI
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),

                  Center(
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),

                  SizedBox(height: 7),

                  Text(
                    "Sign up to access your profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  SizedBox(height: 40),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      label: "Email Address",
                      hintText: "Enter Your Email",
                      controller: emailController,
                    ),
                  ),


                  SizedBox(height: 15),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      label: "Password",
                      hintText: "••••••••",
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ),
                  SizedBox(height: 15),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextFormField(
                      label: "Confirm Password",
                      hintText: "••••••••",
                      controller: passwordController,
                      isPassword: true,
                    ),
                  ),
                  SizedBox(height: 25),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(label: "Sign Up", ontap: () {
                      Get.toNamed(AppRoutesName.loginScreen);
                    }, ),
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
                          Get.toNamed(AppRoutesName.loginScreen);
                        },
                        child: Text(
                          "Sign In",
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

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomGoogleLogin(label: "Google"),
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
