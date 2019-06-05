import 'dart:async';

import 'package:sqlentity/base-entity/entity.dart';
import 'package:sqlentity/dao/dao.dart';
import 'package:sqlentity/dao/i-dao.dart';
import 'package:sqlentity/repository/dao-repository/i-dao-repository.dart';
import 'package:sqlentity/repository/repository.dart';

///Repository
class DAORepository<T extends Entity> implements IDAORepository<T> {
  T entity;

  IDAO idao;

  DAORepository(this.entity) {
    idao = new DAO(this.entity);
  }

  ///insert data table
  @override
  Future<int> insert(T entity) async {
    try {
      var result;
      await Repository().coroutine(() async {
        try {
          result = await idao.insert(entity);
        } catch (e) {}
      });

      return await result;
    } catch (e) {
      return await 0;
    }
  }

  ///search data table
  @override
  Future<List<T>> select() async {
    try {
      var result;
      await Repository().coroutine(() async {
        try {
          result = await idao.select();
        } catch (e) {}
      });

      List<T> itens = await new List();
      await result.forEach((item) => itens.add(item as T));
      return await itens;
    } catch (e) {
      return await null;
    }
  }

  ///update data table
  @override
  Future<bool> update(T entity) async {
    try {
      var result;
      await Repository().coroutine(() async {
        try {
          result = await idao.update(entity);
        } catch (e) {}
      });

      return await result;
    } catch (e) {
      return await false;
    }
  }

  ///delete data table
  @override
  Future<bool> delete(T entity) async {
    try {
      var result;
      await Repository().coroutine(() async {
        try {
          result = await idao.delete(entity);
        } catch (e) {}
      });
      return await result;
    } catch (e) {
      return await false;
    }
  }

  ///search for id data table
  @override
  Future<T> getById(T entity) async {
    try {
      var result;
      await Repository().coroutine(() async {
        try {
          result = await idao.getById(entity);
        } catch (e) {
        }
      });
      return await result as T;
    } catch (e) {
      return await null;
    }
  }

  ///count data table
  @override
  Future<int> count() async {
    try {
      var result;
      await Repository().coroutine(() async {
        try {
          result = await idao.count();
        } catch (e) {
        }
      });
      return await result;
    } catch (e) {
      return await 0;
    }
  }
}
