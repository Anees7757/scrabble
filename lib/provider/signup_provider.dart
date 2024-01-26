import 'package:flutter/material.dart';
import 'package:scrabble/res/navigate.dart';

import '../views/choose_photo.dart';

class SingupProvider extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  next(BuildContext context) {
    if (emailController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      navigateTo(
          context: context,
          page: ChoosePhoto(
            email: emailController.text,
            password: passwordController.text,
            username: usernameController.text,
          ));

      emailController.clear();
      usernameController.clear();
      passwordController.clear();
    } else {
      final snackBar = SnackBar(
        content: Text('Please enter data'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    notifyListeners();
  }
}
