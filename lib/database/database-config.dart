
import 'package:sqlentity/base-entity/entity.dart';

///The DataBaseConfig looks for the database configuration provided by the developer
class DataBaseConfig {
  String _database_name;
  int _database_version;
  static DataBaseConfig _dataBaseConfig;
  List<Entity> _entitys;

  ///config database
  DataBaseConfig() {
    if(_entitys == null)
      _entitys = new List();
  }

  ///configured instance database
  static DataBaseConfig getInstance() {
    if (_dataBaseConfig == null)
      _dataBaseConfig = DataBaseConfig();

    return _dataBaseConfig;
  }

  ///name database
  String get database_name => _database_name;

  ///set name database
  set database_name(String value) {
    _database_name = value;
  }

  ///database instantiated and configured
  DataBaseConfig get dataBaseConfig => _dataBaseConfig;

  ///set database configured
  set dataBaseConfig(DataBaseConfig value) {
    _dataBaseConfig = value;
  }

  ///database version
  int get database_version => _database_version;

  ///set database version
  set database_version(int value) {
    _database_version = value;
  }

  ///entitys configured
  List<Entity> get entitys => _entitys;

  ///set entitys configured
  set entitys(List<Entity> value) {
    _entitys = value;
  }
}
