import 'dart:async';

import 'void-repository.dart';

///The Repository is the class that performs the interaction with the database,
///performs the updates and creation of the bank when necessary.
class Repository {
  
  static Repository _INSTANCE;
  List<VoidRepository> _activitys;
  
  ///create factory for singleton
  factory Repository() {
    if(_INSTANCE == null) {
      _INSTANCE = Repository._getInstance();
    }
    return _INSTANCE;
  }
  
  ///create singleton
  Repository._getInstance() {
    if(_activitys == null) _activitys = new List();
  }
  
  ///create coroutine for list of the activitys
  Future coroutine(void activity()) async {
    await Future.delayed(Duration(), () async {
      await activity();
    });
  }
}
