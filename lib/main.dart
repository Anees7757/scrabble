import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/provider/login_provider.dart';
import 'package:scrabble/provider/signup_provider.dart';
import 'package:scrabble/views/splash.dart';

import 'board/home.dart';
import 'data/dictionary.dart';
import 'provider/choose_photo_provider.dart';
import 'provider/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => SingupProvider()),
        ChangeNotifierProvider(create: (context) => ChoosePhotoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 5, 43, 24),
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
        home: const Splash(),
      ),
    );
  }
}
