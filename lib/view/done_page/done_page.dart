import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/view/todo_details_page/todo_details_page.dart';

import '../../constants/app_padding.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_text.dart';
import '../../service/cubit/todo_cubit.dart';
import '../../service/db/database_service.dart';
import '../../widgets/slidable_action_pane.dart';
import '../../widgets/todo_list_tile.dart';

class DonePage extends StatefulWidget {
  const DonePage({Key? key}) : super(key: key);

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = DateFormat.yMMMMd('tr');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => TodoCubit()..getDoneData(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<TodoCubit, TodoState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is TodoDoneData) {
              return _buildListView(context, state, deviceHeight);
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

  SingleChildScrollView _buildListView(
      BuildContext context, TodoDoneData state, double deviceHeight) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.minValue),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildJobsText(context),
              _buildJobCounter(state.listTodo.length, context),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              state.listTodo.isNotEmpty
                  ? _buildDoneTodoListView(deviceHeight, state)
                  : _buildIfNoJobAvalible(deviceHeight, context),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildDoneTodoListView(double deviceHeight, TodoDoneData state) {
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
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  label: DonePageText.slidableNotDone,
                  icon: Icons.done,
                  item: item,
                  function: (context) {
                    item.isDone = false;
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
              onTap: () {
                _buildBottomSheet(context,item.id ?? 0);
                 },
              child: TodoListTileWidget(
                dateFormat: dateFormat,
                title: item.title,
                createDate: item.createdDate,
                borderRadius: AppRadius.minValue,
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildJobCounter(int lenght, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.minValue),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${DonePageText.complateTodoCount} $lenght",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  SizedBox _buildIfNoJobAvalible(double deviceHeight, BuildContext context) {
    return SizedBox(
      height: deviceHeight * 0.5,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          DonePageText.complateSomeTodo,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Padding _buildJobsText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.minValue),
      child: Row(
        children: [
          Text(DonePageText.complateTodo,
              style: Theme.of(context).textTheme.headline4),
          const Icon(Icons.date_range, size: 32),
        ],
      ),
    );
  }

  Future<dynamic> _buildBottomSheet(BuildContext ctx, int id) {
    return showModalBottomSheet(
      context: ctx,
      builder: (bctx) {
        return TodoDetailsPage(id: id);
      },
    );
  }
}
