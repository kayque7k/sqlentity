import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqlentity/database/database-config.dart';

///The AbstractRepository is the class that performs the interaction with the database,
///performs the updates and creation of the bank when necessary.
abstract class AbstractRepository {
  late Database database;
  late DataBaseConfig _databaseConfig;

  ///open database
  open() async {
    _databaseConfig = await DataBaseConfig();
    database = await _createDataBase();
  }

  ///close database
  Future close() async => await database.close();

  ///create or update database
  Future<Database> _createDataBase() async {
    return await openDatabase(
        join(await getDatabasesPath(),
            _databaseConfig.database_name),
        version: _databaseConfig.database_version,
        singleInstance: true,
        onCreate: (Database db, int version) async {
      for (var entity in _databaseConfig.entitys!) {
        var sql = "CREATE TABLE IF NOT EXISTS ${entity.table} (";

        entity.columncreate.forEach((column) {
          if (column.column == entity.column[entity.column.length - 1].column)
            sql += "${column.column} ${column.type}";
          else
            sql += "${column.column} ${column.type},";
        });

        sql += ")";

        try {
          await db.transaction((txn) async {
            var batch = txn.batch();
            batch.execute(sql);
            await batch.commit();
          });
        } catch (e) {}
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var entity in _databaseConfig.entitys!) {
        for (var column in entity.columncreate) {
          if (column.value == newVersion) {
            try {
              var sql = "ALTER TABLE ${entity.table} ADD ${column.column} ${column.type}";

              await db.transaction((txn) async {
                var batch = txn.batch();
                batch.execute(sql);
                await batch.commit();
              });
            } catch (e) {}
          }
        }

        for (var columnalter in entity.columnalter) {
          if (columnalter.value == newVersion) {
            try {
              var sql = "CREATE TABLE IF NOT EXISTS TEMPORARY (";

              entity.columncreate.forEach((column) {
                if (column.column == columnalter.column) {
                  if (columnalter.column == entity.column[entity.column.length - 1].column)
                    sql += "${columnalter.column} ${columnalter.type}";
                  else
                    sql += "${columnalter.column} ${columnalter.type},";
                } else {
                  if (column.column == entity.column[entity.column.length - 1].column)
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
                  if (columnalter.column == entity.column[entity.column.length - 1].column)
                    sqlInsert += "${columnalter.column}";
                  else
                    sqlInsert += "${columnalter.column},";
                } else {
                  if (column.column == entity.column[entity.column.length - 1].column)
                    sqlInsert += "${column.column}";
                  else
                    sqlInsert += "${column.column},";
                }
              });

              await db.transaction((txn) async {
                var batch = txn.batch();
                sqlInsert += " FROM ${entity.table}";
                batch.execute(sqlInsert);
                var sqlDROP = "DROP TABLE ${entity.table}";
                batch.execute(sqlDROP);
                var sqlALTER = "ALTER TABLE TEMPORARY RENAME TO ${entity.table}";
                batch.execute(sqlALTER);
                await batch.commit();
              });
            } catch (e) {}
          }
        }

        for (var columndelete in entity.columndelete) {
          if (columndelete.value == newVersion) {
            try {
              var sql = "CREATE TABLE IF NOT EXISTS TEMPORARY (";

              entity.columncreate.forEach((column) {
                if (column.column != columndelete.column) {
                  if (column.column == entity.column[entity.column.length - 1].column)
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
                  if (column.column == entity.column[entity.column.length - 1].column)
                    sqlInsert += "${column.column}";
                  else
                    sqlInsert += "${column.column},";
                }
              });

              try {
                await db.transaction((txn) async {
                  var batch = txn.batch();
                  sqlInsert += " FROM ${entity.table}";
                  batch.execute(sqlInsert);
                  var sqlDROP = "DROP TABLE ${entity.table}";
                  batch.execute(sqlDROP);
                  var sqlALTER = "ALTER TABLE TEMPORARY RENAME TO ${entity.table}";
                  batch.execute(sqlALTER);
                  batch.execute(sql);
                  await batch.commit();
                });
              } catch (e) {}
            } catch (e) {}
          }
        }
      }
    });
  }
}
