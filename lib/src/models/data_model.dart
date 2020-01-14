import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quantum/core.dart';
import 'package:quantum/src/widgets/util.dart';

class DataModel with ChangeNotifier {
  DataBuilder _builder;
  TextEditingController interruptionsController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController readyController = TextEditingController();
  TextEditingController lockedController = TextEditingController();
  TextEditingController suspendedController = TextEditingController();

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

  bool validate() {
    if (processes.length < 3) return false;

    var rules = Util.getBreakRules(interruptionsController.text);
    if (rules == null) return false;
    _builder.breakRules = rules;

    List<Structure> inputStructures = [];
    Structure aux;
    if (newController.text.trim() == '') return false;
    aux = Util.getInputStructure(Status.newed, newController.text);
    inputStructures.add(aux);

    if (readyController.text.trim() == '') return false;
    aux = Util.getInputStructure(Status.ready, readyController.text);
    inputStructures.add(aux);

    if (lockedController.text.trim() == '' && rules.breaks.length != 0)
      return false;
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
    notifyListeners();
  }

  Data data() => validate() ? _builder.build() : null;
}
