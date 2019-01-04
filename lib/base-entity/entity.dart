import 'package:sqlentity/base-entity/column.dart';
import 'package:sqlentity/database/database-config.dart';

///Representation of the table inside
abstract class Entity {

  String table;
  List<Column<String, String, Object>> column;
  List<Column<String, String, int>> _columnalter;
  List<Column<String, String, int>> _columndelete;
  List<Column<String, String, int>> _columncreate;
  DataBaseConfig _dataBaseConfig;

  ///set table
  Entity(this.table) {
    _dataBaseConfig = DataBaseConfig.getInstance();
    column = new List();
    _columnalter = new List();
    _columndelete = new List();
    _columncreate = new List();
    configColumn();
  }

  ///set columns
  void configColumn();

  ///create columns
  void createColumn(var name, var type, var versao) {
    _columncreate.add(new Column(column: name, type: type, value: versao));
    column.add(new Column(column: name, type: type));
  }

  ///alter columns
  void alterColumn(var name, var type, var versao) {
    _columnalter.add(new Column(column: name, type: type, value: versao));
    _updateFinal(name, type, versao);
  }

  ///delete columns
  void deleteColumn(var name, var versao) {
    _columndelete.add(new Column(column: name, value: versao));
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
    _columncreate.forEach((column) {
      if (column.column == name && _dataBaseConfig.database_version <= versao) {
        column.value = versao;
        column.type = type;
        return;
      }
    });
  }

  ///delete columns
  void _deleteFinal(var name, int versao) {
    for (int i = 0; i < _columncreate.length; i++)
      if (_columncreate[i].column == name && _dataBaseConfig.database_version <= versao)
        _columncreate.removeAt(i);
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

  List<Column<String, String, int>> get columncreate => _columncreate;
  List<Column<String, String, int>> get columndelete => _columndelete;
  List<Column<String, String, int>> get columnalter => _columnalter;
}
