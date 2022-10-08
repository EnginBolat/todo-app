import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/app_text.dart';
import 'package:todo_app/service/db/database_service.dart';
import 'package:todo_app/service/shared/shared_service.dart';
import 'package:todo_app/view/todo_details_page/todo_details_page.dart';
import 'package:todo_app/widgets/slidable_action_pane.dart';
import 'package:todo_app/widgets/spacer_widget.dart';

import '../../constants/app_padding.dart';
import '../../constants/app_radius.dart';
import '../../service/cubit/todo_cubit.dart';
import '../../widgets/todo_list_tile.dart';

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
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.minValue),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SpacerWidget(deviceHeight: deviceHeight, coefficient: 0.07),
              _buildTitleText(deviceHeight, context),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              _buildJobsText(context),
              _buildJobCounter(state, context),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              state.listTodo.isEmpty
                  ? _buildIfNoJobAvalible(deviceHeight, context)
                  : _buildIfJobAvalible(deviceHeight, state)
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildIfJobAvalible(double deviceHeight, TodoGetData state) {
    return SizedBox(
      height: deviceHeight - (deviceHeight * 0.2),
      child: ListView.builder(
        itemCount: state.listTodo.length,
        itemBuilder: (context, index) {
          final item = state.listTodo[index];
          return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableActionPaneWidget(
                    context: context,
                    backgroundColor: Theme.of(context).errorColor,
                    foregroundColor: Colors.white,
                    label: HomePageText.slidableClean,
                    icon: Icons.delete,
                    item: item,
                    function: (BuildContext context) {
                      DatabaseService()
                          .deleteTodo(item.id!)
                          .then((value) => setState(() {
                                state.listTodo.remove(item);
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
                                state.listTodo.remove(item);
                              }));
                    },
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () async {
                  _buildBottomSheet(context, item.id!);
                },
                child: TodoListTileWidget(
                  borderRadius: AppRadius.minValue,
                  createDate: item.createdDate,
                  title: item.title,
                  dateFormat: dateFormat,
                ),
              ));
        },
      ),
    );
  }

  SizedBox _buildIfNoJobAvalible(double deviceHeight, BuildContext context) {
    return SizedBox(
      height: deviceHeight * 0.5,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          HomePageText.addSometingTodo,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Padding _buildJobCounter(TodoGetData state, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.minValue),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${HomePageText.waitingTodos} ${state.listTodo.length}",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Padding _buildJobsText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.minValue),
      child: Row(
        children: [
          Text(HomePageText.todos,
              style: Theme.of(context).textTheme.headline4),
          const Icon(Icons.date_range, size: 32),
        ],
      ),
    );
  }

  SizedBox _buildTitleText(double deviceHeight, BuildContext context) {
    return SizedBox(
      height: deviceHeight * 0.04,
      child: Text(
        "${message ?? HomePageText.welcome} $name ",
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

Future<dynamic> _buildBottomSheet(BuildContext ctx, int id) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: ctx,
    builder: (bctx) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: TodoDetailsPage(id: id),
      );
    },
  );
}
