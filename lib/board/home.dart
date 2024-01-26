import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/res/innerShadow.dart';
import 'package:scrabble/res/navigate.dart';
import 'package:scrabble/views/play_game.dart';

import '../api/api_handler.dart';
import '../data/dictionary.dart';
import '../data/points.dart';
import '../data/tiles.dart';
import '../global.dart';
import '../provider/home_provider.dart';
import 'currentTiles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getTiles();
    context.read<HomeProvider>().startTimer();
    //Isolate.spawn((message) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      dynamic moves = ApiHandler.instance.getTurns(gameDetails['id']);
      print(await moves);
      if (await moves != null) {
        // ignore: use_build_context_synchronously
        context.read<HomeProvider>().getMoves(await moves);
      }
    });
    //}, message);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   while (true) {
  //     ApiHandler.instance.getTurns(gameDetails['id']);
  //   }
  // }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Image.asset(
              'assets/images/logo.png',
              width: 120,
            ),
            actions: [
              IconButton(
                color: Colors.white,
                onPressed: () async {
                  navigateAndReplace(context: context, page: const PlayGame());
                  var res =
                      await ApiHandler.instance.endGame(gameDetails['id']);
                  print(res);
                  homeProvider.clearVariables();
                },
                icon: const Icon(Icons.exit_to_app_rounded, size: 32),
              ),
              const SizedBox(width: 5),
            ],
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          // height: 250,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 140,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: homeProvider.myTurn
                                      ? Colors.amber
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xffDC7D26),
                                              width: 5.0),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade200,
                                          radius: 25,
                                          backgroundImage: const AssetImage(
                                              'assets/images/avatar.png'),
                                          foregroundImage: NetworkImage(
                                            '$baseUrl\\images\\${userData['image']}',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        userData['username'],
                                        style: TextStyle(
                                          color: homeProvider.myTurn
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      Text('${homeProvider.points}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                            color: homeProvider.myTurn
                                                ? Colors.black
                                                : Colors.white,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 140,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: !homeProvider.myTurn
                                      ? Colors.amber
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xffDC7D26),
                                              width: 5.0),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade200,
                                          radius: 25,
                                          backgroundImage: const AssetImage(
                                              'assets/images/avatar.png'),
                                          foregroundImage: NetworkImage(
                                            '$baseUrl\\images\\${opponentDetails['image']}',
                                          ),
                                        ),
                                      ),
                                      Text(opponentDetails['username'],
                                          style: TextStyle(
                                            color: !homeProvider.myTurn
                                                ? Colors.black
                                                : Colors.white,
                                          )),
                                      Text('${homeProvider.opponentPoints}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                            color: !homeProvider.myTurn
                                                ? Colors.black
                                                : Colors.white,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xffDC7D26),
                              width: 5.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              homeProvider.timer.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: InteractiveViewer(
                        panEnabled: true,
                        panAxis: PanAxis.free,
                        minScale: 1,
                        maxScale: 1.5,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 15,
                                  mainAxisSpacing: 2.5,
                                  crossAxisSpacing: 2.5,
                                ),
                                itemCount: tiles.length * tiles[0].length,
                                itemBuilder: (context, index) {
                                  return DragTarget(builder:
                                      (BuildContext context,
                                          List<Object?> candidateData,
                                          List<dynamic> rejectedData) {
                                    return tiles[index % 15][index ~/ 15];
                                  }, onAccept: (int i) {
                                    if (homeProvider.myTurn) {
                                      if (homeProvider
                                              .currentTiles[i].isAdded !=
                                          true) {
                                        // if (homeProvider.openingMove != true) {
                                        homeProvider.recentTile =
                                            homeProvider.currentTiles[i].txt;

                                        homeProvider.addTile(
                                            index % 15, index ~/ 15, i);
                                        // } else {
                                        //   homeProvider.addTile(8, 8, i);
                                        //   homeProvider.openingMove = false;
                                        // }
                                      }
                                    }
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 0.0,
            color: const Color.fromARGB(255, 5, 43, 24),
            height: 150,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: homeProvider.currentTiles.length,
                      itemBuilder: (context, index) {
                        return Draggable(
                          data: index,
                          feedback:
                              homeProvider.currentTiles[index].isAdded != true
                                  ? CurrentTiles(
                                      txt: homeProvider.currentTiles[index].txt)
                                  : const SizedBox(),
                          childWhenDragging: CurrentTiles(txt: ''),
                          child:
                              homeProvider.currentTiles[index].isAdded != true
                                  ? CurrentTiles(
                                      txt: homeProvider.currentTiles[index].txt)
                                  : CurrentTiles(txt: ''),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  //color: Colors.amber,
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 35,
                        child: InnerShadow(
                          color: Colors.white,
                          blurX: 1,
                          blurY: 2,
                          offset: const Offset(0, 3),
                          child: FloatingActionButton.extended(
                            heroTag: "btn1",
                            backgroundColor: Colors.amber,
                            elevation: 0.0,
                            onPressed: () => homeProvider.resetTimer,
                            label: const Text('Pass'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        child: InnerShadow(
                          color: Colors.white,
                          blurX: 1,
                          blurY: 2,
                          offset: const Offset(0, 3),
                          child: FloatingActionButton.extended(
                            heroTag: "btn2",
                            backgroundColor: Colors.amber,
                            elevation: 0.0,
                            onPressed: () => homeProvider.submit(context),
                            label: const Text('Submit'),
                          ),
                        ),
                      ),
                      IconButton(
                        color: Colors.white,
                        onPressed: () => homeProvider.undoTiles(),
                        icon: const Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                            size: 40),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/bag.png'),
                          Padding(
                            padding: const EdgeInsets.only(top: 13),
                            child: Text('${homeProvider.remainingTiles}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
