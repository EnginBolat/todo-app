// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${TodoFields.id} $idType, 
  ${TodoFields.isDone} $boolType,
  ${TodoFields.title} $textType,
  ${TodoFields.description} $textType,
  ${TodoFields.createdDate} $textType

  )
''');
  }

  Future<Todo> create(Todo note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Todo> readTodo(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;

    const orderBy = '${TodoFields.createdDate} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> updateIsDone(Todo note, bool isDone) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${TodoFields.isDone} = $isDone',
      whereArgs: [note.isDone],
    );
  }

  Future<int> update(Todo note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
