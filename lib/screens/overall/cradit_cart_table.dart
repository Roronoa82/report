// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_event.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class CraditCartTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SummaryBloc()..add(LoadSummary()),
        child: BlocBuilder<SummaryBloc, SummaryState>(
          builder: (context, state) {
            if (state is SummaryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SummaryLoaded) {
              return ListView.builder(
                itemCount: state.summaries.length,
                itemBuilder: (context, index) {
                  final summary = state.summaries[index];
                  final data = summary['Data'];
                  String filterByEmployees = summary['FilterByEmployees'];

                  Map<String, dynamic> jsonMap = json.decode(data);

                  var creditCards = jsonMap['CreditCards'];
                  // var cash = jsonMap['cash'];
                  // var incomingSales = jsonMap['Sales']['IncomingSales'];
                  // logger.wtf('CreditCards: $creditCards');

                  // ฟังก์ชันคำนวณยอดรวม Value สำหรับแต่ละประเภทใน Deposits
                  double calculateDepositsValue(dynamic depositstData) {
                    return depositstData.fold(0.0, (sum, item) => sum + (item['Value'] ?? 0.0));
                  }

                  // คำนวณยอดรวมของ Deposits ทั้งหมด
                  double totalDeposits = 0.0;

                  // deposits.forEach((key, value) {
                  //   // ตรวจสอบให้แน่ใจว่า value เป็น List ก่อนคำนวณ
                  //   if (value is List) {
                  //     totalDeposits += value.fold(0.0, (sum, item) => sum + (item['Value'] ?? 0.0));
                  //   }
                  // });

                  return Column(
                    children: [
                      Table(
                        border: TableBorder.all(),
                        children: [
                          // หัวตาราง
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Credit Cards',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          ...creditCards.entries.map((entry) {
                            final depositstType = entry.key;
                            final depositstData = entry.value;
                            double depositsTotal = 0.0;

                            if (depositstData is List) {
                              depositsTotal = depositstData.fold(0.0, (sum, item) => sum + (item['Value'] ?? 0.0));
                            }
                            return TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(depositstType),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(" \$${depositsTotal.toStringAsFixed(2)}"), // Revenue Class Name
                                ),
                              ],
                            );
                          }).toList(),

                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Credit Card Sales',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "\$${totalDeposits.toStringAsFixed(2)}",
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Credit Card Tips',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "\$${totalDeposits.toStringAsFixed(2)}",
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Total Credit Cards',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "\$${totalDeposits.toStringAsFixed(2)}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else if (state is SummaryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
