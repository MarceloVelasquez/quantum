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

  Data build(BuildContext context) {
    try {
      if (processes.length < 2) throw MissingProcessException(2);

      var rules = Util.getBreakRules(interruptionsController.text);
      if (rules.breaks.length < breaks) throw MissingBreakException();
      _builder.breakRules = rules;

      Map<Status, String> _inputs = {
        Status.newed: newController.text,
        Status.ready: readyController.text,
        Status.locked: lockedController.text,
        Status.suspended: suspendedController.text,
      };

      List<Structure> inputStructures = [];

      for (var i = 0; i < _inputs.length; i++) {
        Status status = _inputs.keys.toList()[i];
        String text = _inputs.values.toList()[i];
        inputStructures.add(Util.getInputStructure(status, text, processes));
      }

      _builder.inputRules = InputRules(inputStructures);
    } catch (e) {
      showSnack(context, e.message);
      return null;
    }

    return _builder.build();
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

  Data data(BuildContext context) => build(context);
}
