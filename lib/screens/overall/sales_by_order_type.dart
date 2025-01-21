// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class SalesByOrderTypeTable extends StatefulWidget {
  final dynamic selectDate;
  const SalesByOrderTypeTable({Key? key, this.selectDate}) : super(key: key);

  @override
  _SalesByOrderTypeTableState createState() => _SalesByOrderTypeTableState();
}

class _SalesByOrderTypeTableState extends State<SalesByOrderTypeTable> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<SummaryBloc, SummaryState>(builder: (context, state) {
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
          return Center(child: Text('No data for the selected date'));
        }

        Map<String, double> salesByOrderType = {
          'DineIn': 0.0,
          'Togo': 0.0,
          'Delivery': 0.0,
        };

        for (var summary in filteredSummaries) {
          Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
          var salebyordertype = jsonMap['SalebyOrderType'];

          if (salebyordertype != null) {
            salebyordertype.forEach((key, value) {
              if (value['Total'] != null) {
                for (var totalItem in value['Total']) {
                  final orderType = totalItem['OrderType'];
                  final orderValue = totalItem['Value'];

                  if (salesByOrderType.containsKey(orderType)) {
                    salesByOrderType[orderType] = salesByOrderType[orderType]! + orderValue;
                  }
                }
              }
            });
          }
        }
        double totalSales = salesByOrderType.values.reduce((a, b) => a + b);

        final rows = salesByOrderType.entries.map((entry) {
          String orderType = entry.key;
          double totalValue = entry.value;
          double averagePercentage = (totalValue / totalSales) * 100;

          return DataRow(cells: [
            DataCell(textdetails(orderType)),
            DataCell(textdetails(averagePercentage.toStringAsFixed(2) + '%')),
            DataCell(textdetails("\$${totalValue.toStringAsFixed(2)}")),
          ]);
        }).toList();

        rows.add(DataRow(cells: [
          DataCell(textheader('Total Sales')),
          DataCell(Text('')),
          DataCell(textheader("\$${totalSales.toStringAsFixed(2)}")),
        ]));

        // สร้าง DataTable
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
              columnSpacing: screenWidth * 0.05,
              headingRowHeight: 40,
              dataRowHeight: 40,
              columns: [
                DataColumn(
                  label: textheader('Sales by Order \nType'),
                ),
                DataColumn(
                  label: textheader('Average \npercentage'),
                ),
                DataColumn(
                  label: textheader('Total'),
                ),
              ],
              rows: rows,
            ),
          ),
        );
      } else if (state is SummaryError) {
        return Center(child: Text('Error: ${state.message}'));
      }
      return Center(child: Text('No data available'));
    });
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
