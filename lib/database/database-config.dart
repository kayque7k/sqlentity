
import 'package:sqlentity/base-entity/entity.dart';

class DataBaseConfig {
  String _database_name;
  int _database_version;

  static DataBaseConfig _dataBaseConfig;

  List<Entity> _entitys;

  DataBaseConfig() {
    if(_entitys == null)
      _entitys = new List();
  }

  static DataBaseConfig getInstance() {
    if (_dataBaseConfig == null)
      _dataBaseConfig = DataBaseConfig();

    return _dataBaseConfig;
  }

  String get database_name => _database_name;

  set database_name(String value) {
    _database_name = value;
  }

  DataBaseConfig get dataBaseConfig => _dataBaseConfig;

  set dataBaseConfig(DataBaseConfig value) {
    _dataBaseConfig = value;
  }

  int get database_version => _database_version;

  set database_version(int value) {
    _database_version = value;
  }

  List<Entity> get entitys => _entitys;

  set entitys(List<Entity> value) {
    _entitys = value;
  }
}
