import 'package:quantum/core/engine.dart';
import 'package:quantum/core/process.dart';

class Manager {
  static List<int> orderProcesses(List<int> priorities) {
    List<Process> orderProcesses = new List();

    priorities.forEach((p) {
      orderProcesses
          .addAll(Engine.instance.processes.where((x) => p == x.priority));
    });

    return orderProcesses.map((n) => n.id).toList();
  }
}
