// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class DiscountsTable extends StatefulWidget {
  final dynamic selectDate;
  const DiscountsTable({Key? key, this.selectDate}) : super(key: key);

  @override
  _DiscountsTableState createState() => _DiscountsTableState();
}

class _DiscountsTableState extends State<DiscountsTable> {
  @override
  Widget build(BuildContext context) {
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

        // เก็บข้อมูล Discounts และคำนวณ
        Map<String, Map<String, dynamic>> discountSummary = {};
        double totalDiscounts = 0.0;
        double ticketCount = 0.0;
        double discountTotal = 0.0;

        for (var summary in filteredSummaries) {
          Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
          Map<String, dynamic> jsonMapDiscounts = json.decode(summary['FilterByDiscount'] ?? '{}');
          var discounts = jsonMapDiscounts['Discounts'] ?? [];

          for (var discount in discounts) {
            var discountName = discount['DiscountName'];
            var ticketList = discount['Ticket'] ?? [];
            var amountList = discount['Amount'] ?? [];

            // คำนวณ Ticket และ Amount รวม
            ticketCount = ticketList.fold(0.0, (sum, item) {
              var value = item['Value'] ?? 0.0;
              return sum + (value is double ? value : value.toDouble()); // แปลง value เป็น double หากเป็น int
            });

            discountTotal = amountList.fold(0.0, (sum, item) {
              var value = item['Value'] ?? 0.0;
              // แปลง value ให้เป็น double ถ้าไม่ใช่
              return sum + (value is double ? value : value.toDouble());
            });

            // อัปเดตรวมใน discountSummary
            if (discountSummary.containsKey(discountName)) {
              discountSummary[discountName]!['Ticket'] += ticketCount;
              discountSummary[discountName]!['Total'] += discountTotal;
            } else {
              discountSummary[discountName] = {
                'Ticket': ticketCount,
                'Total': discountTotal,
              };
            }

            // รวม totalDiscounts
            totalDiscounts += discountTotal;
          }
        }

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
              columnSpacing: 20,
              headingRowHeight: 40,
              dataRowHeight: 40,
              columns: [
                DataColumn(
                  label: Text(
                    'Discounts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ticket',
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
                // เพิ่มรายการ Discounts
                ...discountSummary.entries.map((entry) {
                  final discountName = entry.key;
                  final ticketCount = entry.value['Ticket'];
                  final discountTotal = entry.value['Total'];

                  return DataRow(cells: [
                    DataCell(Text(discountName)),
                    DataCell(Text(ticketCount.toInt().toString())),
                    DataCell(Text("\$${discountTotal.toStringAsFixed(2)}")),
                  ]);
                }).toList(),

                // แสดง Total Discounts
                DataRow(cells: [
                  DataCell(
                    Text(
                      'Total Discounts',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(Text('')), // ช่องว่างสำหรับ Ticket
                  DataCell(Text("\$${totalDiscounts.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold))),
                ]),
              ],
            ),
          ),
        );
      } else if (state is SummaryError) {
        return Center(child: Text('Error: ${state.message}'));
      }
      return Center(child: Text('No data available'));
    });
  }
}
