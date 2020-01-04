import 'package:quantum/core/trace.dart';

class Quantum {
  List<Trace> _traces = List();

  Quantum();

  void addTrace(Trace trace) => _traces.add(trace);

  @override
  String toString() {
    String string = '';
    _traces.forEach((trace) {
      string += trace.toString() + '\n';
    });
    return string;
  }
}
