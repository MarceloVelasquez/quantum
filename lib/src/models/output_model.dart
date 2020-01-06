import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quantum/core.dart';

class OutputModel with ChangeNotifier {
  Output _output;
  Engine _engine = Engine();

  Output get output => _output;

  void executeData(Data data) {
    _output = _engine.generate(data);
  }
}
