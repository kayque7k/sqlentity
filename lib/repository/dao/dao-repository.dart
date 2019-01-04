import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqlentity/base-entity/entity.dart';
import 'package:sqlentity/database/abstract-database.dart';
import 'package:sqlentity/repository/dao/i-dao-repository.dart';

///Repository
class DAORepository<T extends Entity> extends AbstractRepository
    implements IDAORepository<T> {
  T _entity;

  ///init repository
  DAORepository(T entity) : super() {
    this._entity = entity;
  }

  ///table
  T get entity => _entity;

  ///insert data table
  @override
  Future<int> insert(T entity) async {
    var results;
    try {
      await open();
      var sql = 'INSERT INTO ${entity.table}(';
      entity.column.forEach((values) {
        if (values.column != entity.column[0].column) {
          if (values == entity.column[entity.column.length - 1])
            sql += "${values.column} ";
          else
            sql += "${values.column} ,";
        }
      });
      sql += ") VALUES (";
      entity.column.forEach((column) {
        if (column.column != entity.column[0].column) if (column ==
            entity.column[entity.column.length - 1])
          sql += "? ";
        else
          sql += "? ,";
      });
      sql += ")";

      await database.transaction((txn) async {
        var batch = await txn.batch();
        await batch.rawInsert(sql, entity.getValues());
        results = await batch.commit();
      });

      await close();
      return results[0];
    } catch (e) {
      await close();
      return 0;
    }
  }

  ///search data table
  @override
  Future<List<T>> select() async {
    await open();
    var select = await database.rawQuery('SELECT * FROM ${_entity.table}');
    await close();
    List<Entity> ent = await select.map((i) => _entity.map(i)).toList();
    List<T> itens = new List();
    ent.forEach((item) => itens.add(item as T));
    return itens;
  }

  ///update data table
  @override
  Future<bool> update(T entity) async {
    try {
      await open();

      var sql = 'UPDATE ${entity.table} SET ';
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
        await batch.rawUpdate(sql, entity.getValues());
        await batch.commit();
      });

      await close();
      return true;
    } catch (e) {
      await close();
      return false;
    }
  }

  ///delete data table
  @override
  Future<bool> delete(T entity) async {
    try {
      await open();
      var sql =
          'DELETE FROM  ${entity.table} WHERE ${entity.column[0].column} = ${entity.column[0].value}';

      await database.transaction((txn) async {
        var batch = txn.batch();
        await batch.rawDelete(sql);
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
    var select = await database.rawQuery(
        'SELECT * FROM ${_entity.table} WHERE ${entity.column[0].column} = ${entity.column[0].value}');
    await close();
    return _entity.map(select[0]) as T;
  }

  ///count data table
  @override
  Future<int> count() async {
    await open();
    var count = await Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT(*) FROM ${_entity.table}"));
    await close();
    return count;
  }
}
