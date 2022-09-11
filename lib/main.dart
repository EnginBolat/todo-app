import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/app_text.dart';
import 'view/navigator_page/navigator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppText.appName,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 20,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        primarySwatch: Colors.deepPurple,
      ),
      home: const NavigatorPage(),
    );
  }
}
