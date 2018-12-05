import 'dart:async';

import 'package:sqlentity/base-entity/entity.dart';

abstract class IDAORepository<T extends Entity>{

  Future<int> insert(T entity);

  Future<bool> update(T entity);

  Future<bool> delete(T entity);

  Future<List<T>> select();

  Future<T> getById(T entity);

  Future<int> count();
}