part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {
  TodoLoading();
}

class TodoGetData extends TodoState {
  final List<Todo> listTodo;
  TodoGetData(this.listTodo);
}

class TodoDoneData extends TodoState {
  final List<Todo> listTodo;
  TodoDoneData(this.listTodo);
}

class TodoCalendarPageData extends TodoState {
  final List<Todo> listTodo;
  TodoCalendarPageData(this.listTodo);
}

class TodoGetDataError extends TodoState {
  final String errorMessage;
  TodoGetDataError(this.errorMessage);
}
