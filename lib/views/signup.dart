import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/res/navigate.dart';
import 'package:scrabble/views/choose_photo.dart';
import 'package:scrabble/views/login.dart';

import '../provider/signup_provider.dart';
import '../res/custom_widgets/custom_button.dart';
import '../res/custom_widgets/custom_textfield.dart';
import '../res/innerShadow.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SingupProvider>(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Image.asset(
              'assets/images/logo.png',
              width: 120,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  customTextField(
                      controller: ref.usernameController, hintText: 'Username'),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                      controller: ref.emailController, hintText: 'Email'),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                      controller: ref.passwordController, hintText: 'Password'),
                  const SizedBox(
                    height: 50,
                  ),
                  InnerShadow(
                    color: Colors.white,
                    blurY: 5,
                    blurX: 0,
                    offset: const Offset(0, 3),
                    child: Custom3DButton(
                      onPressed: () => ref.next(context),
                      buttonText: 'Next',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an Account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateAndReplace(
                              context: context, page: const Login());
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
