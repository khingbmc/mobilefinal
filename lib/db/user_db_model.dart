import 'package:sqflite/sqflite.dart';

final String tableName = "user";
final String columnId = "id";
final String columnUserId = "userid";
final String columnName = "name";
final String columnAge = "age";
final String columnPassword = "password";
final String columnQuote = "quote";

class UserModel{
  int id;
  String userid;
  String name;
  String age;
  String password;
  String quote;

  UserModel();

  UserModel.formMap(Map<String, dynamic> map){
    this.id = map[columnId];
    this.userid = map[columnUserId];
    this.name = map[columnName];
    this.age = map[columnAge];
    this.password = map[columnPassword];
    this.quote = map[columnQuote];
  }

  @override
  String toString(){
    return 'id: ${this.id}, userid:  ${this.userid}, name:  ${this.name}, age:  ${this.age}, password:  ${this.password}, quote:  ${this.quote}';
  }

  Map<String, dynamic> mapping(){
    Map<String, dynamic> map = {
      columnUserId: userid,
      columnName: name,
      columnPassword: password,
      columnAge: age,
      columnQuote: quote,
    };
    if (id != null){
      map[columnId] = id;
    }
    return map;
  }
}

class UserUtils{
  Database db;

  Future open(String path) async{
    db = await openDatabase(
      path, 
      version: 1,
      onCreate: (Database db, int version) async{
        await db.execute('''
        create table $tableName (
          $columnId integer primary key autoincrement,
          $columnUserId text not null unique,
          $columnName text not null,
          $columnPassword text not null,
          $columnAge text not null,
          $columnQuote text
        )
        ''');
      });
  }

  Future<UserModel> insertUser(UserModel user) async{
    user.id = await db.insert(tableName, user.mapping());
    return user;
  }

  Future<UserModel> getUser(int id) async{
    List<Map<String, dynamic>> maps = await db.query(tableName,
        columns: [columnId, columnUserId, columnName, columnPassword, columnAge, columnQuote],
        where: '$columnId = ?',
        whereArgs: [id]
        ); 
        maps.length > 0 ? new UserModel.formMap(maps.first) : null;

  }

  Future<int> deleteUser(int id) async{
    return await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id]
      );
  }

  Future<int> updateUser(UserModel user) async{
    return db.update(tableName, user.mapping(), where: '$columnId = ?', whereArgs: [user.id]);
  }

  Future<List<UserModel>> getAllUser() async{
    await this.open("user.db");
    var res = await db.query(tableName,
    columns: [columnId, columnUserId, columnName, columnPassword, columnAge, columnQuote],
    
    );
    List<UserModel> userList = res.isNotEmpty ? res.map((c) => UserModel.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();
}