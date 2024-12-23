// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/bloc/summary_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_state.dart';
import '../../widgets/dropdown_filter_button.dart';
// import 'summary_sale_table.dart';
// import 'summary_table_section.dart';

class SummarysalesPage extends StatefulWidget {
  final Map<String, dynamic> payments;

  SummarysalesPage({
    required this.payments,
  });
  //   final dynamic getData;
  // OverallSummaryPage({required this.getData});
  @override
  _SummarysalesPageState createState() => _SummarysalesPageState();
}

class _SummarysalesPageState extends State<SummarysalesPage> {
  DateTime? fromDate;
  DateTime? toDate;

  String dropdownValue = "Filters Report / Date";
  String filterDropdownValue = "More Filters";
  bool _isBottomSheetOpen = false;
  final logger = Logger();
  dynamic getDate;
  @override
  Widget build(BuildContext context) {
    // logger.i('OverallSummaryPage: Payments: ${widget.payments}');

    List<String> filterOptions = ['All Employees', 'All Order Types', 'All Sources', 'All Sections'];
    return BlocProvider(
      create: (context) => SummaryBloc()..add(LoadSummary()),
      child: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                color: "#EEEEEE".toColor(),
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height, // หรือความสูงที่ต้องการ
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ส่วนหัวข้อของหน้า
                    const Text(
                      'Reports > Summary Sales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dropdown for Filters Report / Date
                        DropdownFilterButton(
                          onDateSelected: (value) {
                            // logger.e(value);
                            // logger.e(value.runtimeType);
                            getDate = value;
                            setState(() {});
                          },
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
                    // SalesScreen(),
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
