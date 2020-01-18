import 'package:quantum/core.dart';

class Util {
  static List<int> getNumbersFromField(String text) {
    if (text.trim().isEmpty) throw EmptyInputException();
    text = text.replaceAll(RegExp('[ ]+'), ' ');
    return text.trim().split(' ').map((number) {
      int parsed = int.tryParse(number);
      if (parsed == null) throw NotNumberException(number);
      if (parsed < 0) throw NegativeNumberException();
      return parsed;
    }).toList();
  }

  static Process getProcessFromInput(int id, List<int> ints) {
    Breaks breaks = Breaks([]);
    if (ints.length < 3) throw MissingNumbersException();
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
    List<String> aux = text.trim().split(',');

    for (var i = 0; i < aux.length; i++) {
      List<int> rules = Util.getNumbersFromField(aux[i].trim());
      BreakRule breakRule = BreakRule.empty();
      if (rules.contains(0)) throw ZeroBreakException();
      if (rules.length == 1) {
        breakRule = BreakRule.locked(i + 1, rules[0]);
      } else if (rules.length == 2) {
        breakRule = BreakRule.discontinued(i + 1, rules[0], rules[1]);
      } else {
        throw FormatBreakException();
      }
      list.add(breakRule);
    }

    return BreakRules(list);
  }

  static Structure getInputStructure(
    Status status,
    String text,
    List<Process> processes,
  ) {
    Structure structure;
    String cleanText = text.trim().toLowerCase();
    if (cleanText.isEmpty) return StructureQueue(status);

    switch (cleanText) {
      case 'cola':
        structure = StructureQueue(status);
        break;
      case 'pila':
        structure = StructureHeap(status);
        break;
      default:
        List<int> ints = getNumbersFromField(cleanText);
        List<int> priorities = processes.map((p) => p.priority).toList();

        priorities.forEach((e) => !ints.contains(e)
            ? throw MissingPrioritiesException(StatusName[status])
            : null);

        structure = StructurePriority(status, ints);
        break;
    }

    return structure;
  }
}
