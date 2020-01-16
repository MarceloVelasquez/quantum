import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/widgets/snackbar.dart';
import 'package:quantum/src/widgets/util.dart';

class DataModel with ChangeNotifier {
  DataBuilder _builder;
  TextEditingController interruptionsController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController readyController = TextEditingController();
  TextEditingController lockedController = TextEditingController();
  TextEditingController suspendedController = TextEditingController();

  int breaks;

  DataModel() {
    _builder = DataBuilder();
  }

  List<Process> get processes => _builder.processes;

  set processes(value) => _builder.processes = value;
  set inputRules(value) => _builder.inputRules = value;

  void addProcess(Process process) {
    _builder.addProcess(process);
    notifyListeners();
  }

  bool validate(BuildContext context) {
    if (processes.length < 3) {
      showSnack(context, 'Debe haber como mínimo tres procesos');
      return false;
    }

    var rules = Util.getBreakRules(interruptionsController.text);
    if (rules == null) {
      showSnack(context, 'Formato de interrupciones no válido');
      return false;
    }
    if (rules.breaks.length < breaks) {
      showSnack(context, 'Faltan interrupciones');
      return false;
    }
    _builder.breakRules = rules;

    List<Structure> inputStructures = [];
    Structure aux;
    if (newController.text.trim().isEmpty) {
      showSnack(context, 'Nuevo no puede esta vacío');
      return false;
    }
    aux = Util.getInputStructure(Status.newed, newController.text);
    inputStructures.add(aux);

    if (readyController.text.trim().isEmpty) {
      showSnack(context, 'Listo no puede esta vacío');
      return false;
    }
    aux = Util.getInputStructure(Status.ready, readyController.text);
    inputStructures.add(aux);

    if (lockedController.text.trim().isEmpty && rules.breaks.length != 0) {
      showSnack(context, 'Listo no puede esta vacío');
      return false;
    }
    aux = Util.getInputStructure(Status.locked, lockedController.text);
    inputStructures.add(aux);

    aux = Util.getInputStructure(Status.suspended, suspendedController.text);
    inputStructures.add(aux);

    _builder.inputRules = InputRules(inputStructures);

    return true;
  }

  void clear() {
    _builder.clear();
    interruptionsController.text = '';
    newController.text = '';
    readyController.text = '';
    lockedController.text = '';
    suspendedController.text = '';
    breaks = null;
    notifyListeners();
  }

  Data data(BuildContext context) =>
      validate(context) ? _builder.build() : null;
}
