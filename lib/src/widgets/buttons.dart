import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/models/data_model.dart';
import 'package:quantum/src/models/output_model.dart';
import 'package:quantum/src/widgets/snackbar.dart';
import 'package:quantum/src/widgets/util.dart';

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
              Data data =
                  Provider.of<DataModel>(context, listen: false).data(context);
              if (data != null) {
                Provider.of<OutputModel>(context, listen: false)
                    .executeData(data);
                Navigator.pushNamed(context, '/simulator');
              }
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

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Theme.of(context).primaryColor,
      icon: Icon(Icons.refresh),
      onPressed: () => Provider.of<DataModel>(context, listen: false).clear(),
    );
  }
}

class AddButton extends StatelessWidget {
  AddButton(this._model, this._controller);

  final TextEditingController _controller;
  final DataModel _model;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        try {
          Process process = Util.getProcessFromInput(
            _model.processes.length + 1,
            Util.getNumbersFromField(_controller.text),
          );
          if (_model.breaks == null) _model.breaks = process.length;
          if (_model.breaks != process.length) {
            throw RequiredBreaksException(_model.breaks);
          }
          _model.addProcess(process);
          _controller.text = '';
        } catch (e) {
          showSnack(context, e.message);
          return;
        }
      },
      icon: Icon(Icons.add),
    );
  }
}
