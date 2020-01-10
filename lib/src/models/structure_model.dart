import 'package:flutter/foundation.dart';
import 'package:quantum/core.dart';

class StructureModel with ChangeNotifier {
  List<Trace> _traces;
  Trace _trace;
  int _counter;

  Trace get actualTrace => _trace;
  bool get isDone => _traces.length == _counter;

  Map<Status, List<int>> structures;

  StructureModel(this._traces) {
    structures = {
      Status.newed: [],
      Status.ready: [],
      Status.inAction: [],
      Status.locked: [],
      Status.suspended: [],
      Status.finished: [],
      Status.lost: [],
    };

    var newed = _traces.where((trace) => trace.status == Status.newed);
    structures[Status.newed] = newed.map((trace) => trace.id).toList();
    _counter = newed.length;
  }

  void removeProcess(int id) {
    structures.entries.forEach((entry) => entry.value.remove(id));
  }

  void add(Status status, int id) {
    removeProcess(id);
    structures[status].add(id);
  }

  void next() {
    if (_counter < _traces.length) {
      _trace = _traces[_counter];
      notifyListeners();
      if (!_trace.isEmpty) {
        add(_trace.status, _trace.id);
      }
      _counter++;
    }
  }
}
