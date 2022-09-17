import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListTileWidget extends StatelessWidget {
  const TodoListTileWidget({
    Key? key,
    required this.dateFormat,
    required this.title,
    required this.createDate,
    required this.borderRadius,
  }) : super(key: key);

  final DateFormat dateFormat;
  final String title;
  final DateTime createDate;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Card(
        color: Theme.of(context).primaryColor,
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            dateFormat.format(createDate),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
