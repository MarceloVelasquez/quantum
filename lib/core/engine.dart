import 'package:quantum/core/data.dart';
import 'package:quantum/core/output.dart';
import 'package:quantum/core/process.dart';
import 'package:quantum/core/processor.dart';
import 'package:quantum/core/quantum.dart';
import 'package:quantum/core/trace.dart';

class Engine {
  static final Engine instance = Engine._constructor();

  Data _data;
  Output _output;
  Processor _processor;
  Quantum _quantum;

  Engine._constructor();

  List<Process> get processes => _data.processes;
  Output get output => _output;
  int get quantum => _data.quantum;

  void _initialize(Data data) {
    this._data = data;
    this._data.initialize();

    _output = Output();
    _processor = Processor(_data.structures);
    _quantum = Quantum();
  }

  void addQuantum(Quantum quantum) {
    _output.addQuantum(quantum);
    _quantum = Quantum();
  }

  void addTrace(Type type, [Process process, Status status, int blocker]) {
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

  void execute(Data data) {
    _initialize(data);

    Process process;
    int quantumCounter = 1;

    _data.processes.forEach((process) {
      addTrace(Type.initial, process, Status.newed);
    });

    addQuantum(_quantum);

    while (_processor.newed.isNotEmpty) {
      process = _processor.newed.takeProcess();
      addTrace(Type.initial, process, Status.ready);
    }

    addQuantum(_quantum);

    while (_processor.isRunning) {
      process = _processor.ready.takeProcess();

      if (process == null)
        _quantum.addTrace(Trace());
      else {
        process.stage++;
        addTrace(Type.generic, process, Status.inAction);

        process = _processor.inAction.takeProcess();

        if (process.isLocked) {
          process.out = quantumCounter + _data.memory(process.blocker);
          addTrace(Type.blocked, process, Status.locked, process.blocker);
        } else if (process.isFinished) {
          addTrace(Type.generic, process, Status.finished);
        } else {
          addTrace(Type.generic, process, Status.ready);
        }
      }

      List<Process> processes = _processor.locked.takeProcesses(quantumCounter);
      if (processes != null) {
        processes.forEach((process) {
          if (_data.das(process.blocker) != null) {
            process.out = quantumCounter + _data.das(process.blocker);
            addTrace(Type.blocked, process, Status.suspended, process.blocker);
          } else {
            if (process.isFinished) {
              addTrace(Type.generic, process, Status.lost);
            } else {
              addTrace(Type.generic, process, Status.ready);
            }
          }
        });
      }

      processes = _processor.suspended.takeProcesses(quantumCounter);
      if (processes != null) {
        processes.forEach((process) {
          if (process.isFinished) {
            addTrace(Type.generic, process, Status.lost);
          } else {
            addTrace(Type.generic, process, Status.ready);
          }
        });
      }

      addQuantum(_quantum);
      quantumCounter++;
    }
  }
}
