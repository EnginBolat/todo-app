import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/service/cubit/todo_cubit.dart';
import 'constants/app_text.dart';
import 'constants/app_theme.dart';
import 'view/navigator_page/navigator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return BlocProvider(
      create: (context) => TodoCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppText.appName,
        theme: lightTheme,
        home: const NavigatorPage(),
      ),
    );
  }
}
