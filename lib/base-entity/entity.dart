import 'package:sqlentity/base-entity/column.dart';
import 'package:sqlentity/database/database-config.dart';

///Representation of the table inside
abstract class Entity {

  String table;
  List<Column<String, String, Object>> column;
  List<Column<String, String, int>> columnalter;
  List<Column<String, String, int>> columndelete;
  List<Column<String, String, int>> columncreate;
  DataBaseConfig _dataBaseConfig;

  ///set table
  Entity(this.table) {
    _dataBaseConfig = DataBaseConfig();
    column = new List();
    columnalter = new List();
    columndelete = new List();
    columncreate = new List();
    configColumn();
  }

  ///set columns
  void configColumn();

  ///create columns
  void createColumn(var name, var type, var versao) {
    columncreate.add(new Column(column: name, type: type, value: versao));
    column.add(new Column(column: name, type: type));
  }

  ///alter columns
  void alterColumn(var name, var type, var versao) {
    columnalter.add(new Column(column: name, type: type, value: versao));
    _updateFinal(name, type, versao);
  }

  ///delete columns
  void deleteColumn(var name, var versao) {
    columndelete.add(new Column(column: name, value: versao));
    _deleteFinal(name, versao);
  }

  ///update value columns
  void updateValeu(var name, {var value}) {
    column.forEach((colu) {
      if (colu.column == name) {
        colu.value = value;
        return;
      }
    });
  }

  ///update columns
  void _updateFinal(var name, var type, var versao) {
    columncreate.forEach((column) {
      if (column.column == name && _dataBaseConfig.database_version <= versao) {
        column.value = versao;
        column.type = type;
        return;
      }
    });
  }

  ///delete columns
  void _deleteFinal(var name, int versao) {
    for (int i = 0; i < columncreate.length; i++)
      if (columncreate[i].column == name && _dataBaseConfig.database_version <= versao)
        columncreate.removeAt(i);
  }

  ///values columns
  List<Object> getValues() {
    List<Object> values = new List();
    column.forEach((column) {
      if (column.column != this.column[0].column) values.add(column.value);
    });
    return values;
  }

  ///map column
  Entity map(Map<String, dynamic> map);
}
