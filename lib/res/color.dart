import 'package:flutter/material.dart';

Color getTileColor(dynamic tile, bool isEmpty) {
  if (tile is String) {
    switch (tile) {
      case 'TW':
        return const Color(0xfff01c7a);
      case 'DW':
        return const Color(0xfffd8e73);
      case 'TL':
        return const Color(0xff1375b0);
      case 'DL':
        return const Color(0xff8ecafc);
      default:
        return const Color(0xffe7eaef);
    }
  } else if (tile is IconData) {
    return const Color(0xfffd8e73);
  }
  if (isEmpty != true) {
    return const Color(0xfffaeac2);
  }
  return const Color(0xffe7eaef);
}
