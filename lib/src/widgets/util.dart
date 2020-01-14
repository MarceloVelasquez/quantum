import 'package:quantum/core.dart';

class Util {
  static List<int> getNumbersFromField(String text) {
    if (text.trim() == '') return null;
    bool clean = true;
    var ints = text.trim().split(' ').map((number) {
      if (int.tryParse(number.trim()) == null) clean = false;
      return int.tryParse(number.trim());
    }).toList();
    return clean ? ints : null;
  }

  static BreakRules getBreakRules(String text) {
    List<BreakRule> list = [];

    var aux = text.trim().split(',');

    if (aux == [] || text.trim() == '') return BreakRules([]);

    for (var i = 0; i < aux.length; i++) {
      var rules = Util.getNumbersFromField(aux[i].trim());
      if (rules == null) return null;
      BreakRule breakRule = BreakRule.empty();
      if (rules.length == 2) {
        breakRule = BreakRule.locked(rules[0], rules[1]);
      } else if (rules.length == 3) {
        breakRule = BreakRule.discontinued(rules[0], rules[1], rules[2]);
      } else
        return null;
      list.add(breakRule);
    }

    return BreakRules(list);
  }

  static Structure getInputStructure(Status status, String text) {
    Structure structure;
    String cleanText = text.trim().toLowerCase();

    switch (cleanText) {
      case 'cola':
        structure = StructureQueue(status);
        break;
      case 'pila':
        structure = StructureHeap(status);
        break;
      default:
        var ints = getNumbersFromField(cleanText);
        structure = ints == null
            ? StructureQueue(status)
            : StructurePriority(status, ints);
        break;
    }

    return structure;
  }

  static Iterable<E> indexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
