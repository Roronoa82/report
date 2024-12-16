// import 'dart:convert';
// import 'package:flutter/services.dart';

// Future<Map<String, dynamic>> loadOverallSummaryData() async {
//   final String response = await rootBundle.loadString('assets/overall_summary.json');
//   final List<dynamic> data = json.decode(response);
//   return data[0]; // ใช้ข้อมูล Record แรก
// }
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> copyFileToAppDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/summary.json';
  final byteData = await rootBundle.load('assets/summary.json');
  final file = File(filePath);
  await file.writeAsBytes(byteData.buffer.asUint8List());
}
