import 'package:flutter/material.dart';
import 'package:todo_app/view/intro_page/intro_page.dart';

import '../../service/shared/shared_service.dart';
import '../bottom_nav_bar_page/bottom_nav_bar_page.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  final SharedService service = SharedService();
  bool? isLogin;
  bool isLoading = false;

  @override
  void initState() {
    getLogin();
    super.initState();
  }

  void getLogin() async {
    changeIsLoading();
    Future.delayed(const Duration(seconds: 2));
    isLogin = await service.getLogin();
    setState(() => isLogin);
    changeIsLoading();
  }

  void changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )
          : isLogin != true
              ? IntroPage()
              : const BottomNavBarPage(index: 0),
    );
  }
}
