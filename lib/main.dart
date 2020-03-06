import 'package:flutter/material.dart';
import 'package:flutter_quote_app/pages/loading.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_quote_app/services/constants.dart';
import 'package:flutter_quote_app/util/quote.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Quote>(QuoteAdapter());
  await Hive.openBox<Quote>(Constants.QUOTE_BOX);
  await Hive.openBox(Constants.SETTINGS_BOX);

  final box = Hive.box(Constants.SETTINGS_BOX);

  runApp(ValueListenableBuilder(
    valueListenable: Hive.box(Constants.SETTINGS_BOX).listenable(keys: ['darkMode']),
    builder:(context, box, index){ return MaterialApp(
      themeMode: box.get('darkMode', defaultValue: false)
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData(
        fontFamily: 'Courgette',
        brightness: Brightness.dark
      ),
      debugShowCheckedModeBanner: false,
      home: Loading(),
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Courgette',
      ),
    );}
  ));
}
