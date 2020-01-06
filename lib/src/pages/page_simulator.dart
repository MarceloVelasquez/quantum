import 'package:flutter/material.dart';
import 'package:quantum/src/pages/section_structure.dart';
import 'package:quantum/src/pages/section_graphic.dart';
import 'package:quantum/src/pages/section_states.dart';

class PageSimulator extends StatefulWidget {
  PageSimulator({Key key}) : super(key: key);

  @override
  _PageSimulatorState createState() => _PageSimulatorState();
}

class _PageSimulatorState extends State<PageSimulator> {
  int _selectedPage = 0;

  final _sections = [
    SectionStructure(),
    SectionStates(),
    SectionGraphics(),
  ];

  @override
  Widget build(BuildContext context) {
    double overline = Theme.of(context).textTheme.caption.fontSize;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        selectedFontSize: overline,
        unselectedFontSize: overline,
        onTap: (int index) => setState(() => _selectedPage = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text('Data structure'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('States'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Process chart'),
          ),
        ],
      ),
      body: _sections[_selectedPage],
    );
  }
}
