import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/service/db/database_service.dart';
import 'package:todo_app/widgets/spacer_widget.dart';
import 'package:todo_app/widgets/text_date_format.dart';

import '../../constants/app_padding.dart';
import '../../model/todo_model.dart';
import '../../service/cubit/todo_cubit.dart';

class EditTodoPage extends StatefulWidget {
  EditTodoPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    late DateTime currentDate;
    late DateTime createdDate;
    late int createdHour;

    void _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2025),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          currentDate = pickedDate;
          createdDate = currentDate;
          createdHour = pickedDate.hour;
        });
      });
    }

    return BlocProvider(
      create: (context) => TodoCubit()..getTodoById(widget.id),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left),
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetTodoById) {
                Todo? item = state.todoItem;
                currentDate = item!.createdDate;
                titleController.text = item.title;
                descController.text = item.description;
                double deviceHeight = MediaQuery.of(context).size.height;
                return Padding(
                  padding: EdgeInsets.all(AppPadding.normalValue),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        maxLength: 25,
                        decoration: const InputDecoration(
                          label: Text("Başlık"),
                        ),
                      ),
                      SpacerWidget(
                          deviceHeight: deviceHeight, coefficient: 0.02),
                      TextField(
                        controller: descController,
                        maxLines: 5,
                        maxLength: 120,
                        decoration: const InputDecoration(
                          label: Text("Açıklama"),
                        ),
                      ),
                      SpacerWidget(
                          deviceHeight: deviceHeight, coefficient: 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _presentDatePicker,
                          child: TextDateFormat(
                            date: currentDate,
                            textColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: deviceHeight * 0.05,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Güncelle",
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
