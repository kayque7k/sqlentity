import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqlentity/database/database-config.dart';

import 'void-repository.dart';

///The AbstractRepository is the class that performs the interaction with the database,
///performs the updates and creation of the bank when necessary.
class Repository {
  
  static Repository _INSTANCE;
  List<VoidRepository> _activitys;

  ///create factory for singleton
  factory Repository() {
    if (_INSTANCE == null) {
      _INSTANCE = Repository._getInstance();
    }
    return _INSTANCE;
  }

  ///create singleton
  Repository._getInstance() {
    if (_activitys == null) _activitys = new List();
  }

  ///create coroutine for list of the activitys
  void coroutine(void activity()) async {
    try {
      var result = VoidRepository(activity);
      _activitys.add(result);

      await Future.microtask(() async {
        if (result == _activitys[0]) {
          await _activitys.removeAt(0);
          return await activity();
        }
      });
    } catch (e) {
      return null;
    }
  }
}
