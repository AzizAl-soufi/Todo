import 'package:flutter/material.dart';
import 'package:todo/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layouts/pinned_screen.dart';
import 'package:todo/layouts/home_screen.dart';
import 'package:todo/layouts/archived_screen.dart';
import 'package:sqflite/sqflite.dart';

class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitialState());

  static TaskCubit get(context) => BlocProvider.of(context);
  int id = 1;
  int currentIndex = 0;
  List<Widget> screens = const [
    Home(),
    PinnedScreen(),
    ArchivedScreen(),
  ];

  List<Widget> nullScreens = const [
    Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Column(
          children: [
            Icon(
              Icons.add_box,
              size: 80,
              color: Colors.grey,
            ),
            Text('No task Items'),
          ],
        ),
      ),
    ),
    Center(
      child: SizedBox(
        width: 150,
        height: 100,
        child: Column(
          children: [
            Icon(
              Icons.push_pin_outlined,
              size: 80,
              color: Colors.grey,
            ),
            Text('No pinned Items'),
          ],
        ),
      ),
    ),
    Center(
      child: SizedBox(
        width: 150,
        height: 100,
        child: Column(
          children: [
            Icon(
              Icons.archive,
              size: 80,
              color: Colors.grey,
            ),
            Text('No archived Items'),
          ],
        ),
      ),
    )
  ];
  List<String> titles = ['Tasks', 'Pinned', 'Archived'];

  Database? db;
  List<Map> tasks = [];
  List<Map> pinned = [];
  List<Map> archived = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(TaskChangeBottomNavBarState());
    getData(db);
  }

  createDatabase() {
    openDatabase(
      'task.db',
      version: 1,
      onCreate: (database, version) {
        print('created database');
        database.execute(
          'create table task(id int primary key, title text, date text, time text, status integer check(status in (0, 1)), archived integer check(archived in (0, 1)));',
        );
      },
      onOpen: (db) {
        print('open database');
        getData(db);
      },
    ).then((value) {
      db = value;
      emit(TaskCreateDatabaseState());
    });
  }

  insertToDataBase({
    required title,
    required date,
    required time,
    bool status = false,
    bool archive = false,
  }) {
    print("-" * 20);
    getLastId(db)
        .then((value) => print(value[0]['count(id)']))
        .catchError((error) {
      print(error.toString());
    });
    getLastId(db).then((value) => db
            ?.transaction(
          (txn) => txn.rawInsert(
            "insert into task(id, title, date, time, status, archived)"
            "values (?, ?, ?, ?, ?, ?)",
            [
              value[0]['count(id)'] + 1,
              title,
              date,
              time,
              status ? 1 : 0,
              archive ? 1 : 0
            ],
          ),
        )
            .then((value) {
          print('done insert.');
          // emit(TaskInsertDatabaseState());
          getData(db);
        }).catchError((error) {}));
  }

  Future<List<Map>> getLastId(db) async {
    return await db?.rawQuery('SELECT count(id) FROM task');
  }

  Future<List<Map>> getTasks(db) async {
    return await db?.rawQuery('SELECT * FROM task');
  }

  Future<List<Map>> getDataTask(db) async {
    return await db?.rawQuery('SELECT * FROM task where archived = 0');
  }

  Future<List<Map>> getDataPinned(db) async {
    return await db
        ?.rawQuery('SELECT * FROM task where status = 1 and archived = 0');
  }

  Future<List<Map>> getDataArchived(db) async {
    return await db?.rawQuery('SELECT * FROM task where archived = 1');
  }

  List<Map> anyTask = [];

  getData(db) {
    getDataTask(db).then((value) {
      tasks = value;
      print(tasks);
      emit(TaskGetDatabaseState());
    });
    getDataPinned(db).then((value) {
      pinned = value;
      print(pinned);
      emit(TaskGetPinnedDatabaseState());
    });
    getDataArchived(db).then((value) {
      archived = value;
      print(archived);
      emit(TaskGetArchivedDatabaseState());
    });
    getTasks(db).then((value) {
      anyTask = value;
      print(value);
    });
    emit(TaskGetDatabaseState());
  }

  void pinTask(id) async {
    await db
        ?.rawUpdate('UPDATE task SET status = 1 WHERE id = $id')
        .then((value) {
      emit(TaskPinDatabaseState());
      getData(db);
    });
  }

  void unpinTask(id) async {
    await db
        ?.rawUpdate('UPDATE task SET status = 0 WHERE id = $id')
        .then((value) {
      emit(TaskUnpinDatabaseState());
      getData(db);
    });
  }

  void doneTask(id) async {
    await db
        ?.rawUpdate('UPDATE task SET archived = 1 WHERE id = $id')
        .then((value) {
      emit(TaskDoneDatabaseState());
      getData(db);
    });
  }

  void updateTask({
    required id,
    required title,
    required date,
    required time,
    status = false,
  }) async {
    await db?.rawUpdate(
      'UPDATE task SET title = ?, date = ?, time = ?, status = ? WHERE id = $id',
      [title, date, time, status ? 1 : 0],
    ).then((value) {
      emit(TaskDoneDatabaseState());
      getData(db);
    });
  }

  void deleteTask(id) async {
    await db?.rawDelete('delete from task where id = $id').then((value) {
      emit(TaskDeleteDatabaseState());
      getData(db);
    });
  }

  bool isSheet = false;
  Icon iconFloating = const Icon(Icons.add);

  void chaneBottomCheetState({required icon, required isShow}) {
    isSheet = isShow;
    iconFloating = icon;
    emit(TaskChangeBottomSheetState());
  }
}
