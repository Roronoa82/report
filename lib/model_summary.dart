import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Summary {
  final int rpOverAllSummaryID;
  final int year;
  final int month;
  final int day;
  final DateTime date;
  final List<Map<String, dynamic>> data; // เปลี่ยนจาก List<List<Map<String, dynamic>>> เป็น List<Map<String, dynamic>>
  final List<Map<String, dynamic>> filterByRevenue;
  final List<Map<String, dynamic>> filterByDiscount;
  final List<Map<String, dynamic>> filterByEmployees;
  final List<Map<String, dynamic>> filterByEmployeesAndRevenue;
  final List<Map<String, dynamic>> filterByEmployeesAndDiscount;

  Summary({
    required this.rpOverAllSummaryID,
    required this.year,
    required this.month,
    required this.day,
    required this.date,
    required this.data,
    required this.filterByRevenue,
    required this.filterByDiscount,
    required this.filterByEmployees,
    required this.filterByEmployeesAndRevenue,
    required this.filterByEmployeesAndDiscount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    // logger.t("Parsing Summary from JSON: $json");
    return Summary(
      rpOverAllSummaryID: json['RpOverAllSummaryID'],
      year: json['Year'],
      month: json['Month'],
      day: json['Day'],
      date: DateTime.parse(json['Date']),
      data: _parseJson(json['Data']), // แปลง JSON string จากฟิลด์ 'Data'
      filterByRevenue: _parseJson(json['FilterByRevenue']),
      filterByDiscount: _parseJson(json['FilterByDiscount']),
      filterByEmployees: _parseJson(json['FilterByEmployees']),
      filterByEmployeesAndRevenue: _parseJson(json['FilterByEmployeesAndRevenue']),
      filterByEmployeesAndDiscount: _parseJson(json['FilterByEmployeesAndDiscount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RpOverAllSummaryID': rpOverAllSummaryID,
      'Year': year,
      'Month': month,
      'Day': day,
      'Date': date.toIso8601String(),
      'Data': _jsonToString(data),
      'FilterByRevenue': _jsonToString(filterByRevenue),
      'FilterByDiscount': _jsonToString(filterByDiscount),
      'FilterByEmployees': _jsonToString(filterByEmployees),
      'FilterByEmployeesAndRevenue': _jsonToString(filterByEmployeesAndRevenue),
      'FilterByEmployeesAndDiscount': _jsonToString(filterByEmployeesAndDiscount),
    };
  }

  // Helper method to parse JSON string into List<Map<String, dynamic>>
  static List<Map<String, dynamic>> _parseJson(String jsonString) {
    try {
      //  logger.e("Parsing JSON: $jsonString");
      final decoded = json.decode(jsonString);

      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
      } else if (decoded is Map) {
        // ถ้าเป็น Map ให้แปลงเป็น List ที่มีแค่ 1 ไอเท็ม
        return [Map<String, dynamic>.from(decoded)];
      } else {
        throw FormatException("Expected a List but got ${decoded.runtimeType}");
      }
    } catch (e) {
      print("Error parsing JSON: $e");
      return []; // คืนค่าลิสต์ว่างในกรณีผิดพลาด
    }
  }

  // Helper method to convert List<Map<String, dynamic>> to JSON string
  static String _jsonToString(List<Map<String, dynamic>> list) {
    return json.encode(list);
  }

//  List<FlSpot> getLineChartData(Summary summary) {
//   return summary.data.map((entry) {
//     final day = entry['day'] as int; // ดึงค่า 'day'
//     final value = (entry['value'] as num).toDouble(); // ดึงค่า 'value' และแปลงเป็น double
//     return FlSpot(day.toDouble(), value);
//   }).toList();
// }
// List<BarChartGroupData> getBarChartData(Summary summary) {
//   return summary.data.asMap().entries.map((entry) {
//     final index = entry.key; // index สำหรับ x-axis
//     final value = (entry.value['value'] as num).toDouble(); // ดึงค่า 'value'
//     return BarChartGroupData(
//       x: index,
//       barRods: [BarChartRodData(toY: value, color: Colors.green)],
//     );
//   }).toList();
// }

  @override
  String toString() {
    return 'Summary{'
        'rpOverAllSummaryID: $rpOverAllSummaryID, '
        'year: $year, '
        'month: $month, '
        'day: $day, '
        'date: $date, '
        'data: $data, '
        'filterByRevenue: $filterByRevenue, '
        'filterByDiscount: $filterByDiscount, '
        'filterByEmployees: $filterByEmployees, '
        'filterByEmployeesAndRevenue: $filterByEmployeesAndRevenue, '
        'filterByEmployeesAndDiscount: $filterByEmployeesAndDiscount}';
  }
}
