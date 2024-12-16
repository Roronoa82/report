// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_event.dart';
import '../../bloc/summary_state.dart';

final logger = Logger();

class SalesTable extends StatelessWidget {
  final Map<String, DateTime?> summary;
  SalesTable({required this.summary});

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
              //   logger.w('Filtered Summaries00000: ${state.filteredSummaries}');
              // Filter summaries based on selected date range
              final fromDate = summary['fromDate'];
              final toDate = summary['toDate'];
              // ส่ง FilterDateEvent ไปยัง SummaryBloc
              if (fromDate != null && toDate != null) {
                context.read<SummaryBloc>().add(
                      FilterDateEvent(fromDate: fromDate, toDate: toDate),
                    );
              }
              // final filteredSummaries = state.summaries.where((summary) {
              //   // ตรวจสอบว่า Date ใน summary ตรงกับวันที่ที่เลือก
              //   return summary['Date'] == summary['selectedDate'].toString();
              // }).toList();
              return ListView.builder(
                itemCount: state.summaries.length,
                itemBuilder: (context, index) {
                  final summary = state.summaries[index];
                  final data = summary['Data'];
                  String filterByRevenue = summary['FilterByRevenue'];

                  // ตรวจสอบว่า data มีค่าเป็น JSON string หรือไม่
                  Map<String, dynamic> jsonMap;
                  try {
                    jsonMap = json.decode(data);
                  } catch (e) {
                    logger.e("Error decoding data: $e");
                    jsonMap = {}; // ถ้าเกิดข้อผิดพลาดให้ใช้ map ว่าง
                  }

                  // ตรวจสอบว่า jsonMap มีฟิลด์ 'Sales' หรือไม่
                  var netSales = jsonMap['Sales']?['NetSales'] ?? [];
                  var taxSales = jsonMap['Sales']?['TaxSales'] ?? [];
                  var incomingSales = jsonMap['Sales']?['IncomingSales'] ?? [];

                  // การคำนวณยอดรวม NetSales ด้วย fold
                  double totalNetSales = netSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));

// การคำนวณยอดรวม TaxSales ด้วย fold
                  double totalTaxSales = taxSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));

// การคำนวณยอดรวม IncomingSales ด้วย fold
                  double totalIncomingSales = incomingSales.fold(0.0, (sum, sale) => sum + (sale['Value'] as double? ?? 0.0));

                  Map<String, dynamic> jsonMapRevenue = json.decode(filterByRevenue);
                  var revenues = jsonMapRevenue['Revenues'] ?? [];
                  Map<String, double> combinedRevenue = {};

                  for (var revenue in revenues) {
                    String revenueClassName = revenue['RevenueClassName'];
                    double totalValue = 0.0;
                    for (var sale in revenue['NetSales']) {
                      totalValue += sale['Value'];
                    }
                    combinedRevenue[revenueClassName] = (combinedRevenue[revenueClassName] ?? 0.0) + totalValue;
                  }

                  return Column(
                    children: [
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Sales',
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
                          ...combinedRevenue.entries.map((entry) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(entry.key), // Revenue Class Name
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(" \$${entry.value.toStringAsFixed(2)}"), // Total Value
                                ),
                              ],
                            );
                          }).toList(),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Net Sales',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "\$${totalNetSales.toStringAsFixed(2)}", // ยอดรวม Net Sales
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Taxes',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "\$${totalTaxSales.toStringAsFixed(2)}", // ยอดรวม TaxSales
                                  style: TextStyle(fontWeight: FontWeight.bold),
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

// class SalesTable extends StatelessWidget {
//   final Map<String, DateTime?> summary;
//   SalesTable({required this.summary});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocProvider(
//         create: (context) => SummaryBloc()..add(LoadSummary()),
//         child: BlocBuilder<SummaryBloc, SummaryState>(
//           builder: (context, state) {
//             if (state is SummaryLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is SummaryLoaded) {
//               final filteredSummaries = state.summaries.where((summary) {
//                 // ตรวจสอบว่า Date ใน summary ตรงกับวันที่ที่เลือก
//                 return summary['Date'] == summary['selectedDate'].toString();
//               }).toList();
//               return ListView.builder(
//                 itemCount: state.summaries.length,
//                 itemBuilder: (context, index) {
//                   final summary = state.summaries[index];
//                   final data = summary['Data'];
//                   String filterByRevenue = summary['FilterByRevenue'];

//                   Map<String, dynamic> jsonMap = json.decode(data);

//                   var netSales = jsonMap['Sales']['NetSales'];
//                   var taxSales = jsonMap['Sales']['TaxSales'];
//                   var incomingSales = jsonMap['Sales']['IncomingSales'];
//                   //logger.wtf('NetSales: $netSales');
//                   //  logger.w('TaxSales: $taxSales');
//                   //  logger.wtf('IncomingSales: $incomingSales');
//                   Map<String, dynamic> jsonMapRevenue = json.decode(filterByRevenue);
//                   var revenues = jsonMapRevenue['Revenues'];
//                   //    logger.t('Revenues: $revenues');
//                   Map<String, double> combinedRevenue = {};

