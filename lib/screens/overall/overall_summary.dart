// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/bloc/summary_event.dart';
import 'package:develop_resturant/screens/overall/monthly_table_section.dart';
import 'package:develop_resturant/screens/overall/weekly_table_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_state.dart';
import '../../widgets/dropdown_export.dart';
import '../../widgets/dropdown_filter_button.dart';
import '../../widgets/dropdown_morefilter.dart';
import '../../widgets/dropdown_share.dart';
import 'daily_table_section.dart';
import 'summary_table_section.dart';

class OverallSummaryPage extends StatefulWidget {
  final Map<String, dynamic> payments;
  final bool isFromSalesPage;

  OverallSummaryPage({
    required this.payments,
    this.isFromSalesPage = false,
  });

  @override
  _OverallSummaryPageState createState() => _OverallSummaryPageState();
}

class _OverallSummaryPageState extends State<OverallSummaryPage> {
  DateTime? fromDate;
  DateTime? toDate;

  String dropdownValue = "Filters Report / Date";
  String filterDropdownValue = "More Filters";
  bool _isBottomSheetOpen = false;
  final logger = Logger();
  dynamic getDate;
  int selectedReport = 1;

  bool isDailyReport = false;

  void _onReportSelected(int reportType) {
    setState(() {
      selectedReport = reportType;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> filterOptions = ['All Employees', 'All Order Types', 'All Sources', 'All Sections'];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => SummaryBloc()..add(LoadSummary()),
      child: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: "#EEEEEE".toColor(),
            body: SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(screenWidth * 0.015),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.isFromSalesPage ? 'Reports > Summary Sales' : 'Reports > Overall Summary',
                      style: TextStyle(
                        fontSize: screenWidth * 0.013,
                        fontWeight: FontWeight.w700,
                        color: '#3C3C3C'.toColor(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            DropdownFilterButton(
                              onDateSelected: (value) {
                                getDate = value;
                                setState(() {});
                              },
                              onReportSelected: (selectedReportValue) {
                                logger.d('Selected Report: $selectedReportValue');
                                setState(() {
                                  selectedReport = selectedReportValue;
                                });
                              },
                              initialSelectedReport: selectedReport,
                            ),
                            SizedBox(width: screenWidth * 0.004),
                            MoreFilterMenu(),
                          ],
                        ),
                        Row(
                          children: [
                            ShareMenu(),
                            SizedBox(width: screenWidth * 0.004),
                            ExportMenu(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    Text(
                      "July 1, 2021 - July 31, 2021",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: '#3C3C3C'.toColor(),
                        fontSize: screenWidth * 0.01,
                      ),
                    ),
                    if (selectedReport == 1)
                      SummaryTableSection(getDate: getDate)
                    else if (selectedReport == 2)
                      DailyTableSection(getDate: getDate)
                    else if (selectedReport == 3)
                      WeeklyTableSection(getDate: getDate)
                    else if (selectedReport == 4)
                      MonthlyTableSection(getDate: getDate)
                    else
                      Center(
                        child: Text(
                          'Please select a report type',
                          style: TextStyle(fontSize: screenWidth * 0.001, color: Colors.grey),
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
