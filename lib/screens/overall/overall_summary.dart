// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/bloc/summary_event.dart';
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
import 'deposit_report_page.dart';
import 'summary_table_section.dart';

class OverallSummaryPage extends StatefulWidget {
  final Map<String, dynamic> payments;
  final bool isFromSalesPage; // เพิ่มพารามิเตอร์ใหม่
  // final int selectedReport; // เพิ่ม parameter selectedReport

  OverallSummaryPage({
    required this.payments,
    this.isFromSalesPage = false,
    // this.selectedReport = 1, // รับค่า selectedReport
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
  int selectedReport = 1; // ไม่ตั้งค่าเริ่มต้น ให้รอค่าจาก DropdownFilterButton

  bool isDailyReport = false;

  void _onReportSelected(int reportType) {
    setState(() {
      selectedReport = reportType;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> filterOptions = ['All Employees', 'All Order Types', 'All Sources', 'All Sections'];
    return BlocProvider(
      create: (context) => SummaryBloc()..add(LoadSummary()),
      child: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: "#EEEEEE".toColor(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ส่วนหัวข้อของหน้า
                    Text(
                      widget.isFromSalesPage ? 'Reports > Summary Sales' : 'Reports > Overall Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
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
                                  selectedReport = selectedReportValue; // อัปเดต selectedReport
                                });
                              },
                              initialSelectedReport: selectedReport,
                            ),
                            SizedBox(width: 10),
                            MoreFilterMenu(),
                          ],
                        ),
                        Row(
                          children: [
                            ShareMenu(),
                            SizedBox(width: 10),
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
                        fontSize: 20,
                      ),
                    ),
                    // การสลับเนื้อหา
                    if (selectedReport == 1)
                      SummaryTableSection(getDate: getDate)
                    else if (selectedReport == 2)
                      DailyTableSection(getDate: getDate)
                    else
                      Center(
                        child: Text(
                          'Please select a report type',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),

                    // SummaryTableSection(getDate: getDate),
                    // SizedBox(width: 10),
                    // DailyTableSection(getDate: getDate),
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
