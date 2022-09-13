part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoAdd extends TodoState {}

class TodoDelete extends TodoState {}

class TodoEdit extends TodoState {}

class TodoLoading extends TodoState {}
