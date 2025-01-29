// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class SummaryScreen extends StatefulWidget {
  final dynamic selectDate;

  final int showDepositsOnly;
  const SummaryScreen({Key? key, this.selectDate, required this.showDepositsOnly}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  Map<String, double> combinedCreditCards = {};

  double totalDeposits = 0.0;

  @override
  void initState() {
    if (widget.selectDate != null) {}
    super.initState();
    totalDeposits = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showDepositsOnly == 1) ...[
          Flexible(
            child: Container(
              color: '#EEEEEE'.toColor(),
              child: DepositsTable(selectDate: widget.selectDate),
            ),
          ),
        ] else if (widget.showDepositsOnly == 2) ...[
          Flexible(
            child: Container(
              color: '#EEEEEE'.toColor(),
              child: CraditCartTable(selectDate: widget.selectDate),
            ),
          ),
        ] else if (widget.showDepositsOnly == 3) ...[
          Flexible(
            child: Container(
              color: '#EEEEEE'.toColor(),
              child: CashInCashOutTable(selectDate: widget.selectDate),
            ),
          ),
        ] else if (widget.showDepositsOnly == 4) ...[
          Flexible(
            child: Container(
              color: '#EEEEEE'.toColor(),
              child: ServiceChargeTable(selectDate: widget.selectDate),
            ),
          ),
        ] else if (widget.showDepositsOnly == 5) ...[
          Flexible(
            child: Container(
              color: '#EEEEEE'.toColor(),
              child: GiftCardTable(selectDate: widget.selectDate),
            ),
          ),
        ] else if (widget.showDepositsOnly == 6) ...[
          Flexible(
            child: Container(
              color: '#EEEEEE'.toColor(),
              child: CustomersTable(selectDate: widget.selectDate),
            ),
          ),
        ],
      ],
    );
  }

  // Widget สำหรับ DepositsTable
  Widget DepositsTable({dynamic selectDate}) {
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

          Map<String, double> totalDepositsByType = {};
          double totalDeposits = 0.0;

          for (var summary in filteredSummaries) {
            Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
            var deposits = jsonMap['Deposits'];

            deposits.forEach((depositType, depositData) {
              double depositTotal = 0.0;
              if (depositData is List) {
                depositTotal = depositData.fold(0.0, (sum, item) => sum + (item['Value'] ?? 0.0));
              }

              if (totalDepositsByType.containsKey(depositType)) {
                totalDepositsByType[depositType] = totalDepositsByType[depositType]! + depositTotal;
              } else {
                totalDepositsByType[depositType] = depositTotal;
              }

              totalDeposits += depositTotal;
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
            child: DataTable(columnSpacing: 20, headingRowHeight: 40, dataRowHeight: 40, columns: [
              DataColumn(
                label: textheader('Deposits'),
              ),
              DataColumn(
                label: textheader('Total'),
              ),
            ], rows: [
              // แสดงข้อมูลยอดรวมจาก totalDepositsByType
              ...totalDepositsByType.entries.map((entry) {
                final depositType = entry.key;
                final depositTotal = entry.value;
                // กำหนดสัญลักษณ์ + หรือ - ขึ้นอยู่กับค่าที่ได้
                final formattedTotal = depositTotal >= 0 ? "+\$${depositTotal.toStringAsFixed(2)}" : "-\$${depositTotal.abs().toStringAsFixed(2)}";

                return DataRow(cells: [
                  DataCell(textdetails(depositType)),
                  DataCell(textdetails(formattedTotal)),
                ]);
              }).toList(),

              // แถวสุดท้ายสำหรับการแสดง Total Deposits
              DataRow(cells: [
                DataCell(
                  textheader(
                    'Total Deposits',
                  ),
                ),
                DataCell(textheader("\$${totalDeposits.toStringAsFixed(2)}")),
              ]),
            ]),
          ));
        } else if (state is SummaryError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Center(child: Text('No data available'));
      },
    );
  }

  // Widget สำหรับ CraditCartTable
  Widget CraditCartTable({dynamic selectDate}) {
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

          // รวมข้อมูล CreditCards
          for (var summary in filteredSummaries) {
            Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
            var creditCards = jsonMap['CreditCards'] ?? {};

            creditCards.forEach((key, value) {
              double total = value.fold(0.0, (sum, item) => sum + (item['Value'] ?? 0.0));
              if (combinedCreditCards.containsKey(key)) {
                combinedCreditCards[key] = (combinedCreditCards[key] ?? 0.0) + total;
              } else {
                combinedCreditCards[key] = total;
              }
            });
          }
          final screenWidth = MediaQuery.of(context).size.width;

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
                    label: textheader('Credit Cards'),
                  ),
                  DataColumn(
                    label: textheader('Total'),
                  ),
                ],
                rows: [
                  ...combinedCreditCards.entries.map((entry) {
                    final cardType = entry.key;
                    final totalValue = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(textdetails(cardType)),
                        DataCell(textdetails("\$${totalValue.toStringAsFixed(2)}")),
                      ],
                    );
                  }).toList(),
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

  // Widget สำหรับ CashInCashOutTable
  Widget CashInCashOutTable({dynamic selectDate}) {
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

          // สร้างตัวแปรสำหรับเก็บยอดรวมของ CashIn และ CashOut
          double totalCashIn = 0.0;
          double totalCashOut = 0.0;

          // วนลูปผ่าน summaries ที่ถูกกรอง
          for (var summary in filteredSummaries) {
            Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
            var deposits = jsonMap['Deposits'];
            final cashIn = deposits['CashIn'] ?? 0.0;
            final cashOut = deposits['CashOut'] ?? 0.0;

            // รวมยอด CashIn และ CashOut
            totalCashIn += cashIn;
            totalCashOut += cashOut;
          }

          // สร้างแถวสำหรับ DataTable
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
                    label: textheader('Cash In / Cash Out'),
                  ),
                  DataColumn(
                    label: textheader('Total'),
                  ),
                ],
                rows: [
                  // แถวสำหรับ Cash In
                  DataRow(cells: [
                    DataCell(textdetails('Cash In')),
                    DataCell(textdetails('\$${totalCashIn.toStringAsFixed(2)}')),
                  ]),
                  // แถวสำหรับ Cash Out
                  DataRow(cells: [
                    DataCell(textdetails('Cash Out')),
                    DataCell(textdetails('\$${totalCashOut.toStringAsFixed(2)}')),
                  ]),
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

  Widget ServiceChargeTable({dynamic selectDate}) {
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

          Map<String, double> totalServiceChargeByType = {};
          double totalServiceCharge = 0.0; // สำหรับคำนวณยอดรวมทั้งหมด

          // วนลูปผ่าน summaries ที่ถูกกรอง
          for (var summary in filteredSummaries) {
            Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
            var servicecharge = jsonMap['ServiceCharge'];

            servicecharge.forEach((servicechargeType, servicechargeData) {
              double servicechargeTotal = 0.0;
              if (servicechargeData is List) {
                servicechargeTotal = servicechargeData.fold(0.0, (sum, item) => sum + (item['Value'] ?? 0.0));
              }

              if (totalServiceChargeByType.containsKey(servicechargeType)) {
                totalServiceChargeByType[servicechargeType] = totalServiceChargeByType[servicechargeType]! + servicechargeTotal;
              } else {
                totalServiceChargeByType[servicechargeType] = servicechargeTotal;
              }

              // คำนวณยอดรวมทั้งหมด
              totalServiceCharge += servicechargeTotal;
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
            child: DataTable(columnSpacing: 20, headingRowHeight: 40, dataRowHeight: 40, columns: [
              DataColumn(
                label: textheader('Service Charge'),
              ),
              DataColumn(
                label: textheader('Total'),
              ),
            ], rows: [
              // แสดงข้อมูลยอดรวมจาก totalServiceChargeByType
              ...totalServiceChargeByType.entries.map((entry) {
                final servicechargeType = entry.key;
                final servicechargeTotal = entry.value;
                // กำหนดสัญลักษณ์ + หรือ - ขึ้นอยู่กับค่าที่ได้
                final formattedTotal =
                    servicechargeTotal >= 0 ? "\$${servicechargeTotal.toStringAsFixed(2)}" : "\$${servicechargeTotal.abs().toStringAsFixed(2)}";

                return DataRow(cells: [
                  DataCell(textdetails(servicechargeType)),
                  DataCell(textdetails(formattedTotal)),
                ]);
              }).toList(),

              // แถวสุดท้ายสำหรับการแสดง Total ServiceCharge
              DataRow(cells: [
                DataCell(
                  textheader('Total Payments'),
                ),
                DataCell(textheader("\$${totalServiceCharge.toStringAsFixed(2)}")),
              ]),
            ]),
          ));
        } else if (state is SummaryError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Center(child: Text('No data available'));
      },
    );
  }

  // Widget สำหรับ CashInCashOutTable
  Widget GiftCardTable({dynamic selectDate}) {
    return BlocBuilder<SummaryBloc, SummaryState>(builder: (context, state) {
      if (state is SummaryLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SummaryLoaded) {
        final filteredSummaries = state.summaries.where((summary) {
          if (widget.selectDate != null && widget.selectDate.containsKey('filteredFromDate') && widget.selectDate.containsKey('filteredToDate')) {
            final summaryDate = DateTime.parse(summary['Date']).toLocal();
            final fromDate = DateTime.parse(widget.selectDate['filteredFromDate']).toLocal();
            final toDate = DateTime.parse(widget.selectDate['filteredToDate']).toLocal();

            // การกรองข้อมูลตามวันที่
            return summaryDate.isAfter(fromDate.subtract(Duration(days: 1))) && summaryDate.isBefore(toDate.add(Duration(days: 1)));
          }
          return true;
        }).toList();

        // สร้าง Map สำหรับเก็บค่า Activations, Redeemtions, Refunds
        Map<String, double> giftCardValues = {
          "Activations": 0.0,
          "Redeemtions": 0.0,
          "Refunds": 0.0,
        };

        // รวมค่าจากทุกข้อมูลใน filteredSummaries
        for (var summary in filteredSummaries) {
          // ดึงข้อมูล GiftCards จากฟิลด์ Data
          Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
          var giftcard = jsonMap['GiftCards']; // 'GiftCards' is a Map, not a List

          if (giftcard is Map) {
            double activations = giftcard['Activations'] as double? ?? 0.0;
            List redeemptions = giftcard['Redeemtions'] ?? [];
            List refunds = giftcard['Refunds'] ?? [];

            // เพิ่มค่า Activations
            giftCardValues["Activations"] = giftCardValues["Activations"]! + activations;

            // คำนวณค่า Redeemtions
            double totalRedeemtions = redeemptions.fold(0.0, (sum, item) {
              return sum + (item['Value'] as double? ?? 0.0);
            });
            giftCardValues["Redeemtions"] = giftCardValues["Redeemtions"]! + totalRedeemtions;

            // คำนวณค่า Refunds
            double totalRefunds = refunds.fold(0.0, (sum, item) {
              return sum + (item['Value'] as double? ?? 0.0);
            });
            giftCardValues["Refunds"] = giftCardValues["Refunds"]! + totalRefunds;
          } else {
            logger.e("'GiftCards' is not a Map: $giftcard");
          }
        }

        // สร้างแถวสำหรับ DataTable
        List<DataRow> rows = giftCardValues.entries.map((entry) {
          return DataRow(
            cells: [
              DataCell(textdetails(entry.key)), // ชื่อประเภท (Activations, Redeemtions, Refunds)
              DataCell(textdetails("\$${entry.value.toStringAsFixed(2)}")), // ค่า Total
            ],
          );
        }).toList();

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
                  label: textheader('Gift Cards'),
                ),
                DataColumn(
                  label: textheader('Total'),
                ),
              ],
              rows: rows, // ใช้แถวที่สร้างจาก giftCardValues
            ),
          ),
        );
      } else if (state is SummaryError) {
        return Center(child: Text('Error: ${state.message}'));
      }
      return Center(child: Text('No data available'));
    });
  }

  // Widget สำหรับ CustomersTable
  Widget CustomersTable({dynamic selectDate}) {
    return BlocBuilder<SummaryBloc, SummaryState>(builder: (context, state) {
      if (state is SummaryLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SummaryLoaded) {
        final filteredSummaries = state.summaries.where((summary) {
          if (widget.selectDate != null && widget.selectDate.containsKey('filteredFromDate') && widget.selectDate.containsKey('filteredToDate')) {
            final summaryDate = DateTime.parse(summary['Date']).toLocal();
            final fromDate = DateTime.parse(widget.selectDate['filteredFromDate']).toLocal();
            final toDate = DateTime.parse(widget.selectDate['filteredToDate']).toLocal();

            // การกรองข้อมูลตามวันที่
            return summaryDate.isAfter(fromDate.subtract(Duration(days: 1))) && summaryDate.isBefore(toDate.add(Duration(days: 1)));
          }
          return true;
        }).toList();

        Map<String, double> combinedCustomer = {};

        for (var summary in filteredSummaries) {
          Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
          List<dynamic> customer = jsonMap['Customers'] ?? [];
          // logger.w(customer);

          for (var item in customer) {
            String orderType = item['OrderType'];
            double value = (item['Value'] as num?)?.toDouble() ?? 0.0;

            if (combinedCustomer.containsKey(orderType)) {
              combinedCustomer[orderType] = combinedCustomer[orderType]! + value;
            } else {
              combinedCustomer[orderType] = value;
            }
          }
        }
        // logger.w(combinedCustomer);

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
                  label: textheader('Customers'),
                ),
                DataColumn(
                  label: textheader('Total'),
                ),
              ],
              rows: [
                ...combinedCustomer.entries.map((entry) {
                  final customerType = entry.key;
                  final totalValue = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(textdetails(customerType)),
                      DataCell(textdetails(totalValue.toInt().toString())),
                    ],
                  );
                }).toList(),
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
