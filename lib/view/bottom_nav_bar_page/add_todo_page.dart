import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_text.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  var _selectedDate;

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
                    _selectedDate == null
                        ? 'Tarih Seçilmedi!'
                        : 'Seçilen Tarih: ${DateFormat.yMMMMd().format(_selectedDate!)}',
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
            if (titleController.text.isNotEmpty &&
                descController.text.isNotEmpty) {
              descController.clear();
              titleController.clear();
              _selectedDate = DateTime.now();
              print("Title: ${titleController.text}");
              print("Desc: ${descController.text}");
              print("Tarih: ${DateFormat.yMMMMd().format(_selectedDate!)}");
              Navigator.pop(context);
            }
          },
          child: const Text("Ekle"),
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
