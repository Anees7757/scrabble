import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:scrabble/res/innerShadow.dart';
import '../data/points.dart';
import '../provider/home_provider.dart';

// ignore: must_be_immutable
class CurrentTiles extends StatelessWidget {
  String txt;
  bool isAdded;

  CurrentTiles({super.key, required this.txt, this.isAdded = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return InnerShadow(
        offset: const Offset(-1, 1),
        blurX: 0.5,
        blurY: 0.5,
        color: const Color.fromARGB(255, 229, 229, 229).withOpacity(.25),
        child: InnerShadow(
          offset: (isAdded == true || txt == '')
              ? const Offset(0, 0.5)
              : const Offset(1, -1.5),
          blurX: (isAdded == true || txt == '') ? 0.8 : 1,
          blurY: (isAdded == true || txt == '') ? 0.7 : 1,
          color: Colors.black.withOpacity(.25),
          child: Container(
            margin: const EdgeInsets.fromLTRB(3, 8, 3, 10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: (isAdded == true || txt == '')
                  ? const Color.fromARGB(255, 255, 227, 160)
                  : const Color(0xfffaeac2),
              borderRadius: const BorderRadius.all(Radius.elliptical(8, 6)),
            ),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: txt.toUpperCase(),
                  style: GoogleFonts.nunitoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.2, top: 7),
                        child: Text(
                          txt != ''
                              ? ' ${letterPoints[txt.toUpperCase()]}'
                              : '',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 8,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontFeatures: [
                              const FontFeature.subscripts(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
