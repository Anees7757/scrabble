import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/api/api_handler.dart';
import 'package:scrabble/provider/login_provider.dart';
import 'package:scrabble/res/custom_widgets/custom_textfield.dart';
import 'package:scrabble/res/innerShadow.dart';
import 'package:scrabble/res/navigate.dart';
import 'package:scrabble/views/play_game.dart';
import 'package:scrabble/views/signup.dart';

import '../res/custom_widgets/custom_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
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
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    onPressed: () {
                      ref.login(context);
                    },
                    buttonText: 'Login',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an Account?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        navigateTo(context: context, page: const Signup());
                      },
                      child: const Text(
                        'Signup',
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
        );
      },
    );
  }
}
