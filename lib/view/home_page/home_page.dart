import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/app_text.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/service/db/database_service.dart';
import 'package:todo_app/service/shared/shared_service.dart';
import 'package:todo_app/view/bottom_nav_bar_page/bottom_nav_bar_page.dart';

import '../../service/cubit/todo_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String? message;
  bool isDone = false;
  SharedService service = SharedService();
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    //UI
    takeMessage();
    //Date Format
    initializeDateFormatting();
    dateFormat = DateFormat.yMMMMd('tr');
  }

  Future<void> takeMessage() async {
    name = await service.getName();
    final int hour = DateTime.now().hour;
    if (hour >= 00 && hour < 12) {
      message = HomePageText.goodMorning;
    } else if (hour >= 12 && hour < 18) {
      message = HomePageText.welcome;
    } else if (hour >= 18 && hour < 24) {
      message = HomePageText.goodNight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => TodoCubit()..getData(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<TodoCubit, TodoState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is TodoGetData) {
              return _buildGetData(deviceHeight, context, state);
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

  SingleChildScrollView _buildGetData(
      double deviceHeight, BuildContext context, TodoGetData state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: deviceHeight * 0.04,
                child: Text(
                  "${message ?? HomePageText.welcome} $name ",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(HomePageText.todos,
                        style: Theme.of(context).textTheme.headline4),
                    const Icon(Icons.date_range, size: 32),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${HomePageText.waitingTodos} ${state.listTodo.length}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              state.listTodo.isEmpty
                  ? SizedBox(
                      height: deviceHeight * 0.5,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          HomePageText.addSometingTodo,
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: deviceHeight - (deviceHeight * 0.2),
                      child: ListView.builder(
                        itemCount: state.listTodo.length,
                        itemBuilder: (context, index) {
                          final item = state.listTodo[index];

                          return item.isDone == true
                              ? Text("True")
                              : Slidable(
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) {
                                          DatabaseService()
                                              .deleteTodo(item.id!)
                                              .then(
                                                (value) => Navigator
                                                    .pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BottomNavBarPage()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                ),
                                              );
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: HomePageText.slidableClean,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      child: ListTile(
                                        title: Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Text(
                                          dateFormat.format(item.createdDate),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        trailing: _BuildCheckBox(
                                          isDone: isDone,
                                          index: item.id!,
                                          item: item,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _BuildCheckBox extends StatefulWidget {
  _BuildCheckBox(
      {Key? key, required this.isDone, required this.index, required this.item})
      : super(key: key);

  bool isDone;
  final int index;
  Todo item;

  @override
  State<_BuildCheckBox> createState() => _BuildCheckBoxState();
}

class _BuildCheckBoxState extends State<_BuildCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Theme.of(context).primaryColor,
      activeColor: Colors.white,
      value: widget.isDone,
      onChanged: (value) {
        widget.isDone = !widget.isDone;
        widget.item.isDone = !widget.item.isDone;
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => const BottomNavBarPage()),
        //   (Route<dynamic> route) => false,
        // );
        print("Todo");
      },
    );
  }
}
