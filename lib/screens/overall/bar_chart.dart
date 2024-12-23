// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';
import 'sales_table.dart';

final logger = Logger();

class LineChartSample extends StatefulWidget {
  final dynamic selectDate;

  const LineChartSample({Key? key, this.selectDate}) : super(key: key);

  @override
  _LineChartSampleState createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  SalesSummary? salesSummary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SummaryBloc, SummaryState>(
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

            // สร้าง SalesSummary
            double totalNetSales = 0.0;
            double totalTaxSales = 0.0;
            double totalIncomingSales = 0.0;
            Map<String, double> combinedRevenue = {};

            // คำนวณข้อมูลจาก state.summaries
            for (var summary in state.summaries) {
              // คำนวณยอดขายตามที่เคยทำใน SalesTable
              var jsonMap = json.decode(summary['Data'] ?? '{}');
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

            // สร้าง SalesSummary object
            SalesSummary salesSummary = SalesSummary(
              totalNetSales: totalNetSales,
              totalTaxSales: totalTaxSales,
              totalIncomingSales: totalIncomingSales,
              combinedRevenue: combinedRevenue,
            );

            // ส่ง SalesSummary ไปที่ฟังก์ชันกราฟ
            final lineSpots = getLineChartData(salesSummary);
            final barGroups = getBarChartData(salesSummary);

            return Container(
              color: "#FFFFFF".toColor(),
              child: Column(
                children: [
                  // Line Chart
                  Expanded(
                    // flex: 5,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: lineSpots,
                            isCurved: true,
                            color: '#496EE2'.toColor(),
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Bar Chart
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 200,
                            alignment: Alignment.bottomLeft,
                            child: BarChart(
                              BarChartData(
                                barGroups: barGroups,
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(reservedSize: 7, showTitles: true),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      reservedSize: 20,
                                      showTitles: true,
                                      getTitlesWidget: (value, _) {
                                        const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                        return Text(days[value.toInt() % 7]);
                                      },
                                    ),
                                  ),
                                ),

                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: '#000000'.toColor(),
                                  ),
                                ),
                                // ปรับขนาดแท่ง
                                alignment: BarChartAlignment.spaceEvenly, // จัดระเบียบแท่งให้กระจาย

                                maxY: 130000, // กำหนดขีดจำกัดบนสุดของกราฟ (ปรับได้ตามต้องการ)
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: lineSpots,
                                    isCurved: true,
                                    color: '#496EE2'.toColor(),
                                    barWidth: 3,
                                    dotData: FlDotData(show: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SummaryError) {
            return Center(child: Text('Error loading data'));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้าง LineChart data
  List<FlSpot> getLineChartData(SalesSummary salesSummary) {
    // สร้าง LineChart data จาก SalesSummary
    return [
      FlSpot(0, salesSummary.totalNetSales),
      FlSpot(1, salesSummary.totalTaxSales),
      FlSpot(2, salesSummary.totalIncomingSales),
    ];
  }

  // ฟังก์ชันสำหรับสร้าง BarChart data
  List<BarChartGroupData> getBarChartData(SalesSummary salesSummary) {
    // สร้าง BarChart data จาก SalesSummary
    List<BarChartGroupData> barGroups = [];
    salesSummary.combinedRevenue.forEach((revenueClassName, totalRevenue) {
      barGroups.add(BarChartGroupData(
        x: barGroups.length,
        barRods: [
          BarChartRodData(toY: totalRevenue, color: '#496EE2'.toColor(), width: 10),
        ],
        showingTooltipIndicators: [0],
      ));
    });
    return barGroups;
  }
}
