import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/app_padding.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_text.dart';
import '../../service/cubit/todo_cubit.dart';
import '../../service/db/database_service.dart';
import '../../widgets/slidable_action_pane.dart';
import '../../widgets/todo_list_tile.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    initializeDateFormatting();
    dateFormat = DateFormat.yMMMMd('tr');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => TodoCubit()..getCalendarPageData(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<TodoCubit, TodoState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is TodoCalendarPageData) {
              return _buildCalendarColumn(
                state,
                deviceHeight,
                context,
              );
            } else if (state is TodoGetDataError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Padding _buildCalendarColumn(
    TodoCalendarPageData state,
    double deviceHeight,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: AppPadding.minValue),
      child: Column(
        children: [
          _buildCalendar(state),
          Padding(
            padding: EdgeInsets.all(AppPadding.minValue),
            child: state.listTodo!.isEmpty
                ? _buildIfJobNotAvalible()
                : _buildIfJobAvalible(deviceHeight, state),
          )
        ],
      ),
    );
  }

  Center _buildIfJobNotAvalible() {
    return Center(
      child: Text(
        CalendarPageText.todayYouHaveNotAnyJob,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  SingleChildScrollView _buildIfJobAvalible(
      double deviceHeight, TodoCalendarPageData state) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: (deviceHeight * 0.7) - 364,
            child: ListView.builder(
              itemCount: state.listTodo?.length,
              itemBuilder: (context, index) {
                var item = state.listTodo?[index];
                return item?.createdDate.day == _focusedDay.day
                    ? Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableActionPaneWidget(
                              context: context,
                              backgroundColor: Theme.of(context).errorColor,
                              foregroundColor: Colors.white,
                              label: HomePageText.slidableClean,
                              icon: Icons.delete,
                              item: item!,
                              function: (BuildContext context) {
                                DatabaseService()
                                    .deleteTodo(item.id!)
                                    .then((value) => setState(() {
                                          state.listTodo!.remove(item);
                                        }));
                              },
                            ),
                            SlidableActionPaneWidget(
                              context: context,
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              label: HomePageText.slidableDone,
                              icon: Icons.done,
                              item: item,
                              function: (BuildContext context) {
                                item.isDone = true;
                                final itemCopy = item.copy(
                                    title: item.title,
                                    createdDate: item.createdDate,
                                    description: item.description,
                                    isDone: item.isDone);
                                DatabaseService()
                                    .changeIsDone(itemCopy)
                                    .then((value) => setState(() {
                                          state.listTodo!.remove(item);
                                        }));
                              },
                            ),
                          ],
                        ),
                        child: TodoListTileWidget(
                          borderRadius: AppRadius.minValue,
                          createDate: item.createdDate,
                          title: item.title,
                          dateFormat: dateFormat,
                        ),
                      )
                    : Container(
                        color: Colors.transparent,
                        height: 1,
                      );
              },
            ),
          )
        ],
      ),
    );
  }

  TableCalendar<dynamic> _buildCalendar(TodoCalendarPageData state) {
    return TableCalendar(
      firstDay: state.listTodo!.isNotEmpty
          ? state.listTodo![0].createdDate
          : DateTime.now(),
      lastDay: state.listTodo!.isNotEmpty
          ? state.listTodo![(state.listTodo!.length - 1)].createdDate
          : DateTime.now(),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.month,
    );
  }
}
