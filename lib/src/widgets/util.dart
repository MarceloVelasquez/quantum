import 'package:quantum/core.dart';

class Util {
  static List<int> getNumbersFromField(String text) {
    if (text.trim().isEmpty) return null;
    bool clean = true;
    text = text.replaceAll(RegExp('[ ]+'), ' ');
    var ints = text.trim().split(' ').map((number) {
      if (int.tryParse(number) == null) clean = false;
      return int.tryParse(number);
    }).toList();
    return clean ? ints : null;
  }

  static Process getProcessFromInput(int id, List<int> ints) {
    Breaks breaks = Breaks([]);
    if (ints.length < 3) return null;
    if (ints.length > 3) {
      List<Break> list = [];
      for (var i = 2; i < ints.length - 1; i++) {
        int value = ints[i] % 4 == 0 ? ints[i] : ints[i] + 4 - ints[i] % 4;
        list.add(Break(i - 1, value));
      }
      breaks = Breaks(list);
    }
    return Process(id, ints[0], ints[1], breaks, ints.last);
  }

  static BreakRules getBreakRules(String text) {
    if (text.trim().isEmpty) return BreakRules([]);

    List<BreakRule> list = [];
    text = text.replaceAll(RegExp('[ ]+'), ' ');
    var aux = text.trim().split(',');

    for (var i = 0; i < aux.length; i++) {
      var rules = Util.getNumbersFromField(aux[i].trim());
      if (rules == null) return null;
      BreakRule breakRule = BreakRule.empty();
      if (rules.length == 1) {
        breakRule = BreakRule.locked(i + 1, rules[0]);
      } else if (rules.length == 2) {
        breakRule = BreakRule.discontinued(i + 1, rules[0], rules[1]);
      } else {
        return null;
      }
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
