import 'package:quantum/core/break.dart';

class Process {
  int _id;
  int _arrivalTime;
  int _priority;
  int _cpu;
  Breaks _breaks;

  int stage = 0;
  int out;

  int get id => _id;
  int get cpu => _cpu;
  int get priority => _priority;
  int get arrivalTime => _arrivalTime;
  int get length => _breaks.breaks.length;
  String get breaks {
    var values = _breaks.breaks.map((b) => b.value);
    String string = '';
    values.forEach((value) => string += '$value ');
    return string.trim();
  }

  bool get isLocked => blocker != null;
  bool get isFinished => _cpu == stage;
  int get blocker => _breaks.byStage(stage);

  Process(this._id, this._arrivalTime, this._cpu, this._breaks, this._priority);

  void initialize() {
    stage = 0;
    out = null;
  }
}
