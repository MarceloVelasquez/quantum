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

  Map<Status, List<int>> structures;

  StructureModel(this._traces) {
    _newed = _traces
        .where((trace) => trace.status == Status.newed)
        .map((trace) => trace.id)
        .toList();
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
    notifyListeners();
  }

  void execute() {
    _traces.forEach((trace) {
      if (!trace.isEmpty) {
        add(trace.status, trace.id);
      }
    });
  }
}
