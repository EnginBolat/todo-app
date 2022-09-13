import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/service/db/database_service.dart';

import '../../constants/app_text.dart';
import '../../service/db/database.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  late DatabaseService _dbService;
  late String title;
  late String description;
  late DateTime createdDate;
  late int createdHour;
  late DateFormat dateFormat;
  var _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = DateFormat.yMMMMd('tr');
    _dbService = DatabaseService();
  }

  Future addTodo() async {
    title = titleController.text;
    description = descController.text;

    final note = Todo(
      title: title,
      isDone: false,
      description: description,
      createdDate: createdDate,
    );
    await TodoDatabase.instance.create(note);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        createdDate = _selectedDate;
        createdHour = pickedDate.hour;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                AppText.addSometingTodo,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              _buildSpace(20.0),
              AddTodoTextField(
                hintText: AppText.title,
                controller: titleController,
              ),
              _buildSpace(12.0),
              AddTodoDescTextField(
                hintText: AppText.desc,
                controller: descController,
              ),
              _buildSpace(12.0),
            ],
          ),
          SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == DateTime.now()
                        ? dateFormat.format(DateTime.now())
                        : '${AppText.chosendate}: ${dateFormat.format(_selectedDate)}',
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(AppText.selectDate),
                ),
              ],
            ),
          ),
          _buildAddTodoButton(),
        ],
      ),
    );
  }

  ClipRRect _buildAddTodoButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              // addTodo();
              _dbService.addDataToDatabase(
                titleController.text,
                descController.text,
                _selectedDate,
              );
              Navigator.pop(context);
            } else {
              // if title controller is empty
            }
          },
          child: Text(AppText.add),
        ),
      ),
    );
  }
}

SizedBox _buildSpace(double height) => SizedBox(height: height);

class AddTodoTextField extends StatelessWidget {
  const AddTodoTextField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 25,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hoverColor: Theme.of(context).primaryColor,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

class AddTodoDescTextField extends StatelessWidget {
  const AddTodoDescTextField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 120,
      maxLines: 2,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        hintText: hintText,
        hoverColor: Theme.of(context).primaryColor,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
