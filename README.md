# Sqlentity

o Sqlentity é um ORM focado em facilitar o vida do desenvolvedor, onde é possivel criar uma classe e apartir desta classe realizar a criação do banco de dados interno (sqlite) no dispositivo mobile.

# instalação
```
dependencies:
  sqlentity: ^1.0.6
```

# Exemplo em codigo
```
import 'package:flutter/material.dart';
import 'package:sqlentity/base-entity/entity.dart';
import 'package:sqlentity/database/database-config.dart';
import 'package:sqlentity/repository/dao-repository/dao-repository.dart';
import 'package:sqlentity/repository/dao-repository/i-dao-repository.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<UserEntity> users = new List();
  IDAORepository<UserEntity> _idao;

  @override
  void initState() {
    super.initState();
    initDatabase();
    _idao = new DAORepository(new UserEntity());
    initData();
  }
  
  void initDatabase() {
    DataBaseConfig dataBaseConfig = DataBaseConfig();
    dataBaseConfig.database_name = "Teste";
    dataBaseConfig.database_version = 1;
    dataBaseConfig.entitys = [new UserEntity()];
  }

  void initData() async {
    //criar a entidade
    UserEntity dart = new UserEntity(name: "DART",sobrename: "FLUTTER");
    UserEntity flutter = new UserEntity(name: "JS",sobrename: "ANGULAR");
    UserEntity android = new UserEntity(name: "JS",sobrename: "REACT");

    //realiza a inserção no banco e retorna o id
    int iddart = await _idao.insert(dart);
    var idFlutter = await _idao.insert(flutter);
    int idandroid = await _idao.insert(android);
    dart.id = iddart;
    dart.sobrename = "KOTLIN";

    //realiza a atualização da entidade no banco e retorna um status
    var isUpdate = await _idao.update(dart);
    android.id = idandroid;
    
    // realiza a exclusao no banco e retorna um status
    var isDelete = await _idao.delete(android);

    //lista de usuarios no banco
    var userlist = await _idao.select();

    //busca de usuarios especifico
    var getById = await _idao.getById(dart);

    //quantidade de usuarios
    var count = await _idao.count();
    
    if(userlist.length == count)
    //setando item local
    userlist.add(getById);
    
    setState(() {
      //setando lista
      users = userlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('DataBase'),
          ),
          body: new ListView.builder(
              padding: new EdgeInsets.all(4.0),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return new Container(
                    margin: new EdgeInsets.all(8.0),
                    child: new Center(
                        child: new Text(
                      '${users[index].name}, ${users[index].sobrename}',
                      style: new TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )));
              })),
    );
  }
}

class UserEntity extends Entity {
  int _id;
  String _name;
  String _sobrename;

  UserEntity({var id: 0, var name: "", var sobrename: ""}) : super('USER') {
    this.id = id;
    this.name = name;
    this.sobrename = sobrename;
  }

  @override
  void configColumn() {
    //O id deve ser sempre o primeiro caso queira usar as operaçoes padroes do DAO
    createColumn("ID", "INTEGER PRIMARY KEY AUTOINCREMENT", 1);

    //nova coluna
    createColumn("NAME", "TEXT", 1);
    createColumn("SOBRENAME", "TEXT", 1);
  }

  @override
  Entity map(Map<String, dynamic> map) {
    return new UserEntity(
      id: map['ID'],
      name: map['NAME'],
      sobrename: map['SOBRENAME'],
    );
  }

  int get id => _id;

  set id(int value) {
    _id = value;
    updateValeu("ID", value: id);
  }

  String get name => _name;

  set name(String value) {
    _name = value;
    updateValeu("NAME", value: _name);
  }
  
  String get sobrename => _sobrename;

  set sobrename(String value) {
    _sobrename = value;
    updateValeu("SOBRENAME", value: _sobrename);
  }
}```


## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).

