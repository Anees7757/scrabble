import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/provider/choose_photo_provider.dart';
import 'package:scrabble/res/custom_widgets/custom_button.dart';

import '../res/innerShadow.dart';

class ChoosePhoto extends StatefulWidget {
  String username;
  String email;
  String password;
  ChoosePhoto(
      {super.key,
      required this.email,
      required this.password,
      required this.username});

  @override
  State<ChoosePhoto> createState() => _ChoosePhotoState();
}

class _ChoosePhotoState extends State<ChoosePhoto> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChoosePhotoProvider>(builder: (context, ref, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            'assets/images/logo.png',
            width: 120,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Choose Profile Photo',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  ref.showBottomSheet(context);
                },
                child: Center(
                  child: ref.image != null
                      ? Container(
                          height: 350,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(ref.image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 350,
                          width: 350,
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.grey.shade700,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Opacity(
                opacity: (ref.image != null) ? 1.0 : 0.0,
                child: InnerShadow(
                  color: Colors.white,
                  blurY: 5,
                  blurX: 0,
                  offset: const Offset(0, 3),
                  child: Custom3DButton(
                    onPressed: () {
                      if (ref.image != null) {
                        ref.signup(
                            context: context,
                            username: widget.username,
                            email: widget.email,
                            password: widget.password);
                      }
                    },
                    buttonText: 'Signup',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
