import 'package:sqflite/sqflite.dart';

class DataBase {
  var db = openDatabase(
    'task.db', version: 1,
    onCreate: (database, version){
      print('created database');
      database.execute('create table tasks(id int primary key, title text, date date, time time, status bit);');
    },
    onOpen: (dataabse){
      print('open database');
    }
  );

}