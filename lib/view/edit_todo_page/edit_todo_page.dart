import 'package:flutter/material.dart';
import 'package:todo_app/service/db/database_service.dart';
import 'package:todo_app/view/home_page/home_page.dart';
import 'package:todo_app/widgets/spacer_widget.dart';

import '../../constants/app_padding.dart';
import '../../model/todo_model.dart';
import '../../widgets/text_date_format.dart';

class EditTodoPage extends StatefulWidget {
  EditTodoPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  Todo? item;
  DateTime? currentDate;
  @override
  void initState() {
    super.initState();
    fetchDataById(widget.id);
  }

  fetchDataById(int id) async {
    item = await DatabaseService().getTodoById(id);
    titleController.text = item!.title;
    descController.text = item!.description;
    print(item!.createdDate);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    void _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2025),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          currentDate = pickedDate;
          print(currentDate);
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: deviceHeight * 0.1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              SpacerWidget(deviceHeight: deviceHeight, coefficient: 0.02),
              TextField(
                controller: descController,
                maxLines: 5,
                maxLength: 120,
                decoration: const InputDecoration(
                  label: Text("Açıklama"),
                ),
              ),
              SpacerWidget(deviceHeight: deviceHeight, coefficient: 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _presentDatePicker,
                      child: const Text("Tarih Seçiniz"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextDateFormat(
                      date: currentDate ?? DateTime.now(),
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: deviceHeight * 0.05,
                child: ElevatedButton(
                  onPressed: () async {
                    updateTodo();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  child: const Text(
                    "Güncelle",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateTodo() async {
    await DatabaseService().updateTodo(
      item!.title,
      item!.description,
      currentDate ?? item!.createdDate,
    );
  }
}
