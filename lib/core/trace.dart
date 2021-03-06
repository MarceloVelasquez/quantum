import 'package:quantum/core/data.dart';
import 'package:quantum/core/process.dart';

class Trace {
  Process _process;
  List<int> _instructions;
  Status _status;
  int _break;

  final int quantum = 4;

  int get id => _process.id;
  String get process => _process.id.toString();
  String get advance => '${_instructions.first}-${_instructions.last}';
  String get statusName => StatusName[_status];
  String get idBreak => _break != null ? ' ($_break)' : '';
  Status get status => _status;
  bool get isEmpty => _instructions == null;

  Trace();
  Trace.withBreak(this._process, this._status, this._break) {
    initialize();
  }

  Trace.withoutBreak(this._process, this._status) {
    initialize();
  }

  Trace.initial(this._process, this._status) {
    _instructions = List();
    for (var i = 0; i < _process.cpu * quantum; i++) _instructions.add(i);
  }

  void initialize() {
    _instructions = List();
    int n = _process.stage * quantum;
    for (int i = n - quantum; i < n; i++) _instructions.add(i);
  }
}
