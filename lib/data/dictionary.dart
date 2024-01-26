import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

List<String> words = ['ab', 'ad', 'cn', 'aa', 'bag'];

Future getDictionary() async {
  String data = await rootBundle.loadString('assets/dictionary.txt');
  words.addAll(data.split('\n'));
  words.where((element) => element == "");
}
