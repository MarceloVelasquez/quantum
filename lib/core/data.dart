import 'package:quantum/core/process.dart';
import 'package:quantum/core/rules.dart';
import 'package:quantum/core/structure.dart';

enum Status { newed, ready, inAction, locked, suspended, lost, finished }
enum Type { initial, blocked, empty, generic }

const Map<Status, String> StatusName = {
  Status.newed: "Nuevo",
  Status.ready: "Listo",
  Status.inAction: "En ejecución",
  Status.locked: "Bloqueado",
  Status.suspended: "Suspendido",
  Status.lost: "Perdido",
  Status.finished: "Terminado",
};

class Data {
  List<Process> _processes;
  BreakRules _breakRules;
  List<Structure> _structures;

  List<Process> get processes => _processes;
  List<Structure> get structures => _structures;

  Data(this._processes, this._breakRules, this._structures);

  int memory(int id) => _breakRules.breakRule(id).memory;
  int das(int id) => _breakRules.breakRule(id).das;
}

class DataBuilder {
  List<Process> _processes = [];
  InputRules _inputRules;
  BreakRules _breakRules;

  get processes => _processes;

  set processes(value) => _processes = value;
  set inputRules(value) => _inputRules = value;
  set breakRules(value) => _breakRules = value;

  DataBuilder();

  void addProcess(Process process) => _processes.add(process);

  void initialize() {
    _processes.forEach((process) => process.initialize());
  }

  Data build() {
    initialize();

    _processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    _inputRules.structures.forEach((e) => e.initialize(_processes));

    List<Structure> structures = List();
    _inputRules.structures.forEach((structure) {
      structures.add(structure);
    });

    return _processes != null && _inputRules != null && _breakRules != null
        ? Data(_processes, _breakRules, structures)
        : null;
  }

  void clear() {
    _processes.clear();
    _inputRules = null;
    _breakRules = null;
  }
}
