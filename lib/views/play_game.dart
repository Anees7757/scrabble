import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scrabble/api/api_handler.dart';
import 'package:scrabble/board/home.dart';
import 'package:scrabble/global.dart';
import 'package:scrabble/res/navigate.dart';
import 'package:scrabble/shared_prefs/shared_prefs.dart';
import 'package:scrabble/views/waiting.dart';

import '../data/dictionary.dart';
import '../res/button_animation.dart';

class PlayGame extends StatefulWidget {
  const PlayGame({super.key});

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  @override
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            'assets/images/logo.png',
            width: 120,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffDC7D26), width: 2.0),
              ),
              child: CircleAvatar(
                backgroundImage: const AssetImage('assets/images/avatar.png'),
                foregroundImage: NetworkImage(
                  '$baseUrl\\images\\${userData['image']}',
                ),
                radius: 18,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/scrabble.png',
                  width: 250,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              PoppingImage(
                initialSize: 190,
                imageUrl: 'assets/images/play_btn.png',
                finalSize: 140,
                onTap: () async {
                  getDictionary();
                  dynamic result =
                      await ApiHandler.instance.checkGame(userData['username']);
                  if (result['statusCode'] == 201) {
                    dynamic res = await ApiHandler.instance
                        .createGame(userData['username']);

                    print(res);
                    if (res['statusCode'] == 200) {
                      print(res['data']['game_data']);
                      gameDetails = res['data']['game_data'];
                      // ignore: use_build_context_synchronously
                      navigateTo(context: context, page: const Waiting());
                    }
                  } else if (result['statusCode'] == 200) {
                    print(result['data']['game_data']);
                    gameDetails = result['data']['game_data'];
                    // ignore: use_build_context_synchronously
                    navigateTo(context: context, page: const Waiting());
                  }
                },
              ),
              PoppingImage(
                initialSize: 130,
                imageUrl: 'assets/images/quit_btn.png',
                finalSize: 100,
                onTap: () {
                  exit(0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
