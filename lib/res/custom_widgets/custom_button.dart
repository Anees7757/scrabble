import 'package:flutter/material.dart';

class Custom3DButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  Custom3DButton({required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          primary: Colors.amber,
          shape: const StadiumBorder(),
          elevation: 10,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
