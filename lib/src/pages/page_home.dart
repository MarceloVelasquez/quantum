import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quantum/src/models/data_model.dart';
import 'package:quantum/src/widgets/buttons.dart';
import 'package:quantum/src/widgets/snackbar.dart';
import 'package:quantum/src/widgets/util.dart';

class PageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quantum'),
        actions: <Widget>[
          ResetButton(),
        ],
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Proceso')),
              DataColumn(label: Text('Llegada'), numeric: true),
              DataColumn(label: Text('CPU'), numeric: true),
              DataColumn(label: Text('Interrupciones'), numeric: true),
              DataColumn(label: Text('Prioridad'), numeric: true),
            ],
            rows: processes
                .map((item) => DataRow(cells: [
                      DataCell(Text(item.id.toString())),
                      DataCell(Text(item.arrivalTime.toString())),
                      DataCell(Text(item.cpu.toString())),
                      DataCell(Text(item.breaks.toString())),
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
    var controller = TextEditingController();
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Llegada CPU Interrupciones Prioridad',
                    helperText: 'Valores en orden y separados por espacio',
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Consumer<DataModel>(
                builder: (_, model, child) {
                  return IconButton(
                    onPressed: () {
                      var ints = Util.getNumbersFromField(controller.text);
                      if (ints == null) {
                        showSnack(
                          context,
                          'El formato ingresado no es correcto',
                        );
                        return;
                      }
                      var process = Util.getProcessFromInput(
                        model.processes.length + 1,
                        ints,
                      );
                      if (process == null) {
                        showSnack(
                          context,
                          'Mínimo tres valores para un proceso',
                        );
                        return;
                      }
                      if (model.breaks == null) model.breaks = process.length;
                      if (model.breaks != process.length) {
                        showSnack(
                          context,
                          'Número de interrupciones requeridas: ${model.breaks}',
                        );
                        return;
                      }
                      model.addProcess(process);
                      controller.text = '';
                    },
                    icon: Icon(Icons.add),
                    color: Theme.of(context).primaryColor,
                  );
                },
              ),
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
                labelText: 'Interrupción: MF DAS',
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
                  decoration: InputDecoration(
                    labelText: 'Nuevo',
                    hintText: 'Pila | Cola | 1 2 3',
                  ),
                ),
                TextField(
                  controller: model.readyController,
                  decoration: InputDecoration(
                    labelText: 'Listo',
                    hintText: 'Pila | Cola | 1 2 3',
                  ),
                ),
                TextField(
                  controller: model.lockedController,
                  decoration: InputDecoration(
                    labelText: 'Bloqueado',
                    hintText: 'Pila | Cola | 1 2 3',
                  ),
                ),
                TextField(
                  controller: model.suspendedController,
                  decoration: InputDecoration(
                    labelText: 'Suspendido',
                    hintText: 'Pila | Cola | 1 2 3',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
