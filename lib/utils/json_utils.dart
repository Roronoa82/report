// // // lib/utils/json_utils.dart
// // import 'dart:convert';

// // class JsonUtils {
// //   static Map<String, dynamic> parseJson(String jsonString) {
// //     return json.decode(jsonString) as Map<String, dynamic>;
// //   }

// //   static String toJsonString(Map<String, dynamic> data) {
// //     return json.encode(data);
// //   }
// // }

// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

// import 'dart:convert';

// import 'package:develop_resturant/screens/overall/overall_summary.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
// import '../../bloc/summary_bloc.dart';
// import '../../bloc/summary_event.dart';
// import '../../bloc/summary_state.dart';
// import 'package:intl/intl.dart';

// final logger = Logger();

// class FilterReportPage extends StatefulWidget {
//   final String selectedDate;
//   final String selectedTime;
//   final Map<String, dynamic> payments; // เพิ่มส่วนนี้
//   // final VoidCallback valuechange;

//   FilterReportPage({
//     required this.selectedDate,
//     required this.selectedTime,
//     required this.payments,
//   });

//   @override
//   _FilterReportPageState createState() => _FilterReportPageState();
// }

// class _FilterReportPageState extends State<FilterReportPage> {
//   late String _selectedDate;
//   late Map<String, dynamic> payments;
//   late DateTime? _fromDate;
//   late DateTime? _toDate;

//   @override
//   void initState() {
//     super.initState();
//     _fromDate = null;
//     _toDate = null;
//     _selectedDate = widget.selectedDate; // กำหนดวันที่เริ่มต้นจากค่าที่ได้รับ
//     // _selectedTime = widget.selectedTime;
//     payments = widget.payments; // รับค่าจาก widget
//   }

//   // ฟังก์ชันเลือกวันที่
//   // Future<void> _selectDate(BuildContext context) async {
//   //   final DateTime? picked = await showDatePicker(
//   //     context: context,
//   //     initialDate: DateTime.now(),
//   //     firstDate: DateTime(2020),
//   //     lastDate: DateTime(2101),
//   //   );
//   //   if (picked != null) {
//   //     setState(() {
//   //       _selectedDate = picked.toIso8601String().substring(0, 10); // เก็บวันที่ในรูปแบบ yyyy-MM-dd
//   //     });
//   Future<void> _pickDate(BuildContext context, {required bool isFromDate}) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//         } else {
//           _toDate = picked;
//         }
//       });
//     }
//   }

//   // Navigator.pop(context);

//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) {
//   //           logger.i('Selected Date: $_selectedDate');
//   //           logger.i('Payments: $payments');
//   //           return OverallSummaryPage(
//   //             selectedDate: _selectedDate,
//   //             payments: payments, // ส่ง payments ไปยังหน้า OverallSummaryPage
//   //           );
//   //         },
//   //       ),
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Filter Report'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Row(
//                       children: [
//                         Text('From: '),
//                         Expanded(
//                           child: TextField(
//                             readOnly: true,
//                             controller: TextEditingController(
//                               text: _fromDate != null ? DateFormat('MM/dd/yyyy').format(_fromDate!) : '',
//                             ),
//                             onTap: () => _pickDate(context, isFromDate: true),
//                             decoration: InputDecoration(
//                               hintText: 'Select date',
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Flexible(
//                     child: Row(
//                       children: [
//                         Text('To: '),
//                         Expanded(
//                           child: TextField(
//                             readOnly: true,
//                             controller: TextEditingController(
//                               text: _toDate != null ? DateFormat('MM/dd/yyyy').format(_toDate!) : '',
//                             ),
//                             onTap: () => _pickDate(context, isFromDate: false),
//                             decoration: InputDecoration(
//                               hintText: 'Select date',
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_fromDate != null && _toDate != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) {
//                           logger.i('From Date: $_fromDate');
//                           logger.i('To Date: $_toDate');
//                           logger.i('Payments: $payments');
//                           return OverallSummaryPage(
//                             selectedDate: _fromDate.toString(),
//                             payments: payments,
//                           );
//                         },
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Please select both dates')),
//                     );
//                   }
//                 },
//                 child: Text('Apply'),
//               ),
//               Expanded(
//                 child: BlocProvider(
//                   create: (context) => SummaryBloc()..add(LoadSummary()),
//                   child: BlocBuilder<SummaryBloc, SummaryState>(
//                     builder: (context, state) {
//                       if (state is SummaryLoading) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (state is SummaryLoaded) {
//                         return ListView.builder(
//                           itemCount: state.summaries.length,
//                           itemBuilder: (context, index) {
//                             final summary = state.summaries[index];
//                             final DateTime date = DateTime.parse(summary['Date']);

//                             if (_fromDate != null && _toDate != null && (date.isBefore(_fromDate!) || date.isAfter(_toDate!))) {
//                               return SizedBox.shrink();
//                             }

//                             final data = summary['Data'];
//                             Map<String, dynamic> jsonMap = json.decode(data);
//                             var payments = jsonMap['Payments'];

//                             return GestureDetector(
//                               onTap: () {
//                                 logger.t('Selected Date: $_selectedDate');
//                                 logger.t('Payments: $payments');
//                                 Navigator.pop(context);
//                               },
//                               // child: Container(
//                               //   height: 300,
//                               //   width: 300,
//                               //   child: OverallSummaryPage(
//                               //     selectedDate: _selectedDate,
//                               //     payments: payments,
//                               //   ),
//                               // ),
//                             );
//                           },
//                         );
//                       } else if (state is SummaryError) {
//                         return Center(child: Text('Error: ${state.message}'));
//                       }
//                       return Center(child: Text('No data available'));
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
