import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_app/constants/app_text.dart';
import 'package:todo_app/service/db/database_service.dart';

import '../../model/todo_model.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  Future<void> getData() async {
    try {
      // emit(TodoLoading());
      // Future.delayed(const Duration(seconds : 5));
      emit(TodoGetData(await DatabaseService().getAllNotes()));
    // emit(TodoLoading());
      
    } catch (e) {
      emit(
        TodoGetDataError(BlocErrorText.dataCantFetch),
      );
    }
  }
}