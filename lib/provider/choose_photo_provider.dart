import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrabble/api/api_handler.dart';
import 'package:scrabble/res/navigate.dart';
import 'package:scrabble/views/login.dart';

import '../models/user.dart';
import '../res/custom_widgets/loading_dialog.dart';

class ChoosePhotoProvider extends ChangeNotifier {
  File? image;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: 6,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              ListTile(
                onTap: () {
                  pickImageFromGallery();
                  Navigator.pop(context);
                },
                title: Text(
                  'Select Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                trailing: Icon(
                  Icons.photo_album_outlined,
                  color: Colors.grey.shade800,
                  size: 30,
                ),
              ),
              const Divider(
                height: 0,
              ),
              ListTile(
                onTap: () {
                  pickImageFromCamera();
                  Navigator.pop(context);
                },
                title: Text(
                  'Capture Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                trailing: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.grey.shade800,
                  size: 30,
                ),
              ),
              const Divider(
                height: 0,
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          );
        });
  }

  signup({context, username, email, password}) async {
    try {
      if (image != null) {
        LoadingDialog.showLoadingDialog(context, 'Signing up...');

        User user = User(
            username: username,
            email: email,
            password: password,
            image: image!);

        int statusCode = await ApiHandler.instance.addUser(user);

        if (statusCode == 201) {
          final snackBar = SnackBar(
            content: Text('Signup successful!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          navigateAndReplace(context: context, page: const Login());
          image = null;
        }
      }
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      final snackBar = SnackBar(
        content: Text('$e'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    notifyListeners();
  }
}
