import 'package:flutter/material.dart';
import 'package:todo_app/view/add_todo_page/add_todo_page.dart';
import 'package:todo_app/view/calendar_page/calendar_page.dart';
import 'package:todo_app/view/done_page/done_page.dart';
import 'package:todo_app/view/home_page/home_page.dart';
import 'package:todo_app/view/profile_page/profile_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

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
  Widget currentPage = const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buildBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  AnimatedBottomNavigationBar _bottomNavBar() {
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

  Future<dynamic> _buildBottomSheet(BuildContext ctx) {
    return showModalBottomSheet(
      context: ctx,
      builder: (bctx) {
        return const AddTodoPage();
      },
    );
  }
}
