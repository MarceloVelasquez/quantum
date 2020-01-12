import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/models/data_model.dart';
import 'package:quantum/src/models/output_model.dart';

class SimulateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(4),
          child: RaisedButton(
            onPressed: () {
              Data data = Provider.of<DataModel>(context, listen: false).data();
              Provider.of<OutputModel>(context, listen: false)
                  .executeData(data);
              Navigator.pushNamed(context, '/simulator');
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text('EJECUTAR'),
          ),
        ),
      ],
    );
  }
}
