import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TextDateFormat extends StatefulWidget {
  const TextDateFormat({
    Key? key,
    required this.date,
    this.textColor = Colors.white,
  }) : super(key: key);
  final DateTime date;
  final Color textColor;

  @override
  State<TextDateFormat> createState() => _TextDateFormatState();
}

class _TextDateFormatState extends State<TextDateFormat> {
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = DateFormat.yMMMMd('tr');
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      dateFormat.format(widget.date),
      style: TextStyle(
        color: widget.textColor,
      ),
    );
  }
}
