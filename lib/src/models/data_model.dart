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
    if (processes.length < 2) return false;

    var rules = Util.getBreakRules(interruptionsController.text);
    if (rules == null) return false;
    _builder.breakRules = rules;

    List<Structure> inputStructures = [];
    Structure aux;
    aux = Util.getInputStructure(Status.newed, newController.text);
    if (aux == null) return false;
    inputStructures.add(aux);
    aux = Util.getInputStructure(Status.ready, readyController.text);
    if (aux == null) return false;
    inputStructures.add(aux);
    aux = Util.getInputStructure(Status.locked, lockedController.text);
    if (aux == null) return false;
    inputStructures.add(aux);
    aux = Util.getInputStructure(Status.suspended, suspendedController.text);
    if (aux == null) return false;
    inputStructures.add(aux);
    _builder.inputRules = InputRules(inputStructures);

    return true;
  }

  void clear() {
    _builder.clear();
    notifyListeners();
  }

  Data data() => validate() ? _builder.build() : null;
}

// addProcess(Process(1, 4, 4, Breaks([Break(1, 1), Break(2, 2)]), 1));
// [
//   Process(1, 4, 4, Breaks([Break(1, 1), Break(2, 2)]), 1),
//   Process(2, 6, 3, Breaks([Break(1, 3), Break(2, 1)]), 3),
//   Process(3, 3, 4, Breaks([Break(1, 1), Break(2, 3)]), 1),
//   Process(4, 2, 3, Breaks([Break(1, 2), Break(2, 3)]), 2),
//   Process(5, 1, 5, Breaks([Break(1, 1), Break(2, 4)]), 3),
// ];
// inputRules = InputRules([
//   StructureHeap(Status.newed),
//   StructurePriority(Status.ready, [2, 1, 3]),
//   StructurePriority(Status.locked, [2, 3, 1]),
//   StructurePriority(Status.suspended, [3, 1, 2]),
// ]);
// breakRules = BreakRules([
//   BreakRule.locked(1, 1),
//   BreakRule.discontinued(2, 1, 2),
// ]);
