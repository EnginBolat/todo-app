import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/app_padding.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top:AppPadding.maxValue),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
            Center(
              child: Text("CalendarPage"),
            ),
          ],
        ),
      ),
    );
  }
}
