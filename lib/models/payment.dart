// import 'dart:convert';

// import 'package:flutter/material.dart';

// import '../screens/overall/payments_table.dart';

// void main() {
//   final jsonString = '''
//   {
//     "Payments": {
//       "Cash": {
//         "Sales": [{"Value": 500.0}, {"Value": 552.75}],
//         "Tips": [{"Value": 0.0}]
//       },
//       "Credit": {
//         "Sales": [{"Value": 1500.0}, {"Value": 295.51}],
//         "Tips": [{"Value": 0.0}]
//       },
//       "Check": {
//         "Sales": [],
//         "Tips": []
//       },
//       "Prepaid": {
//         "Sales": [{"Value": 186.24}],
//         "Tips": []
//       }
//     }
//   }
//   ''';

//   final jsonData = json.decode(jsonString) as Map<String, dynamic>;
//   final payments = parsePayments(jsonData);

//   // runApp(MaterialApp(home: Scaffold(body: PaymentsTable(payments: payments))));
// }

// // lib/models/payment.dart
// class Payment {
//   final String orderType;
//   final String product;
//   final double value;

//   Payment({required this.orderType, required this.product, required this.value});

//   factory Payment.fromJson(Map<String, dynamic> json) {
//     return Payment(
//       orderType: json['OrderType'],
//       product: json['Product'],
//       value: json['Value'],
//     );
//   }
// }
