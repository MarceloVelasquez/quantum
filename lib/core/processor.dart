import 'package:quantum/core/data.dart';
import 'package:quantum/core/structure.dart';

class Processor {
  List<Structure> _structures;

  Structure get newed =>
      _structures.firstWhere((struct) => struct.name == Status.newed);
  Structure get ready =>
      _structures.firstWhere((struct) => struct.name == Status.ready);
  Structure get inAction =>
      _structures.firstWhere((struct) => struct.name == Status.inAction);
  Structure get locked =>
      _structures.firstWhere((struct) => struct.name == Status.locked);
  Structure get suspended =>
      _structures.firstWhere((struct) => struct.name == Status.suspended);
  Structure get finished =>
      _structures.firstWhere((struct) => struct.name == Status.finished);
  Structure get lost =>
      _structures.firstWhere((struct) => struct.name == Status.lost);

  Structure fromStatus(Status status) =>
      _structures.firstWhere((struct) => struct.name == status);

  bool get isRunning =>
      ready.isNotEmpty || locked.isNotEmpty || suspended.isNotEmpty;

  Processor(this._structures);
}
