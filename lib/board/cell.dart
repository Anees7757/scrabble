import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/points.dart';
import '../provider/home_provider.dart';
import '../res/color.dart';
import '../res/innerShadow.dart';

// ignore: must_be_immutable
class Cell extends StatelessWidget {
  bool isTW;
  bool isTL;
  bool isDW;
  bool isDL;
  bool isEmpty;
  IconData? icon;
  String txt;

  Cell(
      {super.key,
      required this.isTW,
      required this.isTL,
      required this.isDW,
      required this.isDL,
      this.isEmpty = true,
      required this.txt,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return InnerShadow(
        offset: isEmpty != true ? const Offset(1, -1) : const Offset(0, 0.5),
        blurX: 0.8,
        blurY: isEmpty != true ? 1 : 0.7,
        color: Colors.black.withOpacity(.25),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: isEmpty != true
                ? const Color(0xfffaeac2)
                : getTileColor((icon != null) ? icon : txt, isEmpty),
            borderRadius: const BorderRadius.all(Radius.elliptical(6, 4)),
          ),
          child: Center(
            child: isEmpty
                ? (icon != null && txt == '')
                    ? Icon(icon, color: Colors.white, size: 12)
                    : Text(
                        txt,
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 5,
                          color: Colors.white,
                        ),
                      )
                : RichText(
                    text: TextSpan(
                      text: txt.toUpperCase(),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                      // children: [
                      //   WidgetSpan(
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(left: 0.1, top: 4),
                      //       child: Text(
                      //         txt != ''
                      //             ? ' ${letterPoints[txt.toUpperCase()]}'
                      //             : '',
                      //         style: GoogleFonts.nunitoSans(
                      //           fontSize: 7,
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.w700,
                      //           fontFeatures: [
                      //             const FontFeature.subscripts(),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
