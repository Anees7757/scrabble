import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrabble/board/home.dart';
import 'package:scrabble/res/navigate.dart';

import '../api/api_handler.dart';
import '../global.dart';

class Waiting extends StatefulWidget {
  const Waiting({Key? key}) : super(key: key);

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  bool opponentJoining = false;
  dynamic result;
  bool? continueWatching;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (pop) {
        ApiHandler.instance.endGame(gameDetails['id']);
        continueWatching = false;
      },
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.pop(context);
                var res = await ApiHandler.instance.endGame(gameDetails['id']);
                print(res);
              }),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildPlayerInfo(userData['username'], 'assets/images/avatar.png'),
              opponentJoining
                  ? const Text(
                      'Match is being Started',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : buildMatchingAnimation(),
              const SizedBox(
                height: 20,
              ),
              result != null ? buildOpponentInfo() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPlayerInfo(String playerName, String imageUrl) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xffDC7D26), width: 3.0),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: const AssetImage('assets/images/avatar.png'),
            foregroundImage: NetworkImage(
              '$baseUrl\\images\\${userData['image']}',
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          playerName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildMatchingAnimation() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          size: 50,
          color: Colors.white,
        ),
        SizedBox(width: 7),
        Text(
          'Waiting for another player to join...',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildOpponentInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: opponentJoining ? 150 : 0,
      child: Opacity(
        opacity: opponentJoining ? 1.0 : 0.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffDC7D26), width: 3.0),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/avatar.png'),
                foregroundImage: NetworkImage(
                  '$baseUrl\\images\\${opponentDetails['image']}',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${opponentDetails['username']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkPlayerJoined();
  }

  late Timer _timer;

  Future<void> checkPlayerJoined() async {
    continueWatching = true;
    //_timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    while (continueWatching!) {
      result = await ApiHandler.instance.playerjoined(gameDetails['id']);
      opponentJoining = false;
      print(result);
      if (result['joined']) {
        if (result['player_1'] == userData['username']) {
          getOpponentDetails(result['player_2']);
        } else {
          getOpponentDetails(result['player_1']);
        }
        continueWatching = false;
        opponentJoining = true;
        break;
      }
    }
    if (!continueWatching! && opponentJoining) {
      // _timer.cancel();
      setState(() {});
      // ignore: use_build_context_synchronously
      Future.delayed(const Duration(seconds: 5), () {
        navigateAndReplace(context: context, page: const HomePage());
      });
    }
    // });
  }

  Future<void> getOpponentDetails(String username) async {
    opponentDetails = await ApiHandler.instance.getOpponentDetails(username);
  }
}
