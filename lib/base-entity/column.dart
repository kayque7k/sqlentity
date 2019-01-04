///Representation of the columns inside
class Column<C, T, V> {

  C _column;
  T _type;
  V _value;

  ///init config column
  Column({var column: "", var type: "", var value: ""}) {
    this._column = column;
    this._type = type;
    this._value = value;
  }

  ///name column
  C get column => _column;

  ///type column
  T get type => _type;

  ///value column
  V get value => _value;

  ///set value column
  set value(V value) {
    _value = value;
  }

  ///set type column
  set type(T value) {
    _type = value;
  }

  ///set name column
  set column(C value) {
    _column = value;
  }
}
