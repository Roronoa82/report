// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/bloc/summary_event.dart';
import 'package:develop_resturant/screens/summary/scroll_sales.dart';
import 'package:develop_resturant/screens/summary/weekly_filter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_state.dart';
import '../../widgets/dropdown_export.dart';
import '../../widgets/dropdown_filter_button.dart';
import '../../widgets/dropdown_morefilter.dart';
import '../../widgets/dropdown_setting.dart';
import '../../widgets/dropdown_share.dart';
import 'details_pp_total.dart';
import 'monthly_filter.dart';

class SummarysalesPage extends StatefulWidget {
  final Map<String, dynamic> payments;
  final dynamic selectDate;

  SummarysalesPage({
    Key? key,
    this.selectDate,
    required this.payments,
  }) : super(key: key);
  @override
  _SummarysalesPageState createState() => _SummarysalesPageState();
}

class _SummarysalesPageState extends State<SummarysalesPage> {
  DateTime? fromDate;
  DateTime? toDate;

  String dropdownValue = "Filters Report / Date";
  String filterDropdownValue = "More Filters";
  final logger = Logger();
  dynamic getDate;
  int selectedReport = 2;

  // ฟังก์ชันสำหรับตรวจสอบเงื่อนไข
  bool showDetailPage = false;
  void _onReportSelected(int reportType) {
    setState(() {
      selectedReport = reportType;
    });
  }

  DateTime customDate = DateTime(2023, 8, 1);

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // List<String> filterOptions = ['All Employees', 'All Order Types', 'All Sources', 'All Sections'];
    return BlocProvider(
      create: (context) => SummaryBloc()..add(LoadSummary()),
      child: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          if (state is SummaryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SummaryLoaded) {
            final filteredSummaries = state.summaries.where((summary) {
              if (widget.selectDate != null && widget.selectDate.containsKey('filteredFromDate') && widget.selectDate.containsKey('filteredToDate')) {
                final summaryDate = DateTime.parse(summary['Date']).toLocal();
                final fromDate = DateTime.parse(widget.selectDate['filteredFromDate']).toLocal();
                final toDate = DateTime.parse(widget.selectDate['filteredToDate']).toLocal();

                return summaryDate.isAfter(fromDate.subtract(Duration(days: 1))) && summaryDate.isBefore(toDate.add(Duration(days: 1)));
              }
              return true;
            }).toList();

            if (filteredSummaries.isEmpty) {
              filteredSummaries.add({
                'Date': 'No data for the selected date',
                'Data': '{}',
              });
            }

            // ใช้วันที่ที่กำหนดเอง (customDate)
            String displayDate = formatDate(customDate);
            String reportTitle;

            if (showDetailPage) {
              reportTitle = 'Reports > Summary Sales > 3rd Party';
            } else {
              if (selectedReport == 2) {
                reportTitle = 'Reports > Summary Sales > Daily';
              } else if (selectedReport == 3) {
                reportTitle = 'Reports > Summary Sales > Weekly';
              } else if (selectedReport == 4) {
                reportTitle = 'Reports > Summary Sales > Monthly';
              } else {
                reportTitle = 'Reports > Summary Sales';
              }
            }
            return Scaffold(
              backgroundColor: "#EEEEEE".toColor(),
              body: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        reportTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: '#3C3C3C'.toColor(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (showDetailPage)
                                Container(
                                  height: 45,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color: '#FFFFFF'.toColor(),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: '#C3C3C3'.toColor(), width: 1),
                                  ),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showDetailPage = false;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: '#3C3C3C'.toColor(),
                                            size: 14,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Back',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: '#3C3C3C'.toColor(),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              DropdownFilterButton(
                                onDateSelected: (value) {
                                  getDate = value;
                                  setState(() {});
                                },
                                onReportSelected: (selectedReportValue) {
                                  print('Selected Report: $selectedReportValue');
                                  setState(() {
                                    selectedReport = selectedReportValue;
                                  });
                                },
                                initialSelectedReport: selectedReport,
                              ),
                              SizedBox(width: 10),
                              if (!showDetailPage) MoreFilterMenu(),
                              SizedBox(width: 10),
                              if (!showDetailPage) SettingMenu(),
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
                      SizedBox(
                        height: 16,
                      ),
                      Divider(),
                      if (!showDetailPage)
                        Text(
                          'Current : $displayDate', // แสดงวันที่ในรูปแบบที่ต้องการ
                          style: TextStyle(
                            fontSize: 20,
                            color: '#343A40'.toColor(),
                          ),
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      if (selectedReport == 2)
                        SingleChildScrollView(
                          child: Container(
                            width: 300,
                            height: 500,
                            child: showDetailPage
                                ? DetailPPTotal({})
                                : SalesPage(onTapDetail: () {
                                    setState(() {
                                      showDetailPage = true;
                                    });
                                  }),
                          ),
                        )
                      else if (selectedReport == 3)
                        SingleChildScrollView(
                          child: Container(
                            width: 300,
                            height: 500,
                            child: WeeklyFilterPage(
                              onTapDetail: () {},
                            ),
                          ),
                        )
                      else if (selectedReport == 4)
                        SingleChildScrollView(
                          child: Container(
                            width: 300,
                            height: 500,
                            child: MonthlyFilterPage(
                              onTapDetail: () {},
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Text(
                            'Please select a report type',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is SummaryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
