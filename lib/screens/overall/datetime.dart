// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/summary_bloc.dart';
// import '../../bloc/summary_event.dart';
// import '../../bloc/summary_state.dart';
// import 'package:intl/intl.dart';
// import '../../screens/overall/payments_table.dart';

// class DateTimePickerScreen extends StatefulWidget {
//   @override
//   _DateTimePickerScreenState createState() => _DateTimePickerScreenState();
// }

// class _DateTimePickerScreenState extends State<DateTimePickerScreen> {
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
//   final DateFormat _timeFormat = DateFormat('HH:mm');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select Date and Time')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // เลือกวันที่
//             ListTile(
//               title: Text('Select Date'),
//               subtitle: Text(_selectedDate != null ? _dateFormat.format(_selectedDate!) : 'No date selected'),
//               onTap: () async {
//                 final selectedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2101),
//                 );
//                 if (selectedDate != null) {
//                   setState(() {
//                     _selectedDate = selectedDate;
//                   });
//                 }
//               },
//             ),
//             // เลือกเวลา
//             ListTile(
//               title: Text('Select Time'),
//               subtitle: Text(
//                   _selectedTime != null ? _timeFormat.format(DateTime(0, 0, 0, _selectedTime!.hour, _selectedTime!.minute)) : 'No time selected'),
//               onTap: () async {
//                 final selectedTime = await showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 );
//                 if (selectedTime != null) {
//                   setState(() {
//                     _selectedTime = selectedTime;
//                   });
//                 }
//               },
//             ),
//             // ปุ่ม Apply
//             ElevatedButton(
//               onPressed: () {
//                 if (_selectedDate != null && _selectedTime != null) {
//                   final selectedDateTime = DateTime(
//                     _selectedDate!.year,
//                     _selectedDate!.month,
//                     _selectedDate!.day,
//                     _selectedTime!.hour,
//                     _selectedTime!.minute,
//                   );
//                   final formattedDate = _dateFormat.format(selectedDateTime);
//                   final formattedTime = _timeFormat.format(selectedDateTime);

//                   // ส่งวันที่และเวลาไปที่ PaymentsTable
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PaymentsTable(
//                         selectedDate: formattedDate,
//                         selectedTime: formattedTime,
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: Text('Apply'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
