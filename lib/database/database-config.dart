import 'package:sqlentity/base-entity/entity.dart';

///The DataBaseConfig looks for the database configuration provided by the developer
class DataBaseConfig {
  String database_name;
  int database_version;
  static DataBaseConfig _DATABASE_CONFIG;
  List<Entity> entitys;

  ///configured instance database
  factory DataBaseConfig() {
    if (_DATABASE_CONFIG == null) {
      _DATABASE_CONFIG = DataBaseConfig._getInstance();
    }
    return _DATABASE_CONFIG;
  }

  DataBaseConfig._getInstance() {
    if (entitys == null) entitys = new List();
  }

  ///database instantiated and configured
  DataBaseConfig get dataBaseConfig => _DATABASE_CONFIG;

  ///set database configured
  set dataBaseConfig(DataBaseConfig value) {
    _DATABASE_CONFIG = value;
  }
}
