// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class PaymentsTable extends StatefulWidget {
  final dynamic selectDate;
  const PaymentsTable({
    Key? key,
    this.selectDate,
  }) : super(key: key);

  @override
  _PaymentsTableState createState() => _PaymentsTableState();
}

class _PaymentsTableState extends State<PaymentsTable> {
  @override
  void initState() {
    if (widget.selectDate != null) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryBloc, SummaryState>(
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
          Map<String, Map<String, double>> paymentTotals = {};
          for (var summary in filteredSummaries) {
            Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
            var payments = jsonMap['Payments'];

            payments.forEach((paymentType, paymentData) {
              double salesTotal = paymentData['Sales']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
              double tipsTotal = paymentData['Tips']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
              double total = salesTotal + tipsTotal;

              if (!paymentTotals.containsKey(paymentType)) {
                paymentTotals[paymentType] = {'Sales': 0.0, 'Tips': 0.0, 'Total': 0.0};
              }

              paymentTotals[paymentType]?['Sales'] = (paymentTotals[paymentType]?['Sales'] ?? 0.0) + salesTotal;
              paymentTotals[paymentType]?['Tips'] = (paymentTotals[paymentType]?['Tips'] ?? 0.0) + tipsTotal;
              paymentTotals[paymentType]?['Total'] = (paymentTotals[paymentType]?['Total'] ?? 0.0) + total;
            });
          }

          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DataTable(
                columnSpacing: 20,
                headingRowHeight: 40,
                dataRowHeight: 40,
                columns: [
                  DataColumn(label: textheader('Payments')),
                  DataColumn(label: textheader('Sales')),
                  DataColumn(label: textheader('Tips')),
                  DataColumn(label: textheader('Total')),
                ],
                rows: List<DataRow>.from(
                  paymentTotals.entries.map((entry) {
                    final paymentType = entry.key;
                    final paymentTotals = entry.value;

                    return DataRow(cells: [
                      DataCell(textdetails(paymentType)),
                      DataCell(textdetails(paymentTotals == 0.0 ? "\$xx.xx" : "\$${paymentTotals['Sales']?.toStringAsFixed(2)}")),
                      DataCell(textdetails(paymentTotals == 0.0 ? "\$xx.xx" : "\$${paymentTotals['Tips']?.toStringAsFixed(2)}")),
                      DataCell(textdetails(paymentTotals == 0.0 ? "\$xx.xx" : "\$${paymentTotals['Total']?.toStringAsFixed(2)}")),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        } else if (state is SummaryError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Center(child: Text('No data available'));
      },
    );
  }

  Text textheader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: '#3C3C3C'.toColor(),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text textdetails(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: '#3C3C3C'.toColor(),
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
