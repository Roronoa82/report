// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/bloc/summary_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../bar_chart.dart';
import '../../bloc/summary_state.dart';
import '../../widgets/filter_report.dart';
import 'cradit_cart_table.dart';
import 'deposits_table.dart';
import 'filter_screen.dart';
import 'sales_table.dart';

class OverallSummaryPage extends StatefulWidget {
  final String selectedDate;
  final DateTime fromDate;
  final DateTime toDate;
  final Map<String, dynamic> payments;

  OverallSummaryPage({required this.payments, required this.selectedDate, required this.fromDate, required this.toDate});
  //   final dynamic getData;
  // OverallSummaryPage({required this.getData});
  @override
  _OverallSummaryPageState createState() => _OverallSummaryPageState();
}

class _OverallSummaryPageState extends State<OverallSummaryPage> {
  String dropdownValue = "Filters Report / Date";
  String filterDropdownValue = "More Filters";
  bool _isBottomSheetOpen = false;
  final logger = Logger();
  @override
  Widget build(BuildContext context) {
    logger.i('OverallSummaryPage: Selected Date: ${widget.selectedDate}');
    logger.i('OverallSummaryPage: Payments: ${widget.payments}');

    //logger.i('OverallSummaryPage: Payments: $payments');
    List<String> filterOptions = ['All Employees', 'All Order Types', 'All Sources', 'All Sections'];
    return BlocProvider(
      create: (context) => SummaryBloc()..add(LoadSummary()),
      child: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height, // หรือความสูงที่ต้องการ
                ),
                // color: Colors.grey[100], // สีพื้นหลังของหน้า
                // padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ส่วนหัวข้อของหน้า
                    const Text(
                      'Reports > Overall Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dropdown for Filters Report / Date
                        DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            if (!_isBottomSheetOpen) {
                              setState(() {
                                _isBottomSheetOpen = true; // ตั้งค่าเป็น true เมื่อเปิด BottomSheet
                              });
                              // เปิด FilterReportPage เพื่อเลือก filter ใหม่
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => FilterReportPage(
                                  selectedDate: '',
                                  selectedTime: '',
                                  // payments: widget.payments,
                                  fromDate: widget.fromDate,
                                  toDate: widget.toDate,
                                ),
                              ).then((filteredData) {
                                setState(() {
                                  _isBottomSheetOpen = false; // ตั้งค่าเป็น false เมื่อ BottomSheet ปิด
                                });
                                logger.w(filteredData);

                                if (filteredData != null) {
                                  setState(() {
                                    dropdownValue = filteredData['filteredFromDate'] ?? ''; // กรองข้อมูลวันที่
                                  });
                                }
                              });
                            }
                          },
                          items: <String>['Filters Report / Date'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(Icons.filter_list, size: 16),
                                  SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        // Dropdown for More Filters

                        DropdownButton<String>(
                          value: "More Filters", // Default value
                          onChanged: (String? newValue) {
                            // Handle dropdown change here
                          },
                          items: <String>['More Filters', 'All Order Types', 'All Sources', 'All Sections']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(Icons.more_horiz, size: 16),
                                  SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        // Dropdown for Share
                        DropdownButton<String>(
                          value: "Share", // Default value
                          onChanged: (String? newValue) {
                            // Handle dropdown change here
                          },
                          items: <String>['Share', 'Option 1', 'Option 2'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(Icons.share, size: 16),
                                  SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        // Dropdown for Export
                        DropdownButton<String>(
                          value: "Export", // Default value
                          onChanged: (String? newValue) {
                            // Handle dropdown change here
                          },
                          items: <String>['Export', 'Option 1', 'Option 2'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(Icons.download, size: 16),
                                  SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Expanded สำหรับเนื้อหาข้อมูล
                    Container(height: 300, color: Colors.amber, child: LineChartSample()),
                    SizedBox(height: 16),

                    Container(
                      height: 300,
                      child: SalesTable(
                        summary: {},
                      ),
                    ),
                    SizedBox(height: 16),

                    Container(
                      height: 300,
                      child: ReportTable(
                        payments: widget.payments,
                        selectedDate: '',
                        fromDate: widget.fromDate,
                        toDate: widget.fromDate,
                      ),
                      // ReportTable(
                      //   payments: payments,
                      //   selectedDate: selectedDate,
                      // ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      child: DepositsTable(),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      child: CraditCartTable(),
                    ),
                    SizedBox(height: 16),
                    Container(height: 300, color: Colors.black
                        // child:
                        ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      color: const Color.fromARGB(255, 234, 7, 255),
                      child: Center(
                        child: Text(
                          "ServiceCharge",
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      color: const Color.fromARGB(255, 255, 7, 90),
                      child: Center(
                        child: Text(
                          "Discounts",
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      color: const Color.fromARGB(255, 255, 7, 7),
                      child: Center(
                          child: Text(
                        "sales By OrderType",
                        style: TextStyle(fontSize: 50, color: Colors.black),
                      )),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      color: Color.fromARGB(255, 173, 171, 164),
                      child: Center(
                        child: Text(
                          "AverageSalePerTicket",
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      color: Color.fromARGB(255, 7, 255, 193),
                      child: Center(
                        child: Text(
                          "Gift Card",
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      height: 300,
                      color: Color.fromARGB(255, 143, 103, 255),
                      child: Center(
                        child: Text(
                          "Customers",
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// แยก widget สำหรับตาราง
class ReportTable extends StatelessWidget {
  final Map<String, dynamic> payments;
  final String selectedDate;
  final DateTime fromDate;
  final DateTime toDate;
  ReportTable({required this.payments, required this.selectedDate, required this.fromDate, required this.toDate});
  final logger = Logger();
  @override
  Widget build(BuildContext context) {
    logger.wtf('OverallSummaryPage: Selected Date: $fromDate');
    logger.wtf('OverallSummaryPage: Payments:  ${payments}');

    return SingleChildScrollView(
      child: Column(
        children: [
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Payments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Sales',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tips',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...payments.entries.map((entry) {
                final paymentType = entry.key;
                final paymentData = entry.value;
                double salesTotal = paymentData['Sales']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
                double tipsTotal = paymentData['Tips']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
                double total = salesTotal + tipsTotal;
                return TableRow(
                  children: [
                    GestureDetector(
                      // onTap: () {
                      //   logger.t('Selected Date: $selectedDate');
                      //   logger.t('Payments: $payments');
                      //   // เมื่อคลิกที่รายการนี้ ส่งข้อมูลไปยังหน้าใหม่
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => OverallSummaryPage(
                      //         selectedDate: selectedDate,
                      //         payments: payments,
                      //       ),
                      //     ),
                      //   );
                      // },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(paymentType),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(" \$${salesTotal.toStringAsFixed(2)}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(" \$${tipsTotal.toStringAsFixed(2)}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(" \$${total.toStringAsFixed(2)}"),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
