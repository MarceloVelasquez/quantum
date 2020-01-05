import 'package:quantum/core/process.dart';
import 'package:quantum/core/rules.dart';
import 'package:quantum/core/structure.dart';

enum Status { newed, ready, inAction, locked, suspended, finished, lost }
enum Type { initial, blocked, empty, generic }

const Map<Status, String> StatusName = {
  Status.newed: "N",
  Status.ready: "L",
  Status.inAction: "E",
  Status.locked: "B",
  Status.suspended: "S",
  Status.finished: "T",
  Status.lost: "P"
};

class Data {
  List<Process> _processes;
  InputRules _inputRules;
  BreakRules _breakRules;

  Data(this._processes, this._inputRules, this._breakRules);

  List<Process> get processes => _processes;

  List<Structure> get structures {
    List<Structure> structures = List();
    _inputRules.structures.forEach((structure) {
      structures.add(structure);
    });
    return structures;
  }

  int memory(int id) => _breakRules.breakRule(id).memory;
  int das(int id) => _breakRules.breakRule(id).das;
}

class DataBuilder {
  List<Process> _processes;
  InputRules _inputRules;
  BreakRules _breakRules;

  DataBuilder();

  set processes(value) => _processes = value;
  set inputRules(value) => _inputRules = value;
  set breakRules(value) => _breakRules = value;

  Data build() {
    _processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    _inputRules.structures.forEach((e) => e.initialize(_processes));

    return _processes != null && _inputRules != null && _breakRules != null
        ? Data(_processes, _inputRules, _breakRules)
        : null;
  }
}
