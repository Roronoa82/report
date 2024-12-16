// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:develop_resturant/screens/overall/overall_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_event.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class FilterReportPage extends StatefulWidget {
  final String selectedDate;
  final DateTime fromDate;
  final DateTime toDate;
  final String selectedTime;
  // final Map<String, dynamic> payments; // เพิ่มส่วนนี้
  // final VoidCallback valuechange;

  FilterReportPage({
    required this.selectedDate,
    required this.selectedTime,
    // required this.payments,
    required this.fromDate,
    required this.toDate,
  });

  @override
  _FilterReportPageState createState() => _FilterReportPageState();
}

class _FilterReportPageState extends State<FilterReportPage> {
  late String _selectedDate;
  Map<String, dynamic> payments = {};
  // late Map<String, dynamic> payments;
  late DateTime _fromDate;
  late DateTime _toDate;
  late DateTime _tempFromDate;
  late DateTime _tempToDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;

    // ถ้าค่าวันที่มีรูปแบบที่ไม่ตรงกับรูปแบบที่ DateTime.parse() รองรับ
    // ให้ใช้ DateFormat แปลงค่าวันที่ก่อน
    _fromDate = widget.fromDate;
    _toDate = widget.toDate;
    _tempFromDate = _fromDate;
    _tempToDate = _toDate;

    // payments = widget.payments;
    logger.f(payments);
    logger.f(88888);
  }

  // ฟังก์ชันเลือกวันที่
  Future<void> _pickDate(BuildContext context, {required bool isFromDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // อัพเดตค่าของ _fromDate และ _toDate
        logger.i('11111');
        if (isFromDate) {
          _tempFromDate = picked; // เก็บค่าเป็น DateTime
        } else {
          _tempToDate = picked; // เก็บค่าเป็น DateTime
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Text('From: '),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _fromDate != null ? DateFormat('yyyy-MM-dd').format(_fromDate) : '',
                          ),
                          onTap: () => _pickDate(context, isFromDate: true),
                          decoration: InputDecoration(
                            hintText: 'Select date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: Row(
                    children: [
                      Text('To: '),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _fromDate != null ? DateFormat('yyyy-MM-dd').format(_toDate) : '',
                          ),
                          onTap: () => _pickDate(context, isFromDate: false),
                          decoration: InputDecoration(
                            hintText: 'Select date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _fromDate = _tempFromDate;
                  _toDate = _tempToDate;
                });
                BlocProvider.of<SummaryBloc>(context).add(LoadSummary());
                if (_fromDate != null && _toDate != null) {
                  final result = await showModalBottomSheet(
                    context: context,
                    builder: (context) => FilterReportPage(
                      selectedDate: '', // Provide any initial value if needed
                      selectedTime: '',
                      // payments: payments,
                      fromDate: _fromDate,
                      toDate: _toDate,
                    ),
                  );

                  if (result != null) {
                    // Retrieve the filteredDate and filteredTime from the result
                    // setState(() {
                    //   // ใช้ค่าที่ส่งคืน
                    //   _fromDate = result['filteredfromDate'] ?? _fromDate;
                    //   _toDate = result['filteredtoDate'] ?? _toDate;
                    // });
                    setState(() {
                      _fromDate = _tempFromDate;
                      _toDate = _tempToDate;
                    });
                    final filteredPayments = result['filteredPayments'];
                    final filteredFromDate = result['filteredfromDate'];
                    final filteredToDate = result['filteredtoDate'];
                    logger.w(result['filteredtoDate']);
                    Navigator.pop(context, {
                      'filteredPayments': filteredPayments ?? payments,
                      'filteredfromDate': filteredFromDate ?? _fromDate,
                      'filteredtoDate': filteredToDate ?? _toDate,
                    });
                  }
                } else {
                  // Show a message or alert that dates need to be selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select both from and to dates.')),
                  );
                }
              },
              child: Text('Apply'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocProvider(
                create: (context) {
                  logger.t('Initializing SummaryBloc with date range: $_fromDate to $_toDate');
                  logger.t('Initializing SummaryBloc with Payments: $payments');
                  return SummaryBloc()..add(LoadSummary());
                },
                child: BlocBuilder<SummaryBloc, SummaryState>(
                  builder: (context, state) {
                    if (state is SummaryLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is SummaryLoaded) {
                      return ListView.builder(
                        itemCount: state.summaries.length,
                        itemBuilder: (context, index) {
                          final summary = state.summaries[index];
                          final DateTime date = DateTime.parse(summary['Date']);
                          // logger.t('00000000000000: ${state.summaries[index]}');
                          logger.t('11111111111111111: ${summary['Date']}');
                          try {
                            final DateTime date = DateTime.parse(summary['Date']);
                            logger.t('Parsed Date: $date');
                          } catch (e) {
                            logger.e('Error parsing date: ${summary['Date']}');
                            return SizedBox.shrink(); // หยุดการแสดงผลถ้าพบข้อผิดพลาด
                          }
                          logger.e('Data: $summary');

                          // ตรวจสอบว่า date อยู่ในช่วงจาก _fromDate ถึง _toDate หรือไม่
                          if (date.isBefore(_fromDate) || date.isAfter(_toDate)) {
                            return SizedBox.shrink(); // ถ้าไม่ตรงกับช่วงวันที่ให้ไม่แสดง
                          }
                          logger.w('From Date: $_fromDate');
                          logger.w('To Date: $_toDate');
                          final data = summary['Data'];
                          logger.e('Data: $data');

                          Map<String, dynamic> jsonMap = json.decode(data);
                          var payments = jsonMap['Payments'];
                          logger.f('ghggggggggggggg$payments');
                          logger.f('sdfsdgsgs5555555555555555555');
                          var sales = jsonMap['Sales'];

                          logger.e('Error decoding JSON: $data');

                          logger.wtf('Overa8888888888888llSummaryPage: Payments: $payments');
                          return GestureDetector(
                            onTap: () {
                              print('onTap called');
                              logger.f(payments);
                              // logger.t('Selected Date: $_selectedDate');
                              // logger.t('Selected fromDate: $_fromDate');
                              // logger.t('Selected toDate: $_toDate');
                              // logger.wtf('Data: $data');
                              // logger.t('Payments: $payments');
                              // logger.t('Sales: $sales');
                              //  Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OverallSummaryPage(
                                    payments: payments,
                                    fromDate: _fromDate,
                                    toDate: _toDate,
                                    selectedDate: '',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 300,
                              width: 300,
                              child: ReportTable(
                                fromDate: _fromDate,
                                toDate: _toDate,
                                payments: payments,
                                selectedDate: '',
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is SummaryError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return Center(child: Text('No data available'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
