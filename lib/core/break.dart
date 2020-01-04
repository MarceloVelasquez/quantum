class Break {
  int _id;
  int _value;

  Break(this._id, this._value);

  int get id => _id;
  int get value => _value;
}

class Breaks {
  List<Break> _breaks;

  Breaks(this._breaks);

  int byStage(int stage) {
    int index = _breaks.indexWhere((e) => e.value == stage);
    return index != -1 ? _breaks[index].id : null;
  }
}
