import 'package:quantum/core/quantum.dart';
import 'package:quantum/core/trace.dart';

class Output {
  List<Quantum> _quantums = [];

  List<Quantum> get quantums => _quantums;
  List<Trace> get traces {
    List<Trace> traces = [];
    _quantums.forEach((quantum) {
      traces.addAll(quantum.traces);
    });
    return traces;
  }

  Output();

  void addQuantum(Quantum quantum) {
    _quantums.add(quantum);
  }
}
