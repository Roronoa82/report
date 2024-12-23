import 'package:flutter/material.dart';

class CustomTableWidget extends StatelessWidget {
  final Widget tableWidget;
  final DateTime selectDate;

  const CustomTableWidget({
    Key? key,
    required this.tableWidget,
    required this.selectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          tableWidget,
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
