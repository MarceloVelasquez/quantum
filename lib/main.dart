import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quantum/src/pages/page_home.dart';
import 'package:quantum/src/pages/page_simulator.dart';
import 'package:quantum/src/models/data_model.dart';
import 'package:quantum/src/models/output_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => DataModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => OutputModel(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => PageHome(),
        '/simulator': (context) => PageSimulator(),
      },
      title: 'Quantum',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent[700],
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: PageHome(),
    ),
  ));

  SystemChrome.setEnabledSystemUIOverlays([]);
}
