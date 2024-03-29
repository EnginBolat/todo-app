// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/constants/app_padding.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/service/shared/shared_service.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_text.dart';
import '../../service/db/database_service.dart';
import '../../widgets/spacer_widget.dart';
import '../bottom_nav_bar_page/bottom_nav_bar_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SharedService service = SharedService();
  String? name;
  String? surname;
  bool isLoading = false;
  late List<Todo> _todoDoneList;
  late List<Todo> _todoList;
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  double percent = 0;

  void getDatas() async {
    changeIsLoading();
    name = await service.getName();
    surname = await service.getSurname();
    _todoList = await DatabaseService().getUncompletedTodos();
    _todoDoneList = await DatabaseService().getCompletedTodos();
    Future.delayed(const Duration(seconds: 2));
    changeIsLoading();
  }

  void changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    getDatas();
    changePercent();
  }

  void changePercent() async {
    percent = await calcTodoPercent();
  }

  void updateNames() {
    service.setName(nameController.text);
    service.setSurname(surnameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading == true
          ? CircularProgressIndicator(color: Theme.of(context).primaryColor)
          : Padding(
              padding: EdgeInsets.all(AppPadding.minValue),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfilePhoto(deviceHeight, deviceWidth, context),
                    SpacerWidget(
                      deviceHeight: deviceHeight,
                      coefficient: 0.02,
                    ),
                    _buidName(context),
                    SpacerWidget(
                      deviceHeight: deviceHeight,
                      coefficient: 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BuildInfoBox(
                          title: ProfilePageText.needTodo,
                          deviceHeight: deviceHeight,
                          deviceWidth: deviceWidth,
                          coefficientHeight: 0.15,
                          coefficientWidth: 0.4,
                          list: _todoList,
                        ),
                        BuildInfoBox(
                          title: ProfilePageText.doneTodo,
                          deviceHeight: deviceHeight,
                          deviceWidth: deviceWidth,
                          coefficientHeight: 0.15,
                          coefficientWidth: 0.4,
                          list: _todoDoneList,
                        ),
                      ],
                    ),
                    SpacerWidget(
                      deviceHeight: deviceHeight,
                      coefficient: 0.02,
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppRadius.normalValue),
                      child: Container(
                          width: deviceWidth* 0.85,
                          height: deviceHeight * 0.2,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: EdgeInsets.all(AppPadding.normalValue),
                            child: Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Expanded(
                                    child: CircularPercentIndicator(
                                      radius: 48.0,
                                      lineWidth: 6.0,
                                      animation: true,
                                      percent: percent.isNaN ? 0 : percent,
                                      center: Text(
                                        percent.isNaN
                                            ? '${((percent = 0) * 100).round()}%'
                                            : '${(percent * 100).round()}%',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      backgroundColor: Colors.white,
                                      progressColor: Colors.purpleAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    ProfilePageText.jobsPercent,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Column _buidName(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$name $surname".toUpperCase(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
        ),
        IconButton(
            onPressed: () {
              _buildUpdateName(context);
            },
            icon: const Icon(Icons.edit))
      ],
    );
  }

  Future<dynamic> _buildUpdateName(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppPadding.maxValue),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpacerWidget(
                        deviceHeight: MediaQuery.of(context).size.height,
                        coefficient: 0.05),
                    Text(UpdateNamePage.updateName),
                    SpacerWidget(
                        deviceHeight: MediaQuery.of(context).size.height,
                        coefficient: 0.05),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: CustomTextField(
                        controller: nameController,
                        hintText: ProfilePageText.yourName,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: CustomTextField(
                        controller: surnameController,
                        hintText: ProfilePageText.yourSurname,
                      ),
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppRadius.normalValue),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            updateNames();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavBarPage()),
                            );
                          },
                          child: Text(ProfilePageText.updateName),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _buildProfilePhoto(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return SizedBox(
      height: deviceHeight * 0.2,
      width: deviceWidth * 0.45,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name?.substring(0, 1) ?? "",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            Text(surname?.substring(0, 1) ?? "",
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class BuildInfoBox extends StatelessWidget {
  const BuildInfoBox({
    Key? key,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.list,
    required this.title,
    required this.coefficientHeight,
    required this.coefficientWidth,
  }) : super(key: key);

  final double deviceHeight;
  final double deviceWidth;
  final double coefficientHeight;
  final double coefficientWidth;
  final String title;
  final List<Todo> list;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Theme.of(context).primaryColor,
        height: deviceHeight * coefficientHeight,
        width: deviceWidth * coefficientWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center),
            SpacerWidget(
              deviceHeight: deviceHeight,
              coefficient: 0.01,
            ),
            Text(
              list.length.toString(),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 15,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      controller: controller,
    );
  }
}

Future<double> calcTodoPercent() async {
  // double percent = calcPercent();
  List<Todo> allTodo =
      await DatabaseService().getUncompletedTodos(); // Yapılacaklar
  List<Todo> doneTodo =
      await DatabaseService().getCompletedTodos(); // Yapılmışlar
  double percent = doneTodo.length / (doneTodo.length + allTodo.length);
  if (kDebugMode) {
    print(percent);
  }
  if (percent == 0) {
    percent = 0.toDouble();
  } else if (percent > 0) {
    percent = percent.toDouble();
  } else {
    percent = 0;
  }
  return percent;
}
