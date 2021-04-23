import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqlentity/base-entity/entity.dart';
import 'package:sqlentity/dao/i-dao.dart';
import 'package:sqlentity/database/abstract-database.dart';

///Repository
class DAO<T extends Entity?> extends AbstractRepository implements IDAO<T> {
  T? _entity;

  ///init repository
  DAO(T entity) : super() {
    this._entity = entity;
  }

  ///table
  T? get entity => _entity;

  ///insert data table
  @override
  Future<int?> insert(T entity) async {
    late var results;
    try {
      await open();
      var sql = 'INSERT INTO ${entity!.table}(';
      entity!.column.forEach((values) {
        if (values.column != entity!.column[0].column) {
          if (values == entity!.column[entity.column.length - 1])
            sql += "${values.column} ";
          else
            sql += "${values.column} ,";
        }
      });
      sql += ") VALUES (";
      entity!.column.forEach((column) {
        if (column.column != entity.column[0].column) if (column == entity.column[entity.column.length - 1])
          sql += "? ";
        else
          sql += "? ,";
      });
      sql += ")";

      await database.transaction((txn) async {
        var batch = txn.batch();
        batch.rawInsert(sql, entity.getValues());
        results = await batch.commit();
      });

      await close();
      return await results[0];
    } catch (e) {
      await close();
      return await 0;
    }
  }

  ///search data table
  @override
  Future<List<T>> select() async {
    await open();
    var select = await database.rawQuery('SELECT * FROM ${_entity!.table}');
    await close();
    return await (select.map((i) => _entity!.map(i)).toList() as FutureOr<List<T>>);
  }

  ///update data table
  @override
  Future<bool> update(T entity) async {
    try {
      await open();

      var sql = 'UPDATE ${entity!.table} SET ';
      entity.column.forEach((values) {
        if (values.column != entity.column[0].column) {
          if (values == entity.column[entity.column.length - 1])
            sql += "${values.column} = ? ";
          else
            sql += "${values.column} = ? ,";
        }
      });
      sql += " Where ${entity.column[0].column} = ${entity.column[0].value}";

      await database.transaction((txn) async {
        var batch = txn.batch();
        batch.rawUpdate(sql, entity.getValues());
        await batch.commit();
      });

      await close();
      return await true;
    } catch (e) {
      await close();
      return await false;
    }
  }

  ///delete data table
  @override
  Future<bool> delete(T entity) async {
    try {
      await open();
      var sql = 'DELETE FROM  ${entity!.table} WHERE ${entity!.column[0].column} = ${entity.column[0].value}';

      await database.transaction((txn) async {
        var batch = txn.batch();
        batch.rawDelete(sql);
        await batch.commit();
      });

      await close();
      return true;
    } catch (e) {
      await close();
      return false;
    }
  }

  ///search for id data table
  @override
  Future<T> getById(T entity) async {
    await open();
    var select = await database.rawQuery('SELECT * FROM ${_entity!.table} WHERE ${entity!.column[0].column} = ${entity!.column[0].value}');
    await close();
    return await _entity!.map(select[0]) as T;
  }

  ///count data table
  @override
  Future<int?> count() async {
    await open();
    var count = await Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT(*) FROM ${_entity!.table}"));
    await close();
    return await count;
  }
}
