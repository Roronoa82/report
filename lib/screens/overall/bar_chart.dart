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
            double totalSales = 0.0;
            Map<String, double> combinedRevenue = {};
            Map<int, double> dailyNetSales = {}; // Key เป็นวันที่ (1-31), Value เป็นยอดขายรวมของวันนั้น
            Map<int, double> dailyTotalSales = {}; // Key: วันที่ (1-31), Value: ยอดขายรวมของวันนั้น
            // คำนวณข้อมูลจาก state.summaries
            for (var summary in filteredSummaries) {
              // คำนวณยอดขายตามที่เคยทำใน SalesTable
              var jsonMap = json.decode(summary['Data'] ?? '{}');
              var netSales = jsonMap['Sales']?['NetSales'] ?? [];
              var taxSales = jsonMap['Sales']?['TaxSales'] ?? [];
              var incomingSales = jsonMap['Sales']?['IncomingSales'] ?? [];

              totalNetSales += netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
              totalTaxSales += taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
              totalIncomingSales += incomingSales.fold(0.0, (sum, item) => sum + (item['Value'] as double? ?? 0.0));
// รวมยอดขายทั้งหมด
              totalSales += netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
              totalSales += taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
              totalSales += incomingSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
              double dailySales = 0.0;

              dailySales += netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
              dailySales += taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
              dailySales += incomingSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));

              // ดึงวันที่จาก summary และเพิ่มยอดขายในวันที่นั้น
              final date = DateTime.parse(summary['Date']).day; // ใช้เฉพาะวันที่ (1-31)
              dailyTotalSales[date] = (dailyTotalSales[date] ?? 0.0) + dailySales;

//------------------------
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
              totalSales: totalNetSales + totalTaxSales + totalIncomingSales, // รวมยอดขายทั้งหมด
              combinedRevenue: combinedRevenue,
            );

            // ส่ง SalesSummary ไปที่ฟังก์ชันกราฟ
            final lineSpots = getLineChartData(dailyTotalSales);
            final barGroups = getBarChartData(dailyTotalSales);

            return Container(
              decoration: BoxDecoration(
                color: "#FFFFFF".toColor(),

                borderRadius: BorderRadius.circular(10), // เพิ่มมุมโค้ง (ถ้าต้องการ)
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // เพิ่มเงา
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey,
                              strokeWidth: 1,
                              dashArray: [4, 0],
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey,
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            );
                          },
                        ),
                        lineBarsData: [
                          LineChartBarData(
                              spots: lineSpots,
                              isCurved: false,
                              color: '#207cff'.toColor(),
                              barWidth: 1,
                              belowBarData: BarAreaData(show: true, color: '#207cff30'.toColor()),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (p0, p1, p2, p3) {
                                  double size = 1;
                                  return FlDotCirclePainter(
                                    strokeColor: '#207cff'.toColor(),
                                    color: '#FFFFFF'.toColor(),
                                    radius: size, // กำหนดขนาด radius
                                  );
                                },
                              )),
                        ],
                        minY: 0,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 50,
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                if (value >= 1000) {
                                  return Text(
                                    '\$${(value).toStringAsFixed(0)}',
                                    style: TextStyle(fontSize: 10, color: Colors.black),
                                  );
                                }
                                return Text(
                                  value.toStringAsFixed(0),
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 30,
                              showTitles: true,
                              interval: 4, // Show every day on X-axis
                              getTitlesWidget: (value, _) {
                                return Text(
                                  value.toInt().toString(), // Display day of the month
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 0),
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
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  drawHorizontalLine: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                      dashArray: [4, 0],
                                    );
                                  },
                                ),
                                barGroups: barGroups, // ใช้ข้อมูลที่สร้างจาก dailyTotalSales
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      reservedSize: 40,
                                      showTitles: true,
                                      getTitlesWidget: (value, _) {
                                        return Text(
                                          value.toStringAsFixed(0),
                                          style: TextStyle(fontSize: 10, color: Colors.black),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      reservedSize: 30,
                                      showTitles: true,
                                      interval: 1, // แสดงทุกวัน
                                      getTitlesWidget: (value, _) {
                                        // แปลงค่า value เป็นชื่อวันในสัปดาห์
                                        List<String> weekDays = [
                                          'S',
                                          'S',
                                          'M',
                                          'T',
                                          'W',
                                          'T',
                                          'F',
                                        ];
                                        int index = value.toInt() % 7;
                                        return Text(
                                          weekDays[index], // แสดงชื่อวันตามค่า index
                                          style: TextStyle(fontSize: 8),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                minY: 0, // ตั้งค่าให้ Y-axis เริ่มจาก 0

                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: '#000000'.toColor(),
                                  ),
                                ),
                                alignment: BarChartAlignment.spaceEvenly,
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
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false, // เปิดเส้นประแนวตั้ง
                                  drawHorizontalLine: true, // เปิดเส้นประแนวนอน
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                      dashArray: [4, 0],
                                    );
                                  },
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(24, (index) {
                                      return FlSpot(index.toDouble(), 0);
                                    }),
                                    isCurved: false,
                                    color: '#207cff'.toColor(),
                                    barWidth: 1,
                                    belowBarData: BarAreaData(show: true, color: '#207cff30'.toColor()),
                                    dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (p0, p1, p2, p3) {
                                          double size = 1;
                                          return FlDotCirclePainter(
                                            radius: size,
                                            strokeColor: '#207cff'.toColor(),
                                            color: '#FFFFFF'.toColor(),
                                          );
                                        }),
                                  ),
                                ],
                                minY: 0,
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
  List<FlSpot> getLineChartData(Map<int, double> dailyTotalSales) {
    // สร้าง LineChart data จาก dailyTotalSales
    return dailyTotalSales.entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(), // วันที่เป็นแกน X (1-31)
        entry.value, // ยอดขายรายวันเป็นแกน Y
      );
    }).toList();
  }

  // ฟังก์ชันสำหรับสร้าง BarChart data
  List<BarChartGroupData> getBarChartData(Map<int, double> dailyTotalSales) {
    var last7Days = dailyTotalSales.entries
        .take(7) // เอาแค่ 7 รายการแรก
        .toList();

    return last7Days.map((entry) {
      return BarChartGroupData(
        x: entry.key, // วันที่เป็นแกน X (1-7)
        barRods: [
          BarChartRodData(
            toY: entry.value, // ยอดขายรวมของวันนั้นเป็นแกน Y
            color: '#207cff'.toColor(),
            width: 10,
          ),
        ],
      );
    }).toList();
  }
}
