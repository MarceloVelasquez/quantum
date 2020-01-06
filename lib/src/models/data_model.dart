import 'package:flutter/foundation.dart';
import 'package:quantum/core.dart';

class DataModel with ChangeNotifier {
  DataBuilder _builder = DataBuilder();

  DataModel() {
    processes = [
      Process(1, 4, 4, Breaks([Break(1, 1), Break(2, 2)]), 1),
      Process(2, 6, 3, Breaks([Break(1, 3), Break(2, 1)]), 3),
      Process(3, 3, 4, Breaks([Break(1, 1), Break(2, 3)]), 1),
      Process(4, 2, 3, Breaks([Break(1, 2), Break(2, 3)]), 2),
      Process(5, 1, 5, Breaks([Break(1, 1), Break(2, 4)]), 3),
    ];
    inputRules = InputRules([
      StructureHeap(Status.newed),
      StructurePriority(Status.ready, [2, 1, 3]),
      StructurePriority(Status.locked, [2, 3, 1]),
      StructurePriority(Status.suspended, [3, 1, 2]),
    ]);
    breakRules = BreakRules([
      BreakRule.locked(1, 1),
      BreakRule.discontinued(2, 1, 2),
    ]);
  }

  set processes(value) => _builder.processes = value;
  set inputRules(value) => _builder.inputRules = value;
  set breakRules(value) => _builder.breakRules = value;

  Data data() => _builder.build();
}