//                   // วนลูปผ่าน Revenues และรวมยอด Value ตาม RevenueClassName
//                   for (var revenue in revenues) {
//                     String revenueClassName = revenue['RevenueClassName'];
//                     double totalValue = 0.0;

//                     // รวมยอด Value จาก NetSales
//                     for (var sale in revenue['NetSales']) {
//                       totalValue += sale['Value'];
//                     }

//                     // รวมยอดถ้ามี RevenueClassName ซ้ำ
//                     if (combinedRevenue.containsKey(revenueClassName)) {
//                       combinedRevenue[revenueClassName] = combinedRevenue[revenueClassName]! + totalValue;
//                     } else {
//                       combinedRevenue[revenueClassName] = totalValue;
//                     }
//                   }

//                   double totalTaxSales = 0.0;
//                   for (var sale in taxSales) {
//                     totalTaxSales += sale['Value'];
//                   }

//                   // แสดงผลยอดรวม
//                   //  logger.w('Total TaxSales Value: \$${totalTaxSales.toStringAsFixed(2)}');

//                   // คำนวณยอดรวม NetSales ทั้งหมด
//                   double totalNetSales = netSales
//                       .map((sale) => sale['Value'] as double) // แปลงค่า 'Value' ให้เป็น double
//                       .reduce((a, b) => a + b); // รวมค่าทั้งหมด

//                   //     logger.wtf('Total Net Sales: \$${totalNetSales.toStringAsFixed(2)}');

//                   // คำนวณยอดรวม IncomingSales
//                   double totalIncomingSales = 0.0;
//                   for (var sale in incomingSales) incomingSales.fold(0.0, (sum, sale) => sum + (sale['Value'] ?? 0.0));

//                   //   logger.wtf('Total Incoming Sales: \$${totalIncomingSales.toStringAsFixed(2)}');

//                   // แสดงผลลัพธ์การรวมยอดขาย
//                   combinedRevenue.forEach((revenueClass, value) {
//                     //     logger.i('RevenueClassName: $revenueClass, Total Value: $value');
//                   });

//                   return Column(
//                     children: [
//                       // แสดงตาราง NetSales
//                       Table(
//                         border: TableBorder.all(),
//                         children: [
//                           // หัวตาราง
//                           TableRow(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Sales',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Total',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // แสดงข้อมูล RevenueClassName และ Total Value
//                           ...combinedRevenue.entries.map((entry) {
//                             return TableRow(
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Text(entry.key), // Revenue Class Name
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Text(" \$${entry.value.toStringAsFixed(2)}"), // Total Value
//                                 ),
//                               ],
//                             );
//                           }).toList(),

//                           // แสดง Total Net Sales
//                           TableRow(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Net Sales', // ข้อความที่แสดงในคอลัมน์แรก
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "\$${totalNetSales.toStringAsFixed(2)}", // ยอดรวม Net Sales ทั้งหมด
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           TableRow(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Taxes', // ข้อความที่แสดงในคอลัมน์แรก
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "\$${totalTaxSales.toStringAsFixed(2)}", // ยอดรวม Net Sales ทั้งหมด
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               );
//             } else if (state is SummaryError) {
//               return Center(child: Text('Error: ${state.message}'));
//             }
//             return Center(child: Text('No data available'));
//           },
//         ),
//       ),
//     );
//   }
// }
// import 'package:develop_resturant/bloc/summary_state.dart';
// import 'package:flutter/material.dart';

// import '../../model_summary.dart';

// class SalesTable extends StatelessWidget {
//   final dynamic summary;

//   const SalesTable({Key? key, required this.summary}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final filteredSales = summary.data.expand((outer) => outer).where((SummaryState) {
//       // ตรวจสอบว่า date ตรงกับวันที่ที่เลือก
//       return summary['Date'] == summary.date.toString(); // ปรับให้ตรงกับวันที่ที่เลือก
//     }).toList();

//     // ส่วนที่เหลือจะเหมือนเดิม
//     return Scaffold(
//       appBar: AppBar(title: Text('Sales Details')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Summary ID: ${summary.rpOverAllSummaryID}',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             SizedBox(height: 8),
//             Text('Filtered Sales for selected date:'),
//             ListView.builder(
//               itemCount: filteredSales.length,
//               itemBuilder: (context, index) {
//                 final summary = filteredSales[index];
//                 return ListTile(
//                   title: Text('Product: ${summary['Product']}'),
//                   subtitle: Text('Amount: \$${summary['Value']}'),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
