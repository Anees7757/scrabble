import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scrabble/res/navigate.dart';
import 'package:scrabble/views/login.dart';
import 'package:scrabble/views/play_game.dart';

import '../global.dart';
import '../shared_prefs/shared_prefs.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late Timer _timer;
  double _scale = 0.0;

  navigate() async {
    String userDataString = await DataSharedPreferences().getUser();
    if (userDataString != '') {
      userData = jsonDecode(userDataString);
    }
  }

  @override
  void initState() {
    super.initState();
    navigate();
    _timer = Timer(const Duration(seconds: 3), () {
      navigateAndReplace(
          context: context,
          page: userData.isEmpty ? const Login() : const PlayGame());
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0.0, end: _scale),
          curve: Curves.easeInOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Image.asset(
            'assets/images/logo.png',
            width: 150,
          ),
        ),
      ),
    );
  }
}
