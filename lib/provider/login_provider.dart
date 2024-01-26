import 'package:flutter/material.dart';
import 'package:scrabble/res/custom_widgets/loading_dialog.dart';

import '../api/api_handler.dart';
import '../res/navigate.dart';
import '../views/play_game.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, 'Logging in...');
    dynamic result = await ApiHandler.instance
        .login(emailController.text, passwordController.text);

    if (result['success'] == true) {
      final snackBar = SnackBar(
        content: Text(result['message']),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ignore: use_build_context_synchronously
      navigateAndReplace(context: context, page: const PlayGame());
      emailController.clear();
      passwordController.clear();
    } else {
      print(result);
      final snackBar = SnackBar(
        content: Text(result['error']),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ignore: use_build_context_synchronously
      LoadingDialog.hideLoadingDialog(context);
    }
  }
}
