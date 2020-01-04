import 'package:quantum/core/data.dart';
import 'package:quantum/core/manager.dart';
import 'package:quantum/core/process.dart';

abstract class Structure {
  List<Process> _list;
  Status _name;

  Structure(this._name) {
    _list = new List();
  }

  Status get name => _name;
  bool get isNotEmpty => _list.isNotEmpty;
  int get length => _list.length;

  void putProcess(Process process) {
    _list.add(process);
  }

  Process takeProcess() {
    if (_list.length > 0) {
      int index = _getIndexProcess(_list);
      Process process = _list[index];
      _list.removeAt(index);
      return process;
    }
    return null;
  }

  List<Process> takeProcesses(int quantumCounter) {
    List<Process> processes = [];
    List<Process> auxiliar = [];

    _list.forEach((process) {
      if (process.out == quantumCounter) auxiliar.add(process);
    });

    for (var i = 0; i < auxiliar.length; i++) {
      Process process = _takeProcess(auxiliar);
      _list.remove(process);
      processes.add(process);
    }

    return processes.length > 0 ? processes : null;
  }

  Process _takeProcess(List<Process> list) {
    if (list.length > 0) {
      int index = _getIndexProcess(list);
      Process process = list[index];
      list.removeAt(index);
      return process;
    }
    return null;
  }

  @override
  String toString() => _list.toString();

  int _getIndexProcess(List<Process> list);
  void initialize();
}

class StructureQueue extends Structure {
  StructureQueue(Status name) : super(name);

  @override
  void initialize() {}

  @override
  int _getIndexProcess(List<Process> list) => 0;
}

class StructureHeap extends Structure {
  StructureHeap(Status name) : super(name);

  @override
  void initialize() {}

  @override
  int _getIndexProcess(List<Process> list) => list.length - 1;
}

class StructurePriority extends Structure {
  List<int> _processes;
  List<int> _priorities;

  StructurePriority(Status name, this._priorities) : super(name);

  List<int> get processes => _processes;

  @override
  void initialize() => _processes = Manager.orderProcesses(_priorities);

  @override
  int _getIndexProcess(List<Process> list) {
    int index;
    for (int id in _processes) {
      index = list.indexWhere((process) => process.id == id);
      if (index != -1) break;
    }
    return index;
  }
}
