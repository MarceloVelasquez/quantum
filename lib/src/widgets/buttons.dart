import 'package:flutter/material.dart';

class SimulateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => Navigator.pushNamed(context, '/simulator'),
      child: Text('SIMULATE'),
    );
  }
}
