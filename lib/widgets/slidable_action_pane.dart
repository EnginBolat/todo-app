import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import '../model/todo_model.dart';

class SlidableActionPaneWidget extends StatelessWidget {
  const SlidableActionPaneWidget(
      {Key? key,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.label,
      required this.icon,
      required this.item,
      required this.function})
      : super(key: key);

  final Color backgroundColor;
  final Color foregroundColor;
  final String label;
  final IconData icon;
  final Todo item;
  final void Function(BuildContext)? function;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: function,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: Icons.delete,
      label: label,
    );
  }
}
