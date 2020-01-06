import 'package:quantum/core/trace.dart';

class Quantum {
  List<Trace> _traces = List();

  List<Trace> get traces => _traces;

  Quantum();

  void addTrace(Trace trace) => _traces.add(trace);
}
