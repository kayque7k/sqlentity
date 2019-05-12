///Representation of the columns inside
class Column<C, T, V> {

  C column;
  T type;
  V value;

  ///init config column
  Column({column: "", var type: "", var value: ""}) {
    this.column = column;
    this.type = type;
    this.value = value;
  }
}
