// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_event.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class PaymentsTable extends StatelessWidget {
  final String selectedDate;
  final String selectedTime;

  PaymentsTable({required this.selectedDate, required this.selectedTime});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SummaryBloc()..add(LoadSummary()),
        child: BlocBuilder<SummaryBloc, SummaryState>(
          builder: (context, state) {
            if (state is SummaryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SummaryLoaded) {
              logger.t(state.summaries);
              return ListView.builder(
                itemCount: state.summaries.length,
                itemBuilder: (context, index) {
                  final summary = state.summaries[index];
                  final data = summary['Data'];
                  String filterByEmployees = summary['FilterByEmployees'];

                  Map<String, dynamic> jsonMap = json.decode(data);

                  var payments = jsonMap['Payments'];
                  //  var cash = jsonMap['cash'];
                  var incomingSales = jsonMap['Sales']['IncomingSales'];
                  //  logger.wtf('Payments: $payments');

                  Map<String, dynamic> jsonMapRevenue = json.decode(filterByEmployees);
                  var revenues = jsonMapRevenue['Payments'];

                  // ฟังก์ชันคำนวณ Total (Sales + Tips)
                  double calculateTotal(List<dynamic> sales, List<dynamic> tips) {
                    final salesTotal = sales.fold(0.0, (sum, item) => sum + (item['Value'] as double));
                    final tipsTotal = tips.fold(0.0, (sum, item) => sum + (item['Value'] as double));
                    // logger.t('$salesTotal + $tipsTotal');
                    return salesTotal + tipsTotal;
                  }

                  return Column(
                    children: [
                      Table(
                        border: TableBorder.all(),
                        children: [
                          // หัวตาราง
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
                          // แสดงข้อมูล RevenueClassName และ Total Value
                          ...payments.entries.map((entry) {
                            final paymentType = entry.key;
                            final paymentData = entry.value;
                            // คำนวณยอดรวม Sales และ Tips
                            double salesTotal = paymentData['Sales']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
                            double tipsTotal = paymentData['Tips']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
                            double total = salesTotal + tipsTotal;
                            return TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(paymentType),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(" \$${salesTotal.toStringAsFixed(2)}"), // Total Value
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(" \$${tipsTotal.toStringAsFixed(2)}"), // Revenue Class Name
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(" \$${total.toStringAsFixed(2)}"), // Revenue Class Name
                                ),
                              ],
                            );
                          }).toList(),

                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Total Summary',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    " \$${payments.entries.fold(0.0, (sum, entry) => sum + (entry.value['Sales']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0)).toStringAsFixed(2)}"),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  " \$${payments.entries.fold(0.0, (sum, entry) => sum + (entry.value['Tips']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0)).toStringAsFixed(2)}",
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  " \$${payments.entries.fold(0.0, (sum, entry) => sum + (entry.value['Sales']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0) + (entry.value['Tips']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0)).toStringAsFixed(2)}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
    );
  }
}
