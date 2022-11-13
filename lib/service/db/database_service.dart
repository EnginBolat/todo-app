import 'package:sqflite/sqlite_api.dart';

import '../../model/todo_model.dart';
import 'database.dart';

abstract class IPostService {
  Future<void> addDataToDatabase(title, description, createdDate);
  Future<void> deleteTodo(id);
  Future<List<Todo>> getUncompletedTodos();
  Future<List<Todo>> getCompletedTodos();
  Future<void> changeIsDone(note);
  Future<Todo> getTodoById(id);
  Future<void> updateTodo(Todo todo);
}

class DatabaseService implements IPostService {
  @override
  Future<void> addDataToDatabase(title, description, createdDate) async {
    final note = Todo(
      title: title,
      isDone: false,
      description: description,
      createdDate: createdDate,
    );
    await TodoDatabase.instance.create(note);
  }

  @override
  Future<void> deleteTodo(id) async {
    await TodoDatabase.instance.delete(id);
  }

  @override
  Future<List<Todo>> getUncompletedTodos() async {
    List<Todo> todos = await TodoDatabase.instance.readAllTodos();
    List<Todo> isDoneFalse = [];
    for (var i = 0; i < todos.length; i++) {
      if (todos[i].isDone == false) {
        isDoneFalse.add(todos[i]);
      }
    }
    return isDoneFalse;
  }

  @override
  Future<List<Todo>> getCompletedTodos() async {
    List<Todo> todos = await TodoDatabase.instance.readAllTodos();
    List<Todo> isDoneTrue = [];
    for (var i = 0; i < todos.length; i++) {
      if (todos[i].isDone != false) {
        isDoneTrue.add(todos[i]);
      }
    }
    return isDoneTrue;
  }

  @override
  Future<void> changeIsDone(note) {
    return TodoDatabase.instance.update(note);
  }

  @override
  Future<Todo> getTodoById(id) async {
    Todo item = await TodoDatabase.instance.readTodo(id);
    Future.delayed(const Duration(seconds: 1));
    return item;
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await TodoDatabase.instance.update(todo);
  }
}
