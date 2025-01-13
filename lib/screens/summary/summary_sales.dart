// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/bloc/summary_event.dart';
import 'package:develop_resturant/screens/summary/scroll_sales.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_state.dart';
import '../../widgets/dropdown_export.dart';
import '../../widgets/dropdown_filter_button.dart';
import '../../widgets/dropdown_morefilter.dart';
import '../../widgets/dropdown_setting.dart';
import '../../widgets/dropdown_share.dart';
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
            backgroundColor: "#EEEEEE".toColor(),
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              child: Container(
                // color: "#EEEEEE".toColor(),
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height, // หรือความสูงที่ต้องการ
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ส่วนหัวข้อของหน้า
                    Text(
                      'Reports > Summary Sales',
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
                                logger.e(value);
                                logger.e(value.runtimeType);
                                getDate = value;
                                setState(() {});
                              },
                              onReportSelected: (selectedReport) {
                                // จัดการค่า Report Type ที่เลือก
                                print('Selected Report: $selectedReport');
                              },
                              initialSelectedReport: 1,
                              // showRedioReport: 1,
                            ),
                            SizedBox(width: 10),
                            MoreFilterMenu(),
                            SizedBox(width: 10),
                            SettingMenu(),
                          ],
                        ),
                        Row(
                          children: [
                            ShareMenu(),
                            SizedBox(width: 10), // ช่องว่างระหว่าง ShareMenu และ ExportMenu
                            ExportMenu(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    SingleChildScrollView(child: Container(width: 300, height: 500, child: SalesPage())),
                    // Text(getDate),
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
