import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quantum/core.dart';

class OutputModel with ChangeNotifier {
  Output _output;
  Engine _engine = Engine();
  List<DataChart> dataChart = [];

  Output get output => _output;
  List<Quantum> get quantums => _output.quantums;
  List<Trace> get traces => _output.traces;

  void executeData(Data data) {
    _output = _engine.generate(data);
    var values = _output.traces
        .where((trace) => trace.status == Status.inAction)
        .map((f) => f.id)
        .toList();
    for (var i = 1; i <= values.length; i++) {
      dataChart.add(DataChart(i.toString(), values[i - 1]));
    }
  }
}

class DataChart {
  String string;
  int value;

  DataChart(this.string, this.value);
}
