import 'dart:async';

import 'package:sqlentity/base-entity/entity.dart';

///Standard contract of repository
abstract class IDAO<T extends Entity>{

  ///insert data table
  Future<int> insert(T entity);

  ///update data table
  Future<bool> update(T entity);

  ///delete data table
  Future<bool> delete(T entity);

  ///search data table
  Future<List<T>> select();

  ///search for id data table
  Future<T> getById(T entity);

  ///count data table
  Future<int> count();
}