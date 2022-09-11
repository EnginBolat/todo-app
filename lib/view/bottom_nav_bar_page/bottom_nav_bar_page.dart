import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/view/celendar_page/calendar_page.dart';
import 'package:todo_app/view/done_page/done_page.dart';
import 'package:todo_app/view/home_page/home_page.dart';
import 'package:todo_app/view/profile_page/profile_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../../constants/app_text.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({Key? key}) : super(key: key);

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final List<Widget> pages = const [
    HomePage(),
    CalendarPage(),
    DonePage(),
    ProfilePage(),
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.calendar_month,
    Icons.done,
    Icons.person
  ];

  int currentIndex = 0;
  DateTime? selectedDate;
  Widget currentPage = const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buildBottomSheet(context, titleController, descController);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  AnimatedBottomNavigationBar _bottomNavBar(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: icons,
      activeIndex: currentIndex,
      activeColor: Theme.of(context).primaryColor,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      onTap: (index) => setState(() {
        currentIndex = index;
        currentPage = pages[index];
      }),
      //other params
    );
  }

  Future<dynamic> _buildBottomSheet(BuildContext context,
      TextEditingController titleController, TextEditingController desc) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'Tarih Seçilmedi!'
                            : 'Seçilen Tarih: ${DateFormat.yMMMMd().format(selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => presentDatePicker(context),
                      child: Text(AppText.selectDate),
                    ),
                  ],
                ),
              ),
              _buildAddTodoButton(),
            ],
          ),
        );
      },
    );
  }

  void presentDatePicker(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    });
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
              print("Başlık: ${titleController.text}");
              print("Açıklama: ${descController.text}");
              descController.clear();
              titleController.clear();
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
