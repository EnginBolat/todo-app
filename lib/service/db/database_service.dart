import '../../model/todo_model.dart';
import 'database.dart';

abstract class IPostService {
  Future<void> addDataToDatabase(title, description, createdDate);
  Future<void> deleteTodo(noteId);
  Future<List<Todo>> getAllNotes();
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
  Future<void> deleteTodo(noteId) async {
    await TodoDatabase.instance.delete(noteId);
  }

  @override
  Future<List<Todo>> getAllNotes() async {
    return await TodoDatabase.instance.readAllNotes();
  }
}
