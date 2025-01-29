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

class LineChartPage extends StatefulWidget {
  final dynamic selectDate;

  const LineChartPage({Key? key, this.selectDate}) : super(key: key);

  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  SalesSummary? salesSummary;

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

              return summaryDate.isAfter(fromDate.subtract(Duration(days: 1))) && summaryDate.isBefore(toDate.add(Duration(days: 1)));
            }
            return true;
          }).toList();

          double totalNetSales = 0.0;
          double totalTaxSales = 0.0;
          double totalIncomingSales = 0.0;
          double totalSales = 0.0;
          Map<String, double> combinedRevenue = {};
          Map<int, double> dailyNetSales = {};
          Map<int, double> dailyTotalSales = {};
          for (var summary in filteredSummaries) {
            var jsonMap = json.decode(summary['Data'] ?? '{}');
            var netSales = jsonMap['Sales']?['NetSales'] ?? [];
            var taxSales = jsonMap['Sales']?['TaxSales'] ?? [];
            var incomingSales = jsonMap['Sales']?['IncomingSales'] ?? [];

            totalNetSales += netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            totalTaxSales += taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            totalIncomingSales += incomingSales.fold(0.0, (sum, item) => sum + (item['Value'] as double? ?? 0.0));
            totalSales += netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            totalSales += taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            totalSales += incomingSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            double dailySales = 0.0;

            dailySales += netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            dailySales += taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));
            dailySales += incomingSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));

            final dateTime = DateTime.parse(summary['Date']); // ใช้เฉพาะวันที่ (1-31)
            final day = dateTime.day;
            final month = dateTime.month;
            final year = dateTime.year;

            dailyTotalSales[day] = (dailyTotalSales[day] ?? 0.0) + dailySales;

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

          SalesSummary salesSummary = SalesSummary(
            totalNetSales: totalNetSales,
            totalTaxSales: totalTaxSales,
            totalIncomingSales: totalIncomingSales,
            totalSales: totalNetSales + totalTaxSales + totalIncomingSales,
            combinedRevenue: combinedRevenue,
          );

          final lineSpots = getLineChartData(dailyTotalSales);
          final barGroups = getBarChartData(dailyTotalSales);

          return Container(
            decoration: BoxDecoration(
              color: "#FFFFFF".toColor(),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.11,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 1500,
                        drawVerticalLine: false,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: '#EEEEEE'.toColor(),
                            strokeWidth: 1,
                            dashArray: [4, 0],
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
                      maxY: 6000,
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(sideTitles: SideTitles(reservedSize: 30, showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(
                          reservedSize: 30,
                          showTitles: true,
                          interval: 3,
                          getTitlesWidget: (value, _) {
                            int month = value.toInt();
                            String displayText;
                            if (month == 1) {
                              displayText = 'Aug 2023';
                            } else if (month >= 1) {
                              displayText = '';
                            } else {
                              displayText = '$month';
                            }
                            return Text(
                              displayText,
                              style: TextStyle(fontSize: 10, color: Colors.black),
                            );
                          },
                        )),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 30,
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              if (value >= 1000) {
                                return Text(
                                  '\$${(value).toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 10, color: Colors.black),
                                );
                              }
                              return Text(value.toStringAsFixed(0), style: TextStyle(fontSize: 12, color: Colors.black), textAlign: TextAlign.right);
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 30,
                            showTitles: true,
                            interval: 4,
                            getTitlesWidget: (value, _) {
                              int month = value.toInt();
                              String displayText;

                              if (month == 1) {
                                displayText = 'Aug. 1';
                              } else if (month == 31) {
                                displayText = 'Aug. 31';
                              } else {
                                displayText = '$month';
                              }
                              return Text(
                                displayText,
                                style: TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.black,
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          tooltipRoundedRadius: 0,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final dateIndex = spot.x.toInt();
                              final matchedSummary = filteredSummaries.firstWhere(
                                (summary) {
                                  Map<String, dynamic> jsonMapFilterEmployee = json.decode(summary['FilterByEmployees'] ?? '{}');
                                  final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                  return summaryDate.day == dateIndex;
                                },
                                orElse: () => {},
                              );

                              String formattedDate = 'Unknown Date';
                              int uniqueEmployeeCount = 0;
                              if (matchedSummary != null) {
                                final summaryDate = DateTime.parse(matchedSummary['Date']);
                                final day = summaryDate.day;
                                final month = summaryDate.month;
                                final year = summaryDate.year;
                                const monthNames = [
                                  'January',
                                  'February',
                                  'March',
                                  'April',
                                  'May',
                                  'June',
                                  'July',
                                  'August',
                                  'September',
                                  'October',
                                  'November',
                                  'December'
                                ];
                                final monthName = monthNames[month - 1];
                                formattedDate = '$day $monthName, $year';

                                Map<String, dynamic> jsonMapFilterEmployee = json.decode(matchedSummary['FilterByEmployees'] ?? '{}');
                                Set<int> employeesSet = Set<int>();

                                void extractEmployeesId(List<dynamic> data) {
                                  for (var item in data) {
                                    if (item.containsKey('EmployeesID')) {
                                      int employeesID = item['EmployeesID'];
                                      employeesSet.add(employeesID);
                                    }
                                  }
                                }

                                var filterByEmployees = jsonMapFilterEmployee['FilterByEmployees'];
                                if (filterByEmployees != null) {
                                  extractEmployeesId(filterByEmployees['Sales'] ?? []);
                                  extractEmployeesId(filterByEmployees['TaxSales'] ?? []);
                                  extractEmployeesId(filterByEmployees['IncomingSales'] ?? []);
                                }

                                var payments = jsonMapFilterEmployee['Payments'];
                                if (payments != null) {
                                  extractEmployeesId(payments['Cash']?['Sales'] ?? []);
                                  extractEmployeesId(payments['Credit']?['Sales'] ?? []);
                                  extractEmployeesId(payments['Prepaid']?['Sales'] ?? []);
                                  extractEmployeesId(payments['Prepaid']?['Tips'] ?? []);
                                }

                                var deposits = jsonMapFilterEmployee['Deposits'];
                                if (deposits != null) {
                                  extractEmployeesId(deposits['CashSale'] ?? []);
                                  extractEmployeesId(deposits['Gratuity'] ?? []);
                                  extractEmployeesId(deposits['CreditCardTip'] ?? []);
                                }

                                var creditCards = jsonMapFilterEmployee['CreditCards'];
                                if (creditCards != null) {
                                  extractEmployeesId(creditCards['Visa'] ?? []);
                                  extractEmployeesId(creditCards['Mastercard'] ?? []);
                                  extractEmployeesId(creditCards['Amex'] ?? []);
                                }

                                var serviceCharge = jsonMapFilterEmployee['ServiceCharge'];
                                if (serviceCharge != null) {
                                  extractEmployeesId(serviceCharge['Gratuity'] ?? []);
                                  extractEmployeesId(serviceCharge['Delivery3rdParty'] ?? []);
                                }
                                uniqueEmployeeCount = employeesSet.length;
                              }

                              return LineTooltipItem(
                                '',
                                TextStyle(),
                                children: [
                                  TextSpan(
                                    text: '$formattedDate\n',
                                    style: TextStyle(color: '#909090'.toColor(), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                  TextSpan(
                                    text: '________________________\n',
                                    style: TextStyle(
                                      color: '#909090'.toColor(),
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\$${spot.y.toStringAsFixed(2)}\n',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '$uniqueEmployeeCount PAYMENTS',
                                    style: TextStyle(color: '#909090'.toColor(), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),
                        touchCallback: (event, response) {
                          if (event.isInterestedForInteractions && response != null) {}
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(
                            color: '#EEEEEE'.toColor(),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: '#EEEEEE'.toColor(),
                            width: 1,
                          ),
                          top: BorderSide.none,
                          right: BorderSide.none,
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
                        flex: 1,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.11,
                          width: MediaQuery.of(context).size.width * 0.7,
                          // padding: EdgeInsets.only(left: 16, right: 40),
                          alignment: Alignment.bottomLeft,
                          child: BarChart(
                            BarChartData(
                              gridData: FlGridData(
                                horizontalInterval: 1500,
                                show: true,
                                drawVerticalLine: false,
                                drawHorizontalLine: true,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: '#EEEEEE'.toColor(),
                                    strokeWidth: 1,
                                    dashArray: [4, 0],
                                  );
                                },
                              ),
                              barGroups: barGroups,
                              groupsSpace: 6,
                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, _) {
                                      int month = value.toInt();
                                      String? displayText;

                                      if (month == 1) {
                                        displayText = 'Day of \nWeek';
                                      } else if (month >= 1) {
                                        displayText = '';
                                      } else {
                                        displayText = '$month';
                                      }

                                      return Text(
                                        displayText,
                                        style: TextStyle(fontSize: 9, color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      return Text(
                                        '\$${value.toStringAsFixed(0)}',
                                        style: TextStyle(fontSize: 9, color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, _) {
                                      List<String>? weekDays = [
                                        'S',
                                        'S',
                                        'M',
                                        'T',
                                        'W',
                                        'T',
                                        'F',
                                      ];
                                      // print(weekDays[7]);
                                      int index = value.toInt() % 7;
                                      return Text(
                                        weekDays[index],
                                        style: TextStyle(fontSize: 8),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              minY: 0,
                              maxY: 6000,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.black,
                                  tooltipPadding: const EdgeInsets.all(8),
                                  tooltipMargin: 0,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final matchedSummary = filteredSummaries.firstWhere(
                                      (summary) {
                                        final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                        return summaryDate.day == groupIndex;
                                      },
                                      orElse: () => {},
                                    );
                                    String formattedDate = 'Sunday';
                                    if (matchedSummary != null && matchedSummary['Date'] != null) {
                                      final summaryDate = DateTime.parse(matchedSummary['Date']);
                                      final day = summaryDate.weekday;

                                      const dayNames = [
                                        'Sunday',
                                        'Monday',
                                        'Tuesday',
                                        'Wednesday',
                                        'Thursday',
                                        'Friday',
                                        'Saturday',
                                      ];
                                      final dayName = dayNames[day - 1];
                                      formattedDate = dayName;
                                    }

                                    return BarTooltipItem(
                                      '',
                                      TextStyle(),
                                      children: [
                                        TextSpan(
                                          text: formattedDate,
                                          style:
                                              TextStyle(color: '#909090'.toColor(), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                        ),
                                        TextSpan(
                                          text: '\n_____________________\n',
                                          style: TextStyle(
                                            color: '#909090'.toColor(),
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\$${rod.toY.toStringAsFixed(2)}\n',
                                          style: TextStyle(
                                            color: '#FFFFFF'.toColor(),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '18 PAYMENTS',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                touchCallback: (event, response) {
                                  if (event.isInterestedForInteractions && response != null) {}
                                },
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  left: BorderSide(
                                    color: '#EEEEEE'.toColor(),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: '#EEEEEE'.toColor(),
                                    width: 1,
                                  ),
                                  top: BorderSide.none,
                                  right: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.11,
                          height: MediaQuery.of(context).size.height * 0.125,
                          padding: EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                horizontalInterval: 2,
                                show: true,
                                drawVerticalLine: false,
                                drawHorizontalLine: true,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: '#EEEEEE'.toColor(),
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
                              maxY: 6,
                              lineTouchData: LineTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 20,
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      // กำหนดค่าที่คุณต้องการแสดง
                                      if (value == 0) {
                                        return Text(
                                          '\$0',
                                          style: TextStyle(fontSize: 10, color: Colors.black),
                                        );
                                      }
                                      return SizedBox();
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                    interval: 3,
                                    getTitlesWidget: (value, _) {
                                      int month = value.toInt();
                                      String displayText;

                                      if (month == 0) {
                                        displayText = 'Time of Day';
                                      } else if (month >= 1) {
                                        displayText = '';
                                      } else {
                                        displayText = '$month';
                                      }

                                      return Text(
                                        displayText,
                                        style: TextStyle(fontSize: 9, color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 40,
                                    showTitles: true,
                                    interval: 3,
                                    getTitlesWidget: (value, _) {
                                      int hour = value.toInt();
                                      String displayText;

                                      if (hour == 0) {
                                        displayText = '12 AM';
                                      } else if (hour == 12) {
                                        displayText = '12 PM';
                                      } else {
                                        displayText = '$hour';
                                      }

                                      return Text(
                                        displayText,
                                        style: TextStyle(fontSize: 8, color: Colors.black),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  left: BorderSide(
                                    color: '#EEEEEE'.toColor(),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: '#EEEEEE'.toColor(),
                                    width: 1,
                                  ),
                                  top: BorderSide.none,
                                  right: BorderSide.none,
                                ),
                              ),
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
    );
  }

  List<FlSpot> getLineChartData(Map<int, double> dailyTotalSales) {
    return dailyTotalSales.entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value,
      );
    }).toList();
  }

  List<BarChartGroupData> getBarChartData(Map<int, double> dailyTotalSales) {
    var last7Days = dailyTotalSales.entries.take(7).toList();

    return last7Days.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(toY: entry.value, color: '#207cff'.toColor(), width: 12, borderRadius: BorderRadius.zero),
        ],
      );
    }).toList();
  }
}
