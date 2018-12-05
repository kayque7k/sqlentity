class Column<C, T, V> {
  C _column;

  T _type;

  V _value;

  Column({var column: "", var type: "", var value: ""}) {
    this._column = column;
    this._type = type;
    this._value = value;
  }

  C get column => _column;

  T get type => _type;

  V get value => _value;

  set value(V value) {
    _value = value;
  }

  set type(T value) {
    _type = value;
  }

  set column(C value) {
    _column = value;
  }
}
