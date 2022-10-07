import 'package:flutter/material.dart';

class SpacerWidget extends StatelessWidget {
  const SpacerWidget(
      {Key? key, required this.deviceHeight, required this.coefficient})
      : super(key: key);

  final double deviceHeight;
  final double coefficient;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight * coefficient,
    );
  }
}