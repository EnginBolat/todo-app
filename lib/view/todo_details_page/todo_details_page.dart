import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/app_padding.dart';
import 'package:todo_app/constants/app_radius.dart';
import 'package:todo_app/service/cubit/todo_cubit.dart';
import 'package:todo_app/view/edit_todo_page/edit_todo_page.dart';
import 'package:todo_app/widgets/spacer_widget.dart';
import 'package:todo_app/widgets/text_date_format.dart';

import '../../model/todo_model.dart';

class TodoDetailsPage extends StatelessWidget {
  const TodoDetailsPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..getTodoById(id),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left),
            color: Colors.black,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(AppPadding.minValue),
              child: IconButton(
                onPressed: () {
                  _buildBottomSheet(context, id);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EditTodoPage(id: id)));
                },
                icon: const Icon(Icons.edit),
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetTodoById) {
                Todo? item = state.todoItem;
                return _buildTodoDetails(item, context);
              } else if (state is TodoGetDataError) {
                return _buildErrorWidget(state);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTodoDetails(Todo? item, BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.normalValue),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                item?.title.toUpperCase() ?? "",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SpacerWidget(
              deviceHeight: MediaQuery.of(context).size.height,
              coefficient: 0.05,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                AppRadius.maxValue,
              ),
              child: Container(
                height: deviceHeight * 0.3,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.maxValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AÇIKLAMA",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                      ),
                      SpacerWidget(
                        deviceHeight: deviceHeight,
                        coefficient: 0.02,
                      ),
                      item!.description.isEmpty
                          ? Text(
                              "Açıklama Bulunamadı",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            )
                          : Text(
                              item.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                      SpacerWidget(
                        deviceHeight: deviceHeight,
                        coefficient: 0.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          item.isDone
                              ? const Text(
                                  "Tamamlandı",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Tamamlanmadı",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextDateFormat(
                              date: item.createdDate,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Center _buildErrorWidget(TodoGetDataError state) =>
      Center(child: Text(state.errorMessage));
}

Future<dynamic> _buildBottomSheet(BuildContext ctx, int id) {
  return showModalBottomSheet(
    context: ctx,
    builder: (bctx) {
      return FractionallySizedBox(
        heightFactor: 2,
        child: EditTodoPage(id: id),
      );
    },
  );
}
