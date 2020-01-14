import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/models/data_model.dart';
import 'package:quantum/src/widgets/buttons.dart';
import 'package:quantum/src/widgets/util.dart';

class PageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quantum'),
      ),
      body: SingleChildScrollView(child: ScannerPage()),
    );
  }
}

class ScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TableProcessWidget(),
        InputProcessWidget(),
        InputBreakWidget(),
        InputRulesWidget(),
        SimulateButton(),
      ],
    );
  }
}

class TableProcessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var processes = Provider.of<DataModel>(context).processes;

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 25,
            columns: [
              DataColumn(label: Text('Proceso')),
              DataColumn(label: Text('Llegada'), numeric: true),
              DataColumn(label: Text('CPU'), numeric: true),
              DataColumn(label: Text('Prioridad'), numeric: true),
            ],
            rows: processes
                .map((item) => DataRow(cells: [
                      DataCell(Text(item.id.toString())),
                      DataCell(Text(item.arrivalTime.toString())),
                      DataCell(Text(item.cpu.toString())),
                      DataCell(Text(item.priority.toString())),
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class InputProcessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var processController = TextEditingController();
    var breakController = TextEditingController();
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: processController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Llegada CPU Prioridad',
                  helperText: 'Valores en orden y separados por espacio',
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: breakController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Bloqueos',
                  helperText: 'Valores en orden y separados por espacio',
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  onPressed: () =>
                      Provider.of<DataModel>(context, listen: false).clear(),
                  child: Text('BORRAR DATOS'),
                ),
                Consumer<DataModel>(
                  builder: (_, model, child) {
                    return RaisedButton(
                      child: Text('AGREGAR'),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        List<int> process =
                            Util.getNumbersFromField(processController.text);
                        List<int> breaks =
                            Util.getNumbersFromField(breakController.text);
                        if (process == null || process.length != 3) return;

                        model.addProcess(Process(
                          model.processes.length + 1,
                          process[0],
                          process[1],
                          breaks == null
                              ? Breaks([])
                              : Breaks(Util.indexed(
                                  breaks,
                                  (index, item) => Break(index + 1, item),
                                ).toList()),
                          process[2],
                        ));

                        processController.text = '';
                        breakController.text = '';
                      },
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class InputBreakWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Consumer<DataModel>(
          builder: (_, model, __) {
            return TextField(
              controller: model.interruptionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Demora de interrupción: MF DAS',
                helperText: 'Interrupciones separadas por coma',
              ),
            );
          },
        ),
      ),
    );
  }
}

class InputRulesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Consumer<DataModel>(
          builder: (_, model, child) {
            return Column(
              children: <Widget>[
                TextField(
                  controller: model.newController,
                  decoration: InputDecoration(labelText: 'Nuevo'),
                ),
                TextField(
                  controller: model.readyController,
                  decoration: InputDecoration(labelText: 'Listo'),
                ),
                TextField(
                  controller: model.lockedController,
                  decoration: InputDecoration(labelText: 'Bloqueado'),
                ),
                TextField(
                  controller: model.suspendedController,
                  decoration: InputDecoration(labelText: 'Suspendido'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
