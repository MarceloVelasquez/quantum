import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quantum/src/pages/page_home.dart';
import 'package:quantum/src/pages/page_simulator.dart';
import 'package:quantum/src/models/data_model.dart';
import 'package:quantum/src/models/output_model.dart';

void main() => runApp(Quantum());

class Quantum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataModel()),
        ChangeNotifierProvider(create: (_) => OutputModel()),
      ],
      child: MaterialApp(
        routes: {
          '/home': (context) => PageHome(),
          '/simulator': (context) => PageSimulator(),
        },
        title: 'Quantum',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.grey[900],
          primarySwatch: Colors.grey,
          cursorColor: Color(0x10000000),
          accentColor: Colors.grey[700],
          fontFamily: 'Roboto',
          textTheme: TextTheme(
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
            textTheme: TextTheme(
              title: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        home: SplashScreen.navigate(
          name: 'assets/quantum.flr',
          next: (context) => PageHome(),
          until: () => Future.delayed(Duration()),
          fit: BoxFit.cover,
          startAnimation: 'splash',
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
