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

  BreakRules(this._breaks);

  List<BreakRule> get breaks => _breaks;

  BreakRule breakRule(int idBreak) =>
      _breaks.firstWhere((BreakRule breakRule) => breakRule._break == idBreak);

  bool get isBreaking => true;
}

class InputRules {
  List<Structure> _structures;

  InputRules(this._structures) {
    _structures.add(StructureQueue(Status.finished));
    _structures.add(StructureQueue(Status.inAction));
    _structures.add(StructureQueue(Status.lost));
  }

  List<Structure> get structures => _structures;
}
