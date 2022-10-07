import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/service/cubit/todo_cubit.dart';

import '../../model/todo_model.dart';

class TodoDetailsPage extends StatelessWidget {
  const TodoDetailsPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..getTodoById(id),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<TodoCubit, TodoState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetTodoById) {
              Todo? item = state.todoItem;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item?.title ?? ""),
                    Text(item?.description ?? ""),
                    Text(item?.createdDate.toString() ?? ""),
                    Text(item?.id.toString() ?? ""),
                  ],
                ),
              );
            } else if (state is TodoGetDataError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
