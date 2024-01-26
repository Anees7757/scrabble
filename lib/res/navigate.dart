import 'package:flutter/material.dart';

void navigateTo({required BuildContext context, required Widget page}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void navigateAndReplace({required BuildContext context, required Widget page}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
