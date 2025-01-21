// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, deprecated_member_use, avoid_print, unused_element, sized_box_for_whitespace, library_private_types_in_public_api
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

class WeeklyTableSection extends StatefulWidget {
  final dynamic getDate;
  final dynamic selectDate;

  const WeeklyTableSection({Key? key, required this.getDate, this.selectDate}) : super(key: key);

  @override
  _WeeklyTableSectionState createState() => _WeeklyTableSectionState();
}

class _WeeklyTableSectionState extends State<WeeklyTableSection> {
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

  String formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          key: _key,
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
                  Map<String, Map<String, double>> totalSalesByOrderTypeByType = {};
                  Map<String, Map<String, double>> totalGiftCardByType = {};
                  Map<String, Map<String, double>> totalCustomersByType = {};

                  double totalDeposits = 0.0;
                  double totalCreditCards = 0.0;
                  double totalServiceCharge = 0.0;
                  double totalSalebyOdertypes = 0.0;
                  double totalGiftCards = 0.0;
                  double totalCustomers = 0.0;

                  List<String> combinedSummaryDates = [];
                  Map<String, Map<String, double>> discountsByDateAndType = {};
                  Map<String, Map<String, dynamic>> discountSummary = {};
                  double totalDiscounts = 0.0;
                  double ticketCount = 0.0;
                  double discountTotal = 0.0;

                  for (var summary in filteredSummaries) {
                    DateTime summaryDate = DateTime.parse(summary['Date']).toLocal();
                    String formattedDate =
                        "${summaryDate.year.toString().padLeft(4, '0')}/${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";
                    Map<String, dynamic> jsonMapRevenue = json.decode(summary['FilterByRevenue'] ?? '{}');
                    Map<String, dynamic> jsonMap = json.decode(summary['Data'] ?? '{}');
                    Map<String, dynamic> jsonMapDiscounts = json.decode(summary['FilterByDiscount'] ?? '{}');
                    Map<String, dynamic> jsonMapFilterByEmployees = json.decode(summary['FilterByEmployees'] ?? '{}');

                    var revenues = jsonMapRevenue['Revenues'] ?? [];
                    var payments = jsonMap['Payments'];
                    var deposits = jsonMap['Deposits'];
                    var creditcards = jsonMap['CreditCards'];
                    var servicecharges = jsonMap['ServiceCharge'];
                    var discounts = jsonMapDiscounts['Discounts'] ?? [];
                    var giftcard = jsonMap['GiftCards'] ?? [];
                    var customer = jsonMap['Customers'] ?? [];

                    var salebyordertypes = jsonMap['SalebyOrderType'];

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

                    for (var discount in discounts) {
                      var discountName = discount['DiscountName'];
                      var ticketList = discount['Ticket'] ?? [];
                      var amountList = discount['Amount'] ?? [];

                      ticketCount = ticketList.fold(0.0, (sum, item) {
                        var value = item['Value'] ?? 0.0;
                        return sum + (value is double ? value : value.toDouble()); // แปลง value เป็น double หากเป็น int
                      });

                      discountTotal = amountList.fold(0.0, (sum, item) {
                        var value = item['Value'] ?? 0.0;
                        return sum + (value is double ? value : value.toDouble());
                      });

                      if (discountSummary.containsKey(discountName)) {
                        discountSummary[discountName]!['Ticket'] += ticketCount;
                        discountSummary[discountName]!['Total'] += discountTotal;
                      } else {
                        discountSummary[discountName] = {
                          'Ticket': ticketCount,
                          'Total': discountTotal,
                        };
                      }
                      totalDiscounts += discountTotal;
                    }

                    salebyordertypes?.forEach((salebyordertypeType, salebyordertypeData) {
                      if (salebyordertypeData is Map) {
                        var salebyordertypeTotal = salebyordertypeData['Total'] as List;

                        for (var salebyordertype in salebyordertypeTotal) {
                          double salebyordertypeValue = salebyordertype['Value'] ?? 0.0;

                          totalSalesByOrderTypeByType.putIfAbsent(salebyordertypeType, () => {});
                          totalSalesByOrderTypeByType[salebyordertypeType]!['Total'] =
                              (totalSalesByOrderTypeByType[salebyordertypeType]!['Total'] ?? 0.0) + salebyordertypeValue;

                          if (salebyordertypeValue != 0) {
                            totalSalebyOdertypes += salebyordertypeValue;
                          }
                        }
                      }
                    });

                    giftcard?.forEach((giftcardType, giftcardData) {
                      if (giftcardData is List) {
                        for (var giftcard in giftcardData) {
                          double giftcardValue = giftcard['Value'] ?? 0.0;

                          totalGiftCardByType.putIfAbsent(giftcardType, () => {});

                          if (giftcardType == 'Activations') {
                            totalGiftCardByType[giftcardType]!['Total'] = (totalGiftCardByType[giftcardType]!['Total'] ?? 0.0) + giftcardValue;
                          } else if (giftcardType == 'Redeemtions') {
                            totalGiftCardByType[giftcardType]!['Total'] = (totalGiftCardByType[giftcardType]!['Total'] ?? 0.0) + giftcardValue;
                          } else if (giftcardType == 'Refunds') {
                            totalGiftCardByType[giftcardType]!['Total'] = (totalGiftCardByType[giftcardType]!['Total'] ?? 0.0) + giftcardValue;
                          }

                          // รวมยอด giftcards ทั้งหมด
                          if (giftcardValue != 0) {
                            totalGiftCards += giftcardValue;
                          }
                        }
                      }
                    });

                    customer.forEach((customerData) {
                      double customerValue = (customerData['Value'] ?? 0.0).toDouble(); // แปลงเป็น double

                      if (customerValue != 0) {
                        totalCustomersByType.putIfAbsent(customerData['OrderType'], () => {'Total': 0.0});

                        totalCustomersByType[customerData['OrderType']]!['Total'] =
                            (totalCustomersByType[customerData['OrderType']]!['Total'] ?? 0.0) + customerValue;

                        totalCustomers += customerValue;
                      }
                    });
                  }

