import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/app_radius.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/service/db/database_service.dart';

import '../../constants/app_padding.dart';
import '../../constants/app_text.dart';
import '../../service/db/database.dart';
import '../bottom_nav_bar_page/bottom_nav_bar_page.dart';

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
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
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
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(AppPadding.minValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  AddTodoPageText.addSometingTodo,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                _buildSpace(deviceHeight * 0.025),
                AddTodoTextField(
                  hintText: AddTodoPageText.title,
                  controller: titleController,
                ),
                _buildSpace(deviceHeight * 0.015),
                AddTodoDescTextField(
                  hintText: AddTodoPageText.desc,
                  controller: descController,
                ),
                _buildSpace(deviceHeight * 0.015),
                SizedBox(
                  height: deviceHeight * 0.08,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == DateTime.now()
                              ? dateFormat.format(DateTime.now())
                              : '${AddTodoPageText.chosendate}: ${dateFormat.format(_selectedDate)}',
                        ),
                      ),
                      TextButton(
                        onPressed: _presentDatePicker,
                        child: Text(AddTodoPageText.selectDate),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildAddTodoButton(deviceHeight * 0.05),
        ],
      ),
    );
  }

  ClipRRect _buildAddTodoButton(height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.normalValue),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              _dbService.addDataToDatabase(
                titleController.text,
                descController.text,
                _selectedDate,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBarPage(index: 2)),
              );
            } else {
              // if title controller is empty
            }
          },
          child: Text(AddTodoPageText.add),
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
        hintText: hintText,
      ),
    );
  }
}
