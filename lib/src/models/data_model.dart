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

    Map<Status, String> inputs = {
      Status.newed: newController.text,
      Status.ready: readyController.text,
      Status.locked: lockedController.text,
      Status.suspended: suspendedController.text,
    };

    List<Structure> inputStructures = [];

    for (var i = 0; i < inputs.length; i++) {
      Status status = inputs.keys.toList()[i];
      String text = inputs.values.toList()[i];
      Structure aux = Util.getInputStructure(status, text, processes);
      if (aux == null) {
        showSnack(
            context, 'Las prioridades en ${StatusName[status]} no coinciden');
        return false;
      } else if (aux.name == Status.finished) {
        showSnack(
            context, 'El formato en ${StatusName[status]} no es correcto');
        return false;
      }
      inputStructures.add(aux);
    }

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
