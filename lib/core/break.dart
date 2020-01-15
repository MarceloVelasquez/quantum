class Break {
  int _id;
  int _value;

  int get id => _id;
  int get value => _value;

  Break(this._id, this._value);
}

class Breaks {
  List<Break> _breaks;
  List<Break> get breaks => _breaks;

  Breaks(this._breaks);

  int byStage(int stage) {
    int index = _breaks.indexWhere((e) => e.value == stage * 4);
    return index != -1 ? _breaks[index].id : null;
  }
}
