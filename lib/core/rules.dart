import 'package:quantum/core/data.dart';
import 'package:quantum/core/structure.dart';

class BreakRule {
  int _break;
  int _memory;
  int _das;

  int get memory => _memory;
  int get das => _das;

  BreakRule.empty();
  BreakRule.locked(this._break, this._memory);
  BreakRule.discontinued(this._break, this._memory, this._das);
}

class BreakRules {
  List<BreakRule> _breaks;

  List<BreakRule> get breaks => _breaks;
  bool get isBreaking => true;

  BreakRules(this._breaks);

  BreakRule breakRule(int idBreak) =>
      _breaks.firstWhere((BreakRule breakRule) => breakRule._break == idBreak);
}

class InputRules {
  List<Structure> _structures;

  List<Structure> get structures => _structures;

  InputRules(this._structures) {
    _structures.add(StructureQueue(Status.inAction));
    _structures.add(StructureQueue(Status.lost));
    _structures.add(StructureQueue(Status.finished));
  }
}
