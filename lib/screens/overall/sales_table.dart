// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
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
  SalesSummary? salesSummary; // ตัวแปรเก็บผลลัพธ์
  @override
  void initState() {
    // TODO: implement initState
    if (widget.selectDate != null) {
      logger.w(widget.selectDate);
      logger.w('selectDate keys: ${widget.selectDate.keys}');
      logger.w('++++++++++');
    }
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
            // ตรวจสอบคีย์วันที่
            if (widget.selectDate != null && widget.selectDate.containsKey('filteredFromDate') && widget.selectDate.containsKey('filteredToDate')) {
              final summaryDate = DateTime.parse(summary['Date']).toLocal();
              final fromDate = DateTime.parse(widget.selectDate['filteredFromDate']).toLocal();
              final toDate = DateTime.parse(widget.selectDate['filteredToDate']).toLocal();

              // เงื่อนไขการกรอง
              return summaryDate.isAfter(fromDate.subtract(Duration(days: 1))) && summaryDate.isBefore(toDate.add(Duration(days: 1)));
            }
            return true;
          }).toList();

          // รวมข้อมูลทั้งหมด
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
          // สร้างตัวแปร SalesSummary
          salesSummary = SalesSummary(
            totalNetSales: totalNetSales,
            totalTaxSales: totalTaxSales,
            totalIncomingSales: totalIncomingSales,
            combinedRevenue: combinedRevenue,
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
                    label: Text(
                      'Sales',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: [
                  ...combinedRevenue.entries.map(
                    (entry) => DataRow(
                      cells: [
                        DataCell(Text(entry.key)),
                        DataCell(Text("\$${entry.value.toStringAsFixed(2)}")),
                      ],
                    ),
                  ),
                  // _buildDividerRow(),
                  _buildBoldRow('Net Sales', totalNetSales),
                  _buildBoldRow('Taxes', totalTaxSales),
                  _buildLinkRow('Total Sales', totalSales),
                  // _buildDividerRow(),
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
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  DataRow _buildLinkRow(String label, double value) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
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
}

class SalesSummary {
  final double totalNetSales;
  final double totalTaxSales;
  final double totalIncomingSales;
  final Map<String, double> combinedRevenue;

  SalesSummary({
    required this.totalNetSales,
    required this.totalTaxSales,
    required this.totalIncomingSales,
    required this.combinedRevenue,
  });
}
