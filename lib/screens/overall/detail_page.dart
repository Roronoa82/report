import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final double value;

  const DetailPage({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Page"),
      ),
      body: Center(
        child: Text(
          "Value: \$${value.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
