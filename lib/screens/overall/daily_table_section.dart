// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import 'line_chart_page.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final GlobalKey _key = GlobalKey();
final logger = Logger();

class DailyTableSection extends StatefulWidget {
  final dynamic getDate;
  final dynamic selectDate;

  const DailyTableSection({Key? key, required this.getDate, this.selectDate}) : super(key: key);

  @override
  _DailyTableSectionState createState() => _DailyTableSectionState();
}

class _DailyTableSectionState extends State<DailyTableSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    if (widget.selectDate != null) {}
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          key: _key, // ใช้ GlobalKey เพื่อจับภาพ
          child: Column(children: [
            SizedBox(height: 16),
            Container(height: 400, child: LineChartPage()),
            SizedBox(height: 16),
            BlocBuilder<SummaryBloc, SummaryState>(
              builder: (context, state) {
                if (state is SummaryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SummaryLoaded) {
                  final filteredSummaries = state.summaries.where((summary) {
                    if (widget.selectDate != null &&
                        widget.selectDate.containsKey('filteredFromDate') &&
                        widget.selectDate.containsKey('filteredToDate')) {
                      final summaryDate = DateTime.parse(summary['Date']).toLocal();
                      final fromDate = DateTime.parse(widget.selectDate['filteredFromDate']).toLocal();
                      final toDate = DateTime.parse(widget.selectDate['filteredToDate']).toLocal();
                      return summaryDate.isAfter(fromDate.subtract(Duration(days: 1))) && summaryDate.isBefore(toDate.add(Duration(days: 1)));
                    }
                    return true;
                  }).toList();

                  Map<String, Map<String, double>> revenueByDateAndClass = {};
                  Map<String, Map<String, double>> paymentTotals = {};
                  Map<String, Map<String, double>> totalDepositsByType = {};
                  Map<String, Map<String, double>> totalCreditCardsByType = {};
                  Map<String, Map<String, double>> totalServiceChargeByType = {};
                  Map<String, Map<String, dynamic>> totalDisCountsByType = {};
                  Map<String, Map<String, double>> totalSalebyOdertypeByType = {};

                  double totalDeposits = 0.0;
                  double totalCreditCards = 0.0;
                  double totalServiceCharge = 0.0;
                  double totalDiscounts = 0.0;
                  double totalSalebyOdertypes = 0.0;

                  for (var summary in filteredSummaries) {
                    DateTime summaryDate = DateTime.parse(summary['Date']).toLocal();
                    String formattedDate = "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";

                    Map<String, dynamic> jsonMapRevenue = json.decode(summary['FilterByRevenue'] ?? '{}');
                    Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');

                    var revenues = jsonMapRevenue['Revenues'] ?? [];
                    var payments = jsonMap['Payments'];
                    var deposits = jsonMap['Deposits'];
                    var creditcards = jsonMap['CreditCards'];
                    var servicecharges = jsonMap['ServiceCharge'];
                    var discounts = jsonMap['Discounts'] ?? [];
                    var salebyordertypes = jsonMap['SalebyOrderType'];

                    final cashIn = deposits['CashIn'];
                    final cashOut = deposits['CashOut'];

                    for (var revenue in revenues) {
                      String revenueClassName = revenue['RevenueClassName'];
                      double netSalesValue = revenue['NetSales']?.fold(0.0, (sum, sale) => sum + sale['Value']) ?? 0.0;
                      double taxValue = revenue['NetSales']?.fold(0.0, (sum, sale) => sum + (sale['Tax'] ?? 0.0)) ?? 0.0;
                      double totalSalesValue = netSalesValue + taxValue;

                      revenueByDateAndClass.putIfAbsent(revenueClassName, () => {});
                      revenueByDateAndClass[revenueClassName]![formattedDate] = netSalesValue;
                    }

                    payments.forEach((paymentType, paymentData) {
                      double salesTotal = paymentData['Sales']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
                      double tipsTotal = paymentData['Tips']?.fold(0.0, (sum, item) => sum + item['Value']) ?? 0.0;
                      double total = salesTotal + tipsTotal;

                      paymentTotals.putIfAbsent(paymentType, () => {});
                      paymentTotals[paymentType]?['Sales'] = (paymentTotals[paymentType]?['Sales'] ?? 0.0) + salesTotal;
                      paymentTotals[paymentType]?['Tips'] = (paymentTotals[paymentType]?['Tips'] ?? 0.0) + tipsTotal;
                      paymentTotals[paymentType]?['Total'] = (paymentTotals[paymentType]?['Total'] ?? 0.0) + total;
                    });

                    deposits?.forEach((depositType, depositData) {
                      if (depositData is List) {
                        for (var deposit in depositData) {
                          double depositValue = deposit['Value'] ?? 0.0;
                          totalDepositsByType.putIfAbsent(depositType, () => {});
                          totalDepositsByType[depositType]!['Total'] = (totalDepositsByType[depositType]!['Total'] ?? 0.0) + depositValue;
                          if (depositValue != 0) {
                            totalDeposits += depositValue;
                          }
                        }
                      }
                    });
                    servicecharges?.forEach((servicechargeType, servicechargeData) {
                      if (servicechargeData is List) {
                        for (var servicecharge in servicechargeData) {
                          double servicechargeValue = servicecharge['Value'] ?? 0.0;
                          totalServiceChargeByType.putIfAbsent(servicechargeType, () => {});
                          totalServiceChargeByType[servicechargeType]!['Total'] =
                              (totalServiceChargeByType[servicechargeType]!['Total'] ?? 0.0) + servicechargeValue;
                          if (servicechargeValue != 0) {
                            totalServiceCharge += servicechargeValue;
                          }
                        }
                      }
                    });
                    creditcards?.forEach((creditcardType, creditcardData) {
                      if (creditcardData is List) {
                        for (var creditcard in creditcardData) {
                          double creditcardValue = creditcard['Value'] ?? 0.0;
                          totalCreditCardsByType.putIfAbsent(creditcardType, () => {});
                          totalCreditCardsByType[creditcardType]!['Total'] =
                              (totalCreditCardsByType[creditcardType]!['Total'] ?? 0.0) + creditcardValue;
                          if (creditcardValue != 0) {
                            totalCreditCards += creditcardValue;
                          }
                        }
                      }
                    });
                    if (discounts.isNotEmpty) {
                      for (var discount in discounts) {
                        var discountName = discount['DiscountName'];
                        var discountValue = discount['Value'] ?? 0.0;
                      }
                    } else {
                      print("No discounts available.");
                    }
                    salebyordertypes?.forEach((salebyordertypeType, salebyordertypeData) {
                      if (salebyordertypeData is Map) {
                        var salebyordertypeTotal = salebyordertypeData['Total'] as List;

                        // ใช้การวนลูปและรวมค่า Value
                        for (var salebyordertype in salebyordertypeTotal) {
                          double salebyordertypeValue = salebyordertype['Value'] ?? 0.0;

                          // เก็บผลรวมใน totalSalebyOdertypeByType
                          totalSalebyOdertypeByType.putIfAbsent(salebyordertypeType, () => {});
                          totalSalebyOdertypeByType[salebyordertypeType]!['Total'] =
                              (totalSalebyOdertypeByType[salebyordertypeType]!['Total'] ?? 0.0) + salebyordertypeValue;

                          if (salebyordertypeValue != 0) {
                            totalSalebyOdertypes += salebyordertypeValue;
                          }
                        }
                      }
                    });
                  }

                  List<String> allDates = revenueByDateAndClass.values.expand((map) => map.keys).toSet().toList()..sort();
                  return Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
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
                        child: SingleChildScrollView(
                          // reverse: true,
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0, top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Sales',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontFamily: 'Inter', fontSize: 14, color: '#3C3C3C'.toColor(), fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            date,
                                            textAlign: TextAlign.end,
                                            style:
                                                TextStyle(fontFamily: 'Inter', fontSize: 14, color: '#3C3C3C'.toColor(), fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...revenueByDateAndClass.entries.map(
                                      (entry) {
                                        final revenueClass = entry.key;
                                        final rowValues = allDates.map(
                                          (date) {
                                            final value = entry.value[date]?.toStringAsFixed(2) ?? "XX.XX";
                                            return DataCell(
                                              Text(
                                                "\$$value",
                                                textAlign: TextAlign.end, // จัดตำแหน่งข้อความที่เริ่มต้นจากซ้าย

                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  color: '#3C3C3C'.toColor(),
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList();

                                        return DataRow(
                                          cells: [
                                            DataCell(Text(
                                              revenueClass,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: '#3C3C3C'.toColor()),
                                            )),
                                            ...rowValues,
                                          ],
                                        );
                                      },
                                    ).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(Text("Net Sales", style: TextStyle(fontWeight: FontWeight.bold))),
                                        ...allDates.map((date) {
                                          final netSales = revenueByDateAndClass.values.map((value) => value[date] ?? 0.0).reduce((a, b) => a + b);
                                          return DataCell(Text("\$${netSales.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(Text("Taxes", style: TextStyle(fontWeight: FontWeight.bold))),
                                        ...allDates.map((date) {
                                          final taxes = 0.0;
                                          return DataCell(Text(taxes == 0.0 ? "\$XX.XX" : "\$${taxes.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(Text("Total Sales", style: TextStyle(fontWeight: FontWeight.bold))),
                                        ...allDates.map((date) {
                                          final netSales = revenueByDateAndClass.values.map((value) => value[date] ?? 0.0).reduce((a, b) => a + b);
                                          final taxes = 0.0;
                                          final totalSales = netSales + taxes;
                                          return DataCell(Text("\$${totalSales.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                // Payments
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Payments',
                                          textAlign: TextAlign.left,
                                          style:
                                              TextStyle(fontFamily: 'Inter', fontSize: 14, color: '#3C3C3C'.toColor(), fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...paymentTotals.entries.map((entry) {
                                      final paymentType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final payments = json.decode(summary['Data'] ?? '{}')['Payments'] ?? {};
                                          return sum +
                                              (payments[paymentType]?['Sales']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0) +
                                              (payments[paymentType]?['Tips']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(paymentType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            'Total Payments',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...allDates.map((date) {
                                          final totalForDate = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                            return formattedDate == date;
                                          }).fold(0.0, (sum, summary) {
                                            final payments = json.decode(summary['Data'] ?? '{}')['Payments'] ?? {};
                                            return sum +
                                                payments.values.fold(0.0, (total, payment) {
                                                  final salesTotal = payment['Sales']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0;
                                                  final tipsTotal = payment['Tips']?.fold(0.0, (s, item) => s + item['Value']) ?? 0.0;
                                                  return total + salesTotal + tipsTotal;
                                                });
                                          });
                                          return DataCell(
                                            Text(
                                              "\$${totalForDate.toStringAsFixed(2)}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                //Deposits
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Deposits',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...totalDepositsByType.entries.map((entry) {
                                      final depositType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                          return sum + (deposits[depositType]?.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0)) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(depositType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            'Total Deposits',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...allDates.map((date) {
                                          final totalForDate = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                            return formattedDate == date;
                                          }).fold(0.0, (sum, summary) {
                                            final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                            return sum +
                                                deposits.values.fold(0.0, (total, depositData) {
                                                  if (depositData is List) {
                                                    return total + depositData.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0));
                                                  }
                                                  return total;
                                                });
                                          });
                                          return DataCell(
                                            Text(
                                              "\$${totalForDate.toStringAsFixed(2)}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                //Credit Cards
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Creditcards',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...totalCreditCardsByType.entries.map((entry) {
                                      final creditcardType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final creditcards = json.decode(summary['Data'] ?? '{}')['CreditCards'] ?? {};
                                          return sum + (creditcards[creditcardType]?.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0)) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(creditcardType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            'Total Credit Cards',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...allDates.map((date) {
                                          final totalForDate = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                            return formattedDate == date;
                                          }).fold(0.0, (sum, summary) {
                                            final creditcards = json.decode(summary['Data'] ?? '{}')['CreditCards'] ?? {};
                                            return sum +
                                                creditcards.values.fold(0.0, (total, creditcardData) {
                                                  if (creditcardData is List) {
                                                    return total + creditcardData.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0));
                                                  }
                                                  return total;
                                                });
                                          });
                                          return DataCell(
                                            Text(
                                              "\$${totalForDate.toStringAsFixed(2)}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                // CashIn/cashOut
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Cash In / Cash \nOut',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    // Cash In Row
                                    DataRow(
                                      cells: [
                                        DataCell(Text('Cash In')),
                                        ...allDates.map((date) {
                                          // คำนวณค่าของ Cash In สำหรับแต่ละวันใน allDates
                                          final dailyTotal = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                            return formattedDate == date;
                                          }).fold(0.0, (sum, summary) {
                                            final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                            final cashIn = deposits['CashIn'] ?? 0.0;
                                            return sum + cashIn;
                                          });

                                          return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                    // Cash Out Row
                                    DataRow(
                                      cells: [
                                        DataCell(Text('Cash Out')),
                                        ...allDates.map((date) {
                                          // คำนวณค่าของ Cash Out สำหรับแต่ละวันใน allDates
                                          final dailyTotal = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                            return formattedDate == date;
                                          }).fold(0.0, (sum, summary) {
                                            final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                            final cashOut = deposits['CashOut'] ?? 0.0;
                                            return sum + cashOut;
                                          });

                                          return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                // ServiceCharge
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Service Charges',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...totalServiceChargeByType.entries.map((entry) {
                                      final servicechargeType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final servicecharges = json.decode(summary['Data'] ?? '{}')['ServiceCharge'] ?? {};
                                          return sum + (servicecharges[servicechargeType]?.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0)) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(servicechargeType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                                // Discounts
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Discounts',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...totalServiceChargeByType.entries.map((entry) {
                                      final servicechargeType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final servicecharges = json.decode(summary['Data'] ?? '{}')['ServiceCharge'] ?? {};
                                          return sum + (servicecharges[servicechargeType]?.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0)) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(servicechargeType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                                // SalesbyorderType
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Sales by Order \nType',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...totalSalebyOdertypeByType.entries.map((entry) {
                                      final salebyordertypeType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final salebyordertypes = json.decode(summary['Data'] ?? '{}')['CreditCards'] ?? {};
                                          return sum +
                                              (salebyordertypes[salebyordertypeType]?.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0)) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(salebyordertypeType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),

                                //Gift Cards
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Gift Cards',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...totalCreditCardsByType.entries.map((entry) {
                                      final creditcardType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final creditcards = json.decode(summary['Data'] ?? '{}')['CreditCards'] ?? {};
                                          return sum + (creditcards[creditcardType]?.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0)) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(creditcardType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            'Total Credit Cards',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...allDates.map((date) {
                                          final totalForDate = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                            return formattedDate == date;
                                          }).fold(0.0, (sum, summary) {
                                            final creditcards = json.decode(summary['Data'] ?? '{}')['CreditCards'] ?? {};
                                            return sum +
                                                creditcards.values.fold(0.0, (total, creditcardData) {
                                                  if (creditcardData is List) {
                                                    return total + creditcardData.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0));
                                                  }
                                                  return total;
                                                });
                                          });
                                          return DataCell(
                                            Text(
                                              "\$${totalForDate.toStringAsFixed(2)}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                //Customers
                                DataTable(
                                  columnSpacing: 30,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Customers',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ...allDates.map(
                                      (date) => DataColumn(
                                        label: SizedBox(
                                          width: 100,
                                          child: Text(
                                            "",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    ...totalCreditCardsByType.entries.map((entry) {
                                      final creditcardType = entry.key;
                                      final rowValues = allDates.map((date) {
                                        final dailyTotal = filteredSummaries.where((summary) {
                                          final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                          final formattedDate =
                                              "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                          return formattedDate == date;
                                        }).fold(0.0, (sum, summary) {
                                          final creditcards = json.decode(summary['Data'] ?? '{}')['CreditCards'] ?? {};
                                          return sum + (creditcards[creditcardType]?.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0)) ?? 0.0);
                                        });
                                        return DataCell(Text(dailyTotal == 0.0 ? "\$XX.XX" : "\$${dailyTotal.toStringAsFixed(2)}"));
                                      }).toList();
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(creditcardType)),
                                          ...rowValues,
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            'Total Credit Cards',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...allDates.map((date) {
                                          final totalForDate = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                                            return formattedDate == date;
                                          }).fold(0.0, (sum, summary) {
                                            final creditcards = json.decode(summary['Data'] ?? '{}')['CreditCards'] ?? {};
                                            return sum +
                                                creditcards.values.fold(0.0, (total, creditcardData) {
                                                  if (creditcardData is List) {
                                                    return total + creditcardData.fold(0.0, (s, item) => s + (item['Value'] ?? 0.0));
                                                  }
                                                  return total;
                                                });
                                          });
                                          return DataCell(
                                            Text(
                                              "\$${totalForDate.toStringAsFixed(2)}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is SummaryError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Center(child: Text('No data available'));
              },
            )
          ]))
    ]);
  }

  TableBorder buildTableBorder() {
    return TableBorder(
      verticalInside: BorderSide(
        color: '#868E96'.toColor(),
        width: 0.5, // ความหนาของเส้นแบ่ง
      ),
      horizontalInside: BorderSide(
        color: '#868E96'.toColor(),
        width: 0.5, // เส้นแบ่งระหว่างแถว
      ),
      bottom: BorderSide(color: '#868E96'.toColor(), width: 1.5), // เส้นปิดท้ายของ DataTable
    );
  }
}
