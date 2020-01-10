import 'package:flutter/foundation.dart';
import 'package:quantum/core.dart';

class StructureModel with ChangeNotifier {
  List<Trace> _traces;

  List<int> _newed = [];
  List<int> _ready = [];
  List<int> _inAction = [];
  List<int> _locked = [];
  List<int> _suspended = [];
  List<int> _finished = [];
  List<int> _lost = [];

  int _counter;

  Trace _trace;
  Trace get actualTrace => _trace;
  bool get isDone => _traces.length == _counter;

  Map<Status, List<int>> structures;

  StructureModel(this._traces) {
    var newed = _traces.where((trace) => trace.status == Status.newed);
    _newed = newed.map((trace) => trace.id).toList();
    _counter = newed.length;
    structures = {
      Status.newed: _newed,
      Status.ready: _ready,
      Status.inAction: _inAction,
      Status.locked: _locked,
      Status.suspended: _suspended,
      Status.finished: _finished,
      Status.lost: _lost,
    };
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
