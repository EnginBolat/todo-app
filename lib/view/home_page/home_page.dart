import 'package:flutter/material.dart';
import 'package:todo_app/constants/app_text.dart';
import 'package:todo_app/service/shared/shared_service.dart';

import '../../service/db/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String message = AppText.welcome;
  SharedService service = SharedService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    TodoDatabase.instance;
    getName();
    takeMessage();
  }

  void getName() async {
    changeIsLoading();
    Future.delayed(const Duration(seconds: 2));
    name = await service.getName();
    changeIsLoading();
  }

  void changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void takeMessage() {
    changeIsLoading();
    if (DateTime.now().hour > 0 && DateTime.now().hour < 12) {
      message = AppText.goodMorning;
    } else if (DateTime.now().hour > 12 && DateTime.now().hour > 18) {
      message = AppText.welcome;
    } else if (DateTime.now().hour >= 18 && DateTime.now().hour < 24) {
      message = AppText.goodNight;
    }
    changeIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "$message $name",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
