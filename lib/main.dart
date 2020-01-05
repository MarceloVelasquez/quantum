import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quantum/core/break.dart';
import 'package:quantum/core/data.dart';
import 'package:quantum/core/engine.dart';
import 'package:quantum/core/process.dart';
import 'package:quantum/core/rules.dart';
import 'package:quantum/core/structure.dart';
import 'package:quantum/src/pages/page_home.dart';
import 'package:quantum/src/pages/page_simulator.dart';

void main() {
  int quantum = 4;

  Data data = Data(
      [
        Process(1, 4, 4, Breaks([Break(1, 1), Break(2, 2)]), 1),
        Process(2, 6, 3, Breaks([Break(1, 3), Break(2, 1)]), 3),
        Process(3, 3, 4, Breaks([Break(1, 1), Break(2, 3)]), 1),
        Process(4, 2, 3, Breaks([Break(1, 2), Break(2, 3)]), 2),
        Process(5, 1, 5, Breaks([Break(1, 1), Break(2, 4)]), 3)
      ],
      InputRules([
        StructureHeap(Status.newed),
        StructurePriority(Status.ready, [2, 1, 3]),
        StructurePriority(Status.locked, [2, 3, 1]),
        StructurePriority(Status.suspended, [3, 1, 2]),
      ]),
      BreakRules([BreakRule.locked(1, 1), BreakRule.discontinued(2, 1, 2)]),
      quantum);

  Engine.instance.execute(data);
  print(Engine.instance.output);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/home': (context) => PageHome(),
      '/simulator': (context) => PageSimulator(),
    },
    title: 'Quantum',
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.red[400],
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
  ));

  SystemChrome.setEnabledSystemUIOverlays([]);
}
