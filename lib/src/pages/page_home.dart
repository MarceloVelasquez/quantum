import 'package:flutter/material.dart';
import 'package:quantum/src/widgets/buttons.dart';

class PageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quantum'),
      ),
      body: Center(
        child: SimulateButton(),
      ),
    );
  }
}
