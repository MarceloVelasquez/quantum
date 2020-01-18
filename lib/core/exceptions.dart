abstract class CoreException implements Exception {
  String get message;
}

abstract class ProcessException implements CoreException {
  ProcessException();
}

abstract class BreakException implements CoreException {
  BreakException();
}

abstract class PriorityException implements CoreException {
  PriorityException();
}

class EmptyInputException implements CoreException {
  String get message => 'El campo de texto no puede estar vacío.';
  EmptyInputException();
}

class MissingProcessException implements CoreException {
  int atLeast;
  String get message => 'Deben haber como mínimo $atLeast procesos.';
  MissingProcessException(this.atLeast);
}

class NegativeNumberException implements CoreException {
  String get message => 'No se aceptan números negativos.';
  NegativeNumberException();
}

class NotNumberException implements CoreException {
  final String notNumber;
  String get message => '$notNumber no es un número.';
  NotNumberException(this.notNumber);
}

class MissingNumbersException implements ProcessException {
  String get message => 'Mínimo tres valores para un proceso.';
  MissingNumbersException();
}

class RequiredBreaksException implements ProcessException {
  final int breaks;
  String get message => 'Se requieren $breaks interrupciones.';
  RequiredBreaksException(this.breaks);
}

class FormatBreakException implements BreakException {
  String get message => 'Solo uno o dos número por interrupción.';
  FormatBreakException();
}

class MissingBreakException implements BreakException {
  String get message => 'Faltan interrupciones.';
  MissingBreakException();
}

class ZeroBreakException implements BreakException {
  String get message => 'Una interrupción no puede ser cero.';
  ZeroBreakException();
}

class MissingPrioritiesException extends PriorityException {
  final String status;
  String get message => 'Faltan prioridades en $status.';
  MissingPrioritiesException(this.status);
}
