import 'dart:io';

import 'package:quantum/core/break.dart';
import 'package:quantum/core/data.dart';
import 'package:quantum/core/engine.dart';
import 'package:quantum/core/process.dart';
import 'package:quantum/core/rules.dart';
import 'package:quantum/core/structure.dart';

void main() {
  int quantum = 4;

  Data data = Data(
      [
        Process(1, 4, 4, Breaks([Break(1, 1), Break(2, 2)]), 1),
        Process(2, 6, 3, Breaks([Break(1, 3), Break(2, 1)]), 3),
        Process(3, 3, 4, Breaks([Break(1, 1), Break(2, 3)]), 1),
        Process(4, 2, 3, Breaks([Break(1, 2), Break(2, 3)]), 2),
        Process(5, 1, 5, Breaks([Break(1, 1), Break(2, 4)]), 3)
      ],
      InputRules([
        StructureHeap(Status.newed),
        StructurePriority(Status.ready, [2, 1, 3]),
        StructurePriority(Status.locked, [2, 3, 1]),
        StructurePriority(Status.suspended, [3, 1, 2]),
      ]),
      BreakRules([BreakRule.locked(1, 1), BreakRule.discontinued(2, 1, 2)]),
      quantum);

  Engine.instance.execute(data);
  print(Engine.instance.output);
}