                  List<String> allDates = revenueByDateAndClass.values.expand((map) => map.keys).toSet().toList()..sort();

                  List<List<String>> getWeeklyRanges(List<String> dates) {
                    List<List<String>> weeklyRanges = [];
                    DateTime? startOfWeek;
                    List<String> currentWeek = [];

                    for (var dateStr in dates) {
                      DateTime date = DateTime.parse(dateStr.replaceAll('/', '-'));

                      if (startOfWeek == null || date.difference(startOfWeek).inDays >= 7) {
                        if (currentWeek.isNotEmpty) {
                          weeklyRanges.add(List.from(currentWeek));
                        }
                        currentWeek = [dateStr];
                        startOfWeek = date.subtract(Duration(days: date.weekday - 1)); // วันแรกของสัปดาห์
                      } else {
                        currentWeek.add(dateStr);
                      }
                    }

                    if (currentWeek.isNotEmpty) {
                      weeklyRanges.add(List.from(currentWeek));
                    }

                    return weeklyRanges;
                  }

                  List<List<String>> weeklyRanges = getWeeklyRanges(allDates);

                  Map<String, Map<String, double>> getWeeklyRevenue(
                      Map<String, Map<String, double>> revenueByDateAndClass, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklyRevenue = {};

                    for (var category in revenueByDateAndClass.keys) {
                      var dateRevenue = revenueByDateAndClass[category]!;

                      for (var week in weeklyRanges) {
                        double totalRevenue = 0.0;
                        for (var dateStr in week) {
                          totalRevenue += dateRevenue[dateStr] ?? 0.0;
                        }
                        if (!weeklyRevenue.containsKey(category)) {
                          weeklyRevenue[category] = {};
                        }
                        weeklyRevenue[category]![week.join(', ')] = totalRevenue;
                      }
                    }
                    return weeklyRevenue;
                  }

                  Map<String, Map<String, double>> getWeeklyPaymentRevenue(
                      Map<String, Map<String, dynamic>> paymentTotals, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklyPaymentRevenue = {};

                    paymentTotals.forEach((paymentType, paymentData) {
                      double totalSales = paymentData['Sales'] ?? 0.0;
                      double totalTips = paymentData['Tips'] ?? 0.0;

                      double totalRevenue = totalSales + totalTips;

                      for (var week in weeklyRanges) {
                        double weeklyTotalRevenue = 0.0;

                        for (var dateStr in week) {
                          weeklyTotalRevenue += totalRevenue;
                        }

                        weeklyPaymentRevenue.putIfAbsent(paymentType, () => {});
                        weeklyPaymentRevenue[paymentType]![week.join(', ')] = weeklyTotalRevenue;
                      }
                    });

                    return weeklyPaymentRevenue;
                  }

