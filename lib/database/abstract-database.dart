import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqlentity/database/database-config.dart';

///The AbstractRepository is the class that performs the interaction with the database,
///performs the updates and creation of the bank when necessary.
abstract class AbstractRepository {
  Database _database;
  DataBaseConfig _databaseConfig;

  ///open database
  open() async {
    _databaseConfig = DataBaseConfig.getInstance();
    _database = await _createDataBase();
  }

  ///get conection database
  Database get database => _database;

  ///close database
  Future close() async => await _database.close();

  ///create or update database
  Future<Database> _createDataBase() async {
    return await openDatabase(
        join(await getDatabasesPath(), _databaseConfig.database_name),
        version: _databaseConfig.database_version,
        onCreate: (Database db, int version) {
          _databaseConfig.entitys.forEach((entity) {
        var sql = "CREATE TABLE IF NOT EXISTS ${entity.table} (";

        entity.columncreate.forEach((column) {
          if (column.column == entity.column[entity.column.length - 1].column)
            sql += "${column.column} ${column.type}";
          else
            sql += "${column.column} ${column.type},";
        });

        sql += ")";

        try {
          db.execute(sql);
        } catch (e) {}
      });
    }, onUpgrade: (Database db, int oldVersion, int newVersion) {
      _databaseConfig.entitys.forEach((entity) {
        entity.columncreate.forEach((column) {
          if (column.value == newVersion) {
            try {
              var sql =
                  "ALTER TABLE ${entity.table} ADD ${column.column} ${column.type}";
              db.execute(sql);
            } catch (e) {}
          }
        });

        entity.columnalter.forEach((columnalter) async {
          if (columnalter.value == newVersion) {
            try {
              var sql = "CREATE TABLE IF NOT EXISTS TEMPORARY (";

              entity.columncreate.forEach((column) {
                if (column.column == columnalter.column) {
                  if (columnalter.column ==
                      entity.column[entity.column.length - 1].column)
                    sql += "${columnalter.column} ${columnalter.type}";
                  else
                    sql += "${columnalter.column} ${columnalter.type},";
                } else {
                  if (column.column ==
                      entity.column[entity.column.length - 1].column)
                    sql += "${column.column} ${column.type}";
                  else
                    sql += "${column.column} ${column.type},";
                }
              });
              sql += ")";

              db.execute(sql);

              var sqlInsert = 'INSERT INTO TEMPORARY SELECT ';

              entity.columncreate.forEach((column) {
                if (column.column == columnalter.column) {
                  if (columnalter.column ==
                      entity.column[entity.column.length - 1].column)
                    sqlInsert += "${columnalter.column}";
                  else
                    sqlInsert += "${columnalter.column},";
                } else {
                  if (column.column ==
                      entity.column[entity.column.length - 1].column)
                    sqlInsert += "${column.column}";
                  else
                    sqlInsert += "${column.column},";
                }
              });
              sqlInsert += " FROM ${entity.table}";

              db.execute(sqlInsert);

              var sqlDROP = "DROP TABLE ${entity.table}";
              db.execute(sqlDROP);

              var sqlALTER = "ALTER TABLE TEMPORARY RENAME TO ${entity.table}";
              db.execute(sqlALTER);
            } catch (e) {}
          }
        });

        entity.columndelete.forEach((columndelete) {
          if (columndelete.value == newVersion) {
            try {
              var sql = "CREATE TABLE IF NOT EXISTS TEMPORARY (";

              entity.columncreate.forEach((column) {
                if (column.column != columndelete.column) {
                  if (column.column ==
                      entity.column[entity.column.length - 1].column)
                    sql += "${column.column} ${column.type}";
                  else
                    sql += "${column.column} ${column.type},";
                }
              });

              sql += ")";

              db.execute(sql);

              var sqlInsert = 'INSERT INTO TEMPORARY SELECT ';

              entity.columncreate.forEach((column) {
                if (column.column != columndelete.column) {
                  if (column.column ==
                      entity.column[entity.column.length - 1].column)
                    sqlInsert += "${column.column}";
                  else
                    sqlInsert += "${column.column},";
                }
              });

              sqlInsert += " FROM ${entity.table}";

              db.execute(sqlInsert);

              var sqlDROP = "DROP TABLE ${entity.table}";
              db.execute(sqlDROP);

              var sqlALTER = "ALTER TABLE TEMPORARY RENAME TO ${entity.table}";
              db.execute(sqlALTER);
              db.execute(sql);
            } catch (e) {}
          }
        });
      });
    });
  }
}
