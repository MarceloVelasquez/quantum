import 'package:quantum/core/data.dart';
import 'package:quantum/core/output.dart';
import 'package:quantum/core/process.dart';
import 'package:quantum/core/processor.dart';
import 'package:quantum/core/quantum.dart';
import 'package:quantum/core/trace.dart';

class Engine {
  Data _data;
  Processor _processor;
  Quantum _quantum;
  Output _output;

  Engine();

  Output generate(Data data) {
    _execute(data);
    return _output;
  }

  void _initialize(Data data) {
    _data = data;
    _processor = Processor(data.structures);
    _quantum = Quantum();
    _output = Output();
  }

  void _addQuantum(Quantum quantum) {
    _output.addQuantum(quantum);
    _quantum = Quantum();
  }

  void _addTrace(Type type, [Process process, Status status, int blocker]) {
    switch (type) {
      case Type.empty:
        _quantum.addTrace(Trace());
        break;
      case Type.initial:
        _quantum.addTrace(Trace.initial(process, status));
        break;
      case Type.blocked:
        _quantum.addTrace(Trace.withBreak(process, status, blocker));
        break;
      case Type.generic:
        _quantum.addTrace(Trace.withoutBreak(process, status));
        break;
      default:
    }

    _processor.fromStatus(status).putProcess(process);
  }

  void _execute(Data data) {
    _initialize(data);

    Process process;
    int quantumCounter = 1;

    _data.processes.forEach((item) {
      _addTrace(Type.initial, item, Status.newed);
    });

    _addQuantum(_quantum);

    while (_processor.newed.isNotEmpty) {
      process = _processor.newed.takeProcess();
      _addTrace(Type.initial, process, Status.ready);
    }

    _addQuantum(_quantum);

    while (_processor.isRunning) {
      process = _processor.ready.takeProcess();

      if (process == null)
        _quantum.addTrace(Trace());
      else {
        process.stage++;
        _addTrace(Type.generic, process, Status.inAction);

        process = _processor.inAction.takeProcess();

        if (process.isLocked) {
          process.out = quantumCounter + _data.memory(process.blocker);
          _addTrace(Type.blocked, process, Status.locked, process.blocker);
        } else if (process.isFinished) {
          _addTrace(Type.generic, process, Status.finished);
        } else {
          _addTrace(Type.generic, process, Status.ready);
        }
      }

      List<Process> processes = _processor.locked.takeProcesses(quantumCounter);
      if (processes != null) {
        processes.forEach((item) {
          if (_data.das(item.blocker) != null) {
            item.out = quantumCounter + _data.das(item.blocker);
            _addTrace(Type.blocked, item, Status.suspended, item.blocker);
          } else if (item.isFinished) {
            _addTrace(Type.generic, item, Status.lost);
          } else {
            _addTrace(Type.generic, item, Status.ready);
          }
        });
      }

      processes = _processor.suspended.takeProcesses(quantumCounter);
      if (processes != null) {
        processes.forEach((item) {
          if (item.isFinished) {
            _addTrace(Type.generic, item, Status.lost);
          } else {
            _addTrace(Type.generic, item, Status.ready);
          }
        });
      }

      _addQuantum(_quantum);
      quantumCounter++;
    }
  }
}