                  Map<String, Map<String, double>> getWeeklyDepositRevenue(
                      Map<String, Map<String, dynamic>> depositTotals, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklyDepositRevenue = {};

                    depositTotals.forEach((depositType, depositData) {
                      double totalDepositValue = depositData['Total'] ?? 0.0;

                      for (var week in weeklyRanges) {
                        double weeklyTotalDeposit = 0.0;

                        for (var dateStr in week) {
                          weeklyTotalDeposit += totalDepositValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        weeklyDepositRevenue.putIfAbsent(depositType, () => {});
                        weeklyDepositRevenue[depositType]![week.join(', ')] = weeklyTotalDeposit;
                      }
                    });

                    return weeklyDepositRevenue;
                  }

                  Map<String, Map<String, double>> getWeeklyCreditCardRevenue(
                      Map<String, Map<String, dynamic>> creditTotals, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklyCreditCardRevenue = {};

                    creditTotals.forEach((creditcardType, creditcardData) {
                      double totalCreditCardValue = creditcardData['Total'] ?? 0.0;

                      for (var week in weeklyRanges) {
                        double weeklyTotalCreditCard = 0.0;

                        for (var dateStr in week) {
                          weeklyTotalCreditCard += totalCreditCardValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        weeklyCreditCardRevenue.putIfAbsent(creditcardType, () => {});
                        weeklyCreditCardRevenue[creditcardType]![week.join(', ')] = weeklyTotalCreditCard;
                      }
                    });

                    return weeklyCreditCardRevenue;
                  }

                  Map<String, Map<String, double>> getWeeklyServiceChargeRevenue(
                      Map<String, Map<String, dynamic>> servicechargeTotals, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklyServiceChargeRevenue = {};

                    servicechargeTotals.forEach((servicechargeType, servicechargeData) {
                      double totalServiceChargeValue = servicechargeData['Total'] ?? 0.0;

                      for (var week in weeklyRanges) {
                        double weeklyTotalServiceCharge = 0.0;

                        for (var dateStr in week) {
                          weeklyTotalServiceCharge += totalServiceChargeValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        weeklyServiceChargeRevenue.putIfAbsent(servicechargeType, () => {});
                        weeklyServiceChargeRevenue[servicechargeType]![week.join(', ')] = weeklyTotalServiceCharge;
                      }
                    });

                    return weeklyServiceChargeRevenue;
                  }

                  Map<String, List<Map<String, dynamic>>> getWeeklyDiscounts(
                      Map<String, Map<String, dynamic>> discountSummary, List<List<String>> weeklyRanges) {
                    Map<String, List<Map<String, dynamic>>> weeklyDiscounts = {};

                    discountSummary.forEach((discountName, data) {
                      double totalTickets = data['Ticket'] ?? 0.0;
                      double totalAmount = data['Total'] ?? 0.0;

                      for (var week in weeklyRanges) {
                        double weeklyTicket = 0.0;
                        double weeklyAmount = 0.0;

                        // คำนวณยอด Ticket และ Amount ต่อสัปดาห์
                        for (var date in week) {
                          weeklyTicket += totalTickets; // สมมติว่ายอดนี้ครอบคลุมทั้งสัปดาห์
                          weeklyAmount += totalAmount;
                        }

                        weeklyDiscounts.putIfAbsent(discountName, () => []);
                        weeklyDiscounts[discountName]!.add({
                          'Week': "${week.first} - ${week.last}",
                          'Ticket': weeklyTicket,
                          'Amount': weeklyAmount,
                        });
                      }
                    });

                    return weeklyDiscounts;
                  }

                  Map<String, Map<String, double>> getWeeklySalesByOrderTypeRevenue(
                      Map<String, Map<String, dynamic>> salesbyordertypeTotals, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklySalesByOrderTypeRevenue = {};

                    salesbyordertypeTotals.forEach((salesbyordertypeType, salesbyordertypeData) {
                      double totalSalesByOrderTypeValue = salesbyordertypeData['Total'] ?? 0.0;

                      for (var week in weeklyRanges) {
                        double weeklyTotalSalesByOrderType = 0.0;

                        for (var dateStr in week) {
                          weeklyTotalSalesByOrderType += totalSalesByOrderTypeValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        weeklySalesByOrderTypeRevenue.putIfAbsent(salesbyordertypeType, () => {});
                        weeklySalesByOrderTypeRevenue[salesbyordertypeType]![week.join(', ')] = weeklyTotalSalesByOrderType;
                      }
                    });

                    return weeklySalesByOrderTypeRevenue;
                  }

                  Map<String, Map<String, double>> getWeeklyGiftCardRevenue(
                      Map<String, Map<String, dynamic>> giftcardTotals, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklyGiftCardRevenue = {
                      'Activations': {},
                      'Redeemtions': {},
                      'Refunds': {},
                    };

                    giftcardTotals.forEach((giftcardType, giftcardData) {
                      double totalGiftCardValue = giftcardData['Total'] ?? 0.0;

                      for (var week in weeklyRanges) {
                        double weeklyTotalGiftCard = 0.0;
                        for (var dateStr in week) {
                          weeklyTotalGiftCard += totalGiftCardValue;
                        }
                        weeklyGiftCardRevenue.putIfAbsent(giftcardType, () => {});
                        weeklyGiftCardRevenue[giftcardType]![week.join(', ')] = weeklyTotalGiftCard;
                      }
                    });

                    return weeklyGiftCardRevenue;
                  }

                  Map<String, Map<String, double>> getWeeklyCustomerRevenue(
                      Map<String, Map<String, dynamic>> customerTotals, List<List<String>> weeklyRanges) {
                    Map<String, Map<String, double>> weeklyCustomerRevenue = {};

                    customerTotals.forEach((customerType, customerData) {
                      double totalCustomerValue = customerData['Total'] ?? 0.0;

                      for (var week in weeklyRanges) {
                        double weeklyTotalCustomer = 0.0;

                        for (var dateStr in week) {
                          weeklyTotalCustomer += totalCustomerValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        weeklyCustomerRevenue.putIfAbsent(customerType, () => {});
                        weeklyCustomerRevenue[customerType]![week.join(', ')] = weeklyTotalCustomer;
                      }
                    });

                    return weeklyCustomerRevenue;
                  }

                  Map<String, Map<String, double>> weeklyPaymentRevenue = getWeeklyPaymentRevenue(paymentTotals, weeklyRanges);
                  Map<String, Map<String, double>> weeklyDepositRevenue = getWeeklyDepositRevenue(totalDepositsByType, weeklyRanges);
                  Map<String, Map<String, double>> weeklyCreditCardRevenue = getWeeklyCreditCardRevenue(totalCreditCardsByType, weeklyRanges);
                  Map<String, Map<String, double>> weeklyServiceChargeRevenue = getWeeklyServiceChargeRevenue(totalServiceChargeByType, weeklyRanges);
                  Map<String, List<Map<String, dynamic>>> weeklyDiscounts = getWeeklyDiscounts(discountSummary, weeklyRanges);
                  Map<String, Map<String, double>> weeklySalesByOrderTypeRevenue =
                      getWeeklySalesByOrderTypeRevenue(totalSalesByOrderTypeByType, weeklyRanges);
                  Map<String, Map<String, double>> weeklyGiftCardRevenue = getWeeklyGiftCardRevenue(totalGiftCardByType, weeklyRanges);
                  Map<String, Map<String, double>> weeklyCustomerRevenue = getWeeklyCustomerRevenue(totalCustomersByType, weeklyRanges);

                  weeklyPaymentRevenue.forEach((paymentType, weeklyData) {
                    weeklyData.forEach((week, totalRevenue) {});
                  });
                  weeklyDepositRevenue.forEach((depositType, weeklyData) {
                    weeklyData.forEach((week, totalRevenue) {});
                  });

                  Map<String, Map<String, double>> weeklyRevenue = getWeeklyRevenue(revenueByDateAndClass, weeklyRanges);

                  weeklyRevenue.forEach((category, weeklyData) {
                    weeklyData.forEach((week, totalRevenue) {});
                  });

                  weeklyDiscounts.forEach((discountName, data) {
                    for (var weekData in data) {}
                  });
                  List<String> weeklyData(List<List<String>> weeklyRanges) {
                    return weeklyRanges.map((week) => "${week.first} - ${week.last}").toList();
                  }

                  weeklySalesByOrderTypeRevenue.forEach((salesbyordertypeType, weeklyData) {
                    weeklyData.forEach((week, totalRevenue) {});
                  });
                  weeklyGiftCardRevenue.forEach((giftcardType, weeklyData) {
                    weeklyData.forEach((week, totalRevenue) {});
                  });

                  List<double> totalRevenue(Map<String, Map<String, double>> weeklyRevenue, String category, List<List<String>> weeklyRanges) {
                    return weeklyRanges.map((week) {
                      double totalRevenue = 0;
                      for (var date in week) {
                        print('Date: $date, Revenue: ${weeklyRevenue[category]?[date]}');
                        totalRevenue += weeklyRevenue[category]?[date] ?? 0;
                      }

                      return totalRevenue;
                    }).toList();
                  }

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
                          // reverse: false,
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                        label: SizedBox(
                                      width: 120,
                                      child: textheader('Sales'),
                                    )),
                                    ...weeklyRanges.map((week) {
                                      String weekRange = ("${week.first} - ${week.last}");
                                      return DataColumn(
                                        label: textheader(weekRange),
                                      );
                                    }).toList(),
                                  ],
                                  rows: weeklyRevenue.keys.map((category) {
                                    return DataRow(
                                      cells: [
                                        DataCell(textdetails(category)), // เซลล์สำหรับชื่อหมวดหมู่
                                        ...weeklyRanges.map((week) {
                                          String weekRange = week.join(', ');
                                          double totalRevenue = weeklyRevenue[category]?[weekRange] ?? 0.0;
                                          return DataCell(textdetails(totalRevenue.toStringAsFixed(2))); // เซลล์สำหรับรายได้รายสัปดาห์
                                        }).toList(),
                                      ],
                                    );
                                  }).toList(),
                                ),

                                // Payments
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Payments'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 168,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...weeklyPaymentRevenue.keys.map((paymentType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(paymentType)),
                                          ...weeklyRanges.map((week) {
                                            String weekRange = week.join(', ');
                                            double totalRevenue = weeklyPaymentRevenue[paymentType]?[weekRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Payments')),
                                        ...weeklyRanges.map((week) {
                                          String weekRange = week.join(', ');
                                          double totalRevenueForWeek = weeklyPaymentRevenue.values.fold(0.0, (sum, paymentTypeRevenue) {
                                            return sum + (paymentTypeRevenue[weekRange] ?? 0.0);
                                          });
                                          return DataCell(textdetails(totalRevenueForWeek == 0.0
                                              ? "\$XX.XX"
                                              : "\$${totalRevenueForWeek.toStringAsFixed(2)}")); // แสดงผลรวมรายได้ของแต่ละช่วงสัปดาห์
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),

                                //Deposits
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Deposits'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...weeklyDepositRevenue.keys.map((depositType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(depositType)),
                                          ...weeklyRanges.map((week) {
                                            String weekRange = week.join(', ');
                                            double totalRevenue = weeklyDepositRevenue[depositType]?[weekRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Deposits')),
                                        ...weeklyRanges.map((week) {
                                          String weekRange = week.join(', ');
                                          double totalRevenueForWeek = weeklyDepositRevenue.values.fold(0.0, (sum, depositTypeRevenue) {
                                            return sum + (depositTypeRevenue[weekRange] ?? 0.0);
                                          });
                                          return DataCell(
                                              textdetails(totalRevenueForWeek == 0.0 ? "\$XX.XX" : "\$${totalRevenueForWeek.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                //Credit Cards
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Creditcards'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...weeklyCreditCardRevenue.keys.map((creditcardType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(creditcardType)),
                                          ...weeklyRanges.map((week) {
                                            String weekRange = week.join(', ');
                                            double totalRevenue = weeklyCreditCardRevenue[creditcardType]?[weekRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Deposits')),
                                        ...weeklyRanges.map((week) {
                                          String weekRange = week.join(', ');
                                          double totalRevenueForWeek = weeklyCreditCardRevenue.values.fold(0.0, (sum, creditcardTypeRevenue) {
                                            return sum + (creditcardTypeRevenue[weekRange] ?? 0.0);
                                          });
                                          return DataCell(
                                              textdetails(totalRevenueForWeek == 0.0 ? "\$XX.XX" : "\$${totalRevenueForWeek.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                // CashIn/cashOut
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Cash In / Cash \nOut'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    // Cash In Row
                                    DataRow(
                                      cells: [
                                        DataCell(textdetails('Cash In')),
                                        ...weeklyRanges.map((week) {
                                          final weeklyTotal = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";

                                            return week.contains(formattedDate);
                                          }).fold(0.0, (sum, summary) {
                                            final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                            final cashIn = deposits['CashIn'] ?? 0.0;
                                            return sum + cashIn;
                                          });

                                          return DataCell(textdetails(weeklyTotal == 0.0 ? "\$XX.XX" : "\$${weeklyTotal.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                    // Cash Out Row
                                    DataRow(
                                      cells: [
                                        DataCell(textdetails('Cash Out')),
                                        ...weeklyRanges.map((week) {
                                          final weeklyTotal = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";

                                            return week.contains(formattedDate);
                                          }).fold(0.0, (sum, summary) {
                                            final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                            final cashOut = deposits['CashOut'] ?? 0.0;
                                            return sum + cashOut;
                                          });

                                          return DataCell(textdetails(weeklyTotal == 0.0 ? "\$XX.XX" : "\$${weeklyTotal.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),

                                // ServiceCharge
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Service Charges'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...weeklyServiceChargeRevenue.keys.map((servicechargeType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(servicechargeType)),
                                          ...weeklyRanges.map((week) {
                                            String weekRange = week.join(', ');
                                            double totalRevenue = weeklyServiceChargeRevenue[servicechargeType]?[weekRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Service Charges')),
                                        ...weeklyRanges.map((week) {
                                          String weekRange = week.join(', ');
                                          double totalRevenueForWeek = weeklyCreditCardRevenue.values.fold(0.0, (sum, creditcardTypeRevenue) {
                                            return sum + (creditcardTypeRevenue[weekRange] ?? 0.0);
                                          });
                                          return DataCell(
                                              textdetails(totalRevenueForWeek == 0.0 ? "\$XX.XX" : "\$${totalRevenueForWeek.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                // Discounts
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Discounts'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...weeklyDiscounts.entries.map((entry) {
                                      String discountName = entry.key;
                                      List<Map<String, dynamic>> data = entry.value;

                                      List<DataCell> rowCells = [
                                        DataCell(Text(discountName)),
                                        ...weeklyRanges.map((week) {
                                          String weekRange = "${week.first} - ${week.last}";
                                          var weekData = data.firstWhere(
                                            (dataItem) => dataItem['Week'] == weekRange,
                                            orElse: () => {'Amount': 0.0},
                                          );
                                          return DataCell(textdetails(weekData['Amount'].toStringAsFixed(2)));
                                        }).toList(),
                                      ];

                                      return DataRow(cells: rowCells);
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Discounts')),
                                        ...weeklyRanges.map((week) {
                                          double totalAmountForWeek = weeklyDiscounts.values.fold(0.0, (sum, data) {
                                            var weekRange = "${week.first} - ${week.last}";
                                            var weekData =
                                                data.firstWhere((dataItem) => dataItem['Week'] == weekRange, orElse: () => {'Amount': 0.0});
                                            return sum + weekData['Amount'];
                                          });

                                          return DataCell(textdetails(totalAmountForWeek.toStringAsFixed(2)));
                                        }).toList(),
                                      ],
                                    ),
                                  ],
                                ),

                                // SalesbyorderType
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Sales by Order \nType'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...weeklySalesByOrderTypeRevenue.keys.map((salesbyordertypeType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(salesbyordertypeType)),
                                          ...weeklyRanges.map((week) {
                                            String weekRange = week.join(', ');
                                            double totalRevenue = weeklySalesByOrderTypeRevenue[salesbyordertypeType]?[weekRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),

                                //Gift Cards
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Gift Cards'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: weeklyGiftCardRevenue.keys.map((giftcardType) {
                                    return DataRow(
                                      cells: [
                                        DataCell(textdetails(giftcardType)), // ชื่อประเภท Gift Card
                                        ...weeklyRanges.map((week) {
                                          String weekRange = week.join(', '); // เชื่อมวันในสัปดาห์
                                          double totalRevenue = weeklyGiftCardRevenue[giftcardType]?[weekRange] ?? 0.0;
                                          return DataCell(textdetails(
                                                  totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}") // แสดงยอดตามเงื่อนไข
                                              );
                                        }).toList(),
                                      ],
                                    );
                                  }).toList(),
                                ),

                                //Customers
                                DataTable(
                                  columnSpacing: 30.0,
                                  headingRowHeight: 65.0,
                                  dataRowHeight: 45.0,
                                  dividerThickness: 1,
                                  border: buildTableBorder(),
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 120,
                                        child: textheader('Customers'),
                                      ),
                                    ),
                                    ...weeklyRanges.map((week) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: weeklyCustomerRevenue.keys.map((customerType) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(customerType)),
                                        ...weeklyRanges.map((week) {
                                          String weekRange = week.join(', ');
                                          double totalRevenue = weeklyCustomerRevenue[customerType]?[weekRange] ?? 0.0;
                                          return DataCell(textdetails(
                                              totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                        }).toList(),
                                      ],
                                    );
                                  }).toList(),
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
