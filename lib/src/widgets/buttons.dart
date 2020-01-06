import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/models/data_model.dart';
import 'package:quantum/src/models/output_model.dart';

class SimulateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Data data = Provider.of<DataModel>(context, listen: false).data();
        Provider.of<OutputModel>(context, listen: false).executeData(data);
        Navigator.pushNamed(context, '/simulator');
      },
      child: Text('Ejecutar'),
    );
  }
}
