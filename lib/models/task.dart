///This file handles everything related to a [Task]. There are two classes:
///[TaskHelper] that take care of database related functions and [Task] that
///take care of creating and changing a task.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:to_do_list/helpers/constants.dart';

///This class handles the database. Creating, reading, updating and
///deleting tasks from it.  It is a singleton, so everything time this
///class instantiate the same instance.
class TaskHelper {
  static final TaskHelper _instance = TaskHelper.internal();

  factory TaskHelper() => _instance;

  TaskHelper.internal();

  Database _db;

  ///Database getter [db] to be used throughout the file.
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
    }
    return _db;
  }

  ///This function initializes the database if it has not been created yet.
  Future<Database> initDb() async {
    final String databasePath = await getDatabasesPath();
    final path = join(databasePath, "task_list.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $TASK_TABLE ( "
        "$ID_COLUMN INTEGER PRIMARY KEY, "
        "$TITLE_COLUMN TEXT, "
        "$DONE_COLUMN TEXT, "
        "$COLOR_COLUMN TEXT)",
      );
    });
  }

  ///Saves a [Task] to the database with a unique [id].
  Future<Task> saveTask(Task task) async {
    final Database dbTask = await db;
    task.id = await dbTask.insert(TASK_TABLE, task.toMap());
    return task;
  }

  ///Recover a single [Task] from the database based on its [id].
  Future<Task> getTask(int id) async {
    final Database dbTask = await db;
    final List<Map<String, dynamic>> maps = await dbTask.query(
      TASK_TABLE,
      columns: [
        ID_COLUMN,
        TITLE_COLUMN,
        DONE_COLUMN,
        COLOR_COLUMN,
      ],
      where: "$ID_COLUMN == ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      return null;
    }
  }

  ///Deletes a [Task] from the database based on its [id].
  Future<int> deleteTask(int id) async {
    final Database dbTask = await db;
    return dbTask.delete(
      TASK_TABLE,
      where: "$ID_COLUMN = ?",
      whereArgs: [id],
    );
  }

  ///Deletes every [Task] that has a [done] property as [true].
  Future<void> deleteAllDoneTasks(List<Task> list) async {
    for (final Task task in list) {
      if (task.done) {
        await deleteTask(task.id);
      }
    }
  }

  ///Updates a given [Task] changing one or more of its parameters.
  Future<int> updateTask(Task task) async {
    final Database dbTask = await db;
    return dbTask.update(
      TASK_TABLE,
      task.toMap(),
      where: "$ID_COLUMN = ?",
      whereArgs: [task.id],
    );
  }

  ///Recovers all [Task] in database and put it into a [List].
  Future<List<Task>> getAllTasks() async {
    final Database dbTask = await db;
    final List<Map<String, dynamic>> listMap = await dbTask.rawQuery(
      "SELECT * FROM $TASK_TABLE",
    );
    final List<Task> listTask = [];
    for (final Map<String, dynamic> map in listMap) {
      listTask.add(Task.fromMap(map));
    }
    return listTask;
  }
}

///This class handles the creation and tranforming of a [Task].
///It has four fields:
///[id]: unique identifier created by the database.
///[title]: the [Task] title given by the user.
///[done]: whether the [Task] is marked as done by the user or not. When the
///[Task] is created, it is marked as false.
///[color]: a color given by the user to group similar [Task].
class Task {
  int id;
  String title;
  bool done;
  Color color;
  Task({
    this.id,
    this.title,
    this.done = false,
    this.color,
  });

  ///Creates a [Task] from a map retrieved from the database. The [color]
  ///is retrieved as a String and parsed to int to give the correct value.
  Task.fromMap(Map<String, dynamic> map) {
    id = map[ID_COLUMN] as int;
    title = map[TITLE_COLUMN] as String;
    done = map[DONE_COLUMN] == 'true';
    color = Color(int.parse(map[COLOR_COLUMN] as String));
  }

  ///Transform the [Task] to a map so it can be written to the database.
  ///Since the database cannot handle Color, it is stored with its value.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> taskMap = {
      TITLE_COLUMN: title,
      DONE_COLUMN: done.toString(),
      COLOR_COLUMN: color?.value,
    };
    if (id != null) {
      taskMap[ID_COLUMN] = id;
    }
    return taskMap;
  }

  ///Invert the [done] field of a [Task] and updates it in the database.
  Future<void> invertDone(Task task) async {
    task.done = !task.done;
    await TaskHelper().updateTask(task);
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, done: $done, color: $color)';
  }
}
