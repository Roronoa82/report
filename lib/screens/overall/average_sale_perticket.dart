import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class AverageSalePerTicketTable extends StatefulWidget {
  final dynamic selectDate;
  const AverageSalePerTicketTable({Key? key, this.selectDate}) : super(key: key);

  @override
  _AverageSalePerTicketTableState createState() => _AverageSalePerTicketTableState();
}

class _AverageSalePerTicketTableState extends State<AverageSalePerTicketTable> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.selectDate != null) {
      // logger.w(widget.selectDate);
      // logger.w('selectDate keys: ${widget.selectDate.keys}');
      // logger.w('++++++++++');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryBloc, SummaryState>(
      builder: (context, state) {
        if (state is SummaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SummaryLoaded) {
          final filteredSummaries = state.summaries.where((summary) {
            if (widget.selectDate != null && widget.selectDate.containsKey('filteredFromDate') && widget.selectDate.containsKey('filteredToDate')) {
              final summaryDate = DateTime.parse(summary['Date']).toLocal();
              final fromDate = DateTime.parse(widget.selectDate['filteredFromDate']).toLocal();
              final toDate = DateTime.parse(widget.selectDate['filteredToDate']).toLocal();

              return summaryDate.isAfter(fromDate.subtract(const Duration(days: 1))) && summaryDate.isBefore(toDate.add(const Duration(days: 1)));
            }
            return true;
          }).toList();

          if (filteredSummaries.isEmpty) {
            return const Center(child: Text('No data for the selected date'));
          }

          // เก็บข้อมูลคำนวณยอดรวม
          double totalSales = 0.0;
          double totalTickets = 0.0;
          double totalAverage = 0.0;

          final Map<String, Map<String, double>> averagesaleperticketSummary = {};

          // รวมข้อมูลจากทุก summary ที่กรองแล้ว
          for (var summary in filteredSummaries) {
            Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
            var averageSalePerTicket = jsonMap['AverageSalePerTicket'] ?? {};

            averageSalePerTicket.forEach((type, data) {
              var sales = (data['Sale'] as List).map((sale) => (sale['Value'] as num).toDouble()).fold(0.0, (sum, value) => sum + value);
              var tickets = (data['Ticket'] as List).map((ticket) => (ticket['Value'] as num).toDouble()).fold(0.0, (sum, value) => sum + value);
              if (averagesaleperticketSummary.containsKey(type)) {
                averagesaleperticketSummary[type]!['Sale'] = (averagesaleperticketSummary[type]!['Sale'] ?? 0.0) + sales;
                averagesaleperticketSummary[type]!['Ticket'] = (averagesaleperticketSummary[type]!['Ticket'] ?? 0.0) + tickets;
              } else {
                averagesaleperticketSummary[type] = {
                  'Sale': sales,
                  'Ticket': tickets,
                  'Average/Ticket': tickets > 0 ? sales / tickets : 0.0,
                };
              }
              // คำนวณยอดรวม
              totalSales += sales;
              totalTickets += tickets;
            });
          }

          // คำนวณค่าเฉลี่ยรวมจากยอดขายทั้งหมดและจำนวนตั๋วทั้งหมด
          final totalAverageTicket = totalTickets > 0 ? totalSales / totalTickets : 0.0;

          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
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
                columns: const [
                  DataColumn(label: Center(child: Text('Average Sale Per \nTicket'))),
                  DataColumn(label: Center(child: Text('Sales'))),
                  DataColumn(label: Center(child: Text('Ticket'))),
                  DataColumn(label: Center(child: Text('Average/Ticket'))),
                ],
                rows: [
                  // เพิ่ม rows สำหรับแต่ละประเภท
                  ...averagesaleperticketSummary.entries.map((entry) {
                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text(entry.key))),
                        DataCell(Center(child: Text("\$${entry.value['Sale']!.toStringAsFixed(2)}"))),
                        DataCell(Center(child: Text(entry.value['Ticket']!.toStringAsFixed(0)))),
                        DataCell(Center(child: Text("\$${entry.value['Average/Ticket']!.toStringAsFixed(2)}"))),
                      ],
                    );
                  }).toList(),

                  // เพิ่มแถว Total
                  DataRow(
                    cells: [
                      const DataCell(Center(child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)))),
                      DataCell(Center(child: Text("\$${totalSales.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)))),
                      DataCell(Center(child: Text(totalTickets.toStringAsFixed(0), style: TextStyle(fontWeight: FontWeight.bold)))),
                      DataCell(Center(child: Text("\$${totalAverageTicket.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is SummaryError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No data available'));
      },
    );
  }
}
