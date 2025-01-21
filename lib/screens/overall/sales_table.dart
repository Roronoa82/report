// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, deprecated_member_use, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class SalesTable extends StatefulWidget {
  final dynamic selectDate;
  const SalesTable({Key? key, this.selectDate}) : super(key: key);

  @override
  _SalesTableState createState() => _SalesTableState();
}

class _SalesTableState extends State<SalesTable> {
  SalesSummary? salesSummary;
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

          double totalNetSales = 0.0;
          double totalTaxSales = 0.0;
          double totalIncomingSales = 0.0;

          Map<String, double> combinedRevenue = {};

          for (var summary in filteredSummaries) {
            Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
            var netSales = jsonMap['Sales']?['NetSales'] ?? [];
            var taxSales = jsonMap['Sales']?['TaxSales'] ?? [];
            var incomingSales = jsonMap['Sales']?['IncomingSales'] ?? [];

            totalNetSales += netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            totalTaxSales += taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            totalIncomingSales += incomingSales.fold(0.0, (sum, item) => sum + (item['Value'] as double? ?? 0.0));

            Map<String, dynamic> jsonMapRevenue = json.decode(summary['FilterByRevenue'] ?? '{}');
            var revenues = jsonMapRevenue['Revenues'] ?? [];

            for (var revenue in revenues) {
              String revenueClassName = revenue['RevenueClassName'];
              double totalValue = 0.0;
              for (var sale in revenue['NetSales']) {
                totalValue += sale['Value'];
              }
              combinedRevenue[revenueClassName] = (combinedRevenue[revenueClassName] ?? 0.0) + totalValue;
            }
          }
          salesSummary = SalesSummary(
            totalNetSales: totalNetSales,
            totalTaxSales: totalTaxSales,
            totalIncomingSales: totalIncomingSales,
            combinedRevenue: combinedRevenue,
            totalSales: totalNetSales + totalTaxSales + totalIncomingSales,
          );

          double totalSales = totalNetSales + totalTaxSales;
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
                  DataColumn(
                    label: textheader('Sales'),
                  ),
                  DataColumn(
                    label: textheader('Total'),
                  ),
                ],
                rows: [
                  ...combinedRevenue.entries.map(
                    (entry) => DataRow(
                      cells: [
                        DataCell(textdetails(entry.key)),
                        DataCell(textdetails("\$${entry.value.toStringAsFixed(2)}")),
                      ],
                    ),
                  ),
                  _buildBoldRow('Net Sales', totalNetSales),
                  _buildBoldRow('Taxes', totalTaxSales),
                  _buildLinkRow('Total Sales', totalSales),
                  DataRow(
                    cells: [
                      DataCell(
                        Text('Incoming Sales'),
                      ),
                      DataCell(
                        Text("\$${totalIncomingSales.toStringAsFixed(2)}"),
                      ),
                    ],
                  ),
                ],
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

  DataRow _buildBoldRow(String label, double value) {
    return DataRow(
      cells: [
        DataCell(
          textheader(
            label,
          ),
        ),
        DataCell(
          textdetails(
            "\$${value.toStringAsFixed(2)}",
          ),
        ),
      ],
    );
  }

  DataRow _buildLinkRow(String label, double value) {
    return DataRow(
      cells: [
        DataCell(
          textheader(
            label,
          ),
        ),
        DataCell(
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              color: '#496EE2'.toColor(),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildDividerRow() {
    return DataRow(
      cells: [
        DataCell(
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        DataCell(
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
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

class SalesSummary {
  final double totalNetSales;
  final double totalTaxSales;
  final double totalIncomingSales;
  final double totalSales;
  final Map<String, double> combinedRevenue;

  SalesSummary({
    required this.totalNetSales,
    required this.totalTaxSales,
    required this.totalIncomingSales,
    required this.combinedRevenue,
    required this.totalSales,
  });
}
