// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import 'line_chart_page.dart';
import '../../bloc/summary_bloc.dart';
import '../../bloc/summary_state.dart';

final GlobalKey _key = GlobalKey();
final logger = Logger();

class MonthlyTableSection extends StatefulWidget {
  final dynamic getDate;
  final dynamic selectDate;

  const MonthlyTableSection({Key? key, required this.getDate, this.selectDate}) : super(key: key);

  @override
  _MonthlyTableSectionState createState() => _MonthlyTableSectionState();
}

class _MonthlyTableSectionState extends State<MonthlyTableSection> {
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

  String formatMonthYear(DateTime date) {
    return DateFormat('MMM, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          key: _key,
          child: Column(children: [
            SizedBox(height: 16),
            Container(height: MediaQuery.of(context).size.height * 0.346, child: LineChartPage()),
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
                      // logger.d(revenueClassName);
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
                    // print(totalCustomersByType);
                    // print('Total Customers: $totalCustomers');
                  }

                  List<String> allDates = revenueByDateAndClass.values.expand((map) => map.keys).toSet().toList()..sort();
                  // logger.w(revenueByDateAndClass.values);
                  // logger.t(revenueByDateAndClass);

                  List<List<String>> getMonthlyRanges(List<String> dates) {
                    List<List<String>> monthlyRanges = [];
                    DateTime? startOfMonth;
                    List<String> currentMonth = [];

                    for (var dateStr in dates) {
                      dateStr = dateStr.replaceAll('/', '-');
                      DateTime date = DateTime.parse(dateStr);

                      if (startOfMonth == null || date.month != startOfMonth.month || date.year != startOfMonth.year) {
                        if (currentMonth.isNotEmpty) {
                          monthlyRanges.add(currentMonth);
                        }
                        currentMonth = [dateStr];
                        startOfMonth = DateTime(date.year, date.month);
                      } else {
                        currentMonth.add(dateStr);
                      }
                    }
                    if (currentMonth.isNotEmpty) {
                      monthlyRanges.add(currentMonth);
                    }
                    return monthlyRanges;
                  }

                  String formatMonthYear(String dateStr) {
                    DateTime date = DateTime.parse(dateStr.replaceAll('/', '-'));

                    return DateFormat('MMM, yyyy').format(date);
                  }

                  List<List<String>> monthlyRanges = getMonthlyRanges(allDates);

                  Map<String, Map<String, double>> getMonthlyRevenue(
                      Map<String, Map<String, double>> revenueByDateAndClass, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlyRevenue = {};
                    for (var category in revenueByDateAndClass.keys) {
                      var dateRevenue = revenueByDateAndClass[category]!;

                      for (var month in monthlyRanges) {
                        double totalRevenue = 0.0;
                        String formattedMonthYear = formatMonthYear(month.first);

                        Map<String, double> totalRevenueForMonth = {};
                        for (var dateStr in month) {
                          totalRevenue += dateRevenue[dateStr] ?? 0.0;
                          if (revenueByDateAndClass.containsKey(dateStr)) {
                            revenueByDateAndClass[dateStr]!.forEach((classKey, revenue) {
                              if (!totalRevenueForMonth.containsKey(classKey)) {
                                totalRevenueForMonth[classKey] = 0;
                              }
                              totalRevenueForMonth[classKey] = totalRevenueForMonth[classKey]! + revenue;
                            });
                          }
                        }
                        if (!monthlyRevenue.containsKey(category)) {
                          monthlyRevenue[category] = {};
                        }
                        monthlyRevenue[category]![month.join(', ')] = totalRevenue;
                        // print('totalRevenue Class: ${totalRevenue},');

                        if (totalRevenueForMonth.isNotEmpty) {
                          monthlyRevenue[formattedMonthYear] = totalRevenueForMonth;
                        }
                      }
                      // print('Revenue Class: ${category},');
                    }

                    return monthlyRevenue;
                  }

                  Map<String, Map<String, double>> getMonthlyPaymentRevenue(
                      Map<String, Map<String, dynamic>> paymentTotals, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlyPaymentRevenue = {};

                    paymentTotals.forEach((paymentType, paymentData) {
                      double totalSales = paymentData['Sales'] ?? 0.0;
                      double totalTips = paymentData['Tips'] ?? 0.0;

                      double totalRevenue = totalSales + totalTips;

                      for (var month in monthlyRanges) {
                        double monthlyTotalRevenue = 0.0;

                        for (var dateStr in month) {
                          monthlyTotalRevenue += totalRevenue;
                        }

                        monthlyPaymentRevenue.putIfAbsent(paymentType, () => {});
                        monthlyPaymentRevenue[paymentType]![month.join(', ')] = monthlyTotalRevenue;
                      }
                    });

                    return monthlyPaymentRevenue;
                  }

                  Map<String, Map<String, double>> getMonthlyDepositRevenue(
                      Map<String, Map<String, dynamic>> depositTotals, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlyDepositRevenue = {};

                    depositTotals.forEach((depositType, depositData) {
                      double totalDepositValue = depositData['Total'] ?? 0.0;

                      for (var month in monthlyRanges) {
                        double monthlyTotalDeposit = 0.0;

                        for (var dateStr in month) {
                          monthlyTotalDeposit += totalDepositValue;
                        }

                        monthlyDepositRevenue.putIfAbsent(depositType, () => {});
                        monthlyDepositRevenue[depositType]![month.join(', ')] = monthlyTotalDeposit;
                      }
                    });

                    return monthlyDepositRevenue;
                  }

                  Map<String, Map<String, double>> getMonthlyCreditCardRevenue(
                      Map<String, Map<String, dynamic>> creditTotals, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlyCreditCardRevenue = {};

                    creditTotals.forEach((creditcardType, creditcardData) {
                      double totalCreditCardValue = creditcardData['Total'] ?? 0.0;

                      for (var month in monthlyRanges) {
                        double monthlyTotalCreditCard = 0.0;

                        for (var dateStr in month) {
                          monthlyTotalCreditCard += totalCreditCardValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        monthlyCreditCardRevenue.putIfAbsent(creditcardType, () => {});
                        monthlyCreditCardRevenue[creditcardType]![month.join(', ')] = monthlyTotalCreditCard;
                      }
                    });

                    return monthlyCreditCardRevenue;
                  }

                  Map<String, Map<String, double>> getMonthlyServiceChargeRevenue(
                      Map<String, Map<String, dynamic>> servicechargeTotals, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlyServiceChargeRevenue = {};

                    servicechargeTotals.forEach((servicechargeType, servicechargeData) {
                      double totalServiceChargeValue = servicechargeData['Total'] ?? 0.0;

                      for (var month in monthlyRanges) {
                        double monthlyTotalServiceCharge = 0.0;

                        for (var dateStr in month) {
                          monthlyTotalServiceCharge += totalServiceChargeValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        monthlyServiceChargeRevenue.putIfAbsent(servicechargeType, () => {});
                        monthlyServiceChargeRevenue[servicechargeType]![month.join(', ')] = monthlyTotalServiceCharge;
                      }
                    });

                    return monthlyServiceChargeRevenue;
                  }

                  Map<String, List<Map<String, dynamic>>> getMonthlyDiscounts(
                      Map<String, Map<String, dynamic>> discountSummary, List<List<String>> monthlyRanges) {
                    Map<String, List<Map<String, dynamic>>> monthlyDiscounts = {};

                    discountSummary.forEach((discountName, data) {
                      double totalTickets = data['Ticket'] ?? 0.0;
                      double totalAmount = data['Total'] ?? 0.0;

                      for (var month in monthlyRanges) {
                        double monthlyTicket = 0.0;
                        double monthlyAmount = 0.0;

                        for (var date in month) {
                          monthlyTicket += totalTickets;
                          monthlyAmount += totalAmount;
                        }

                        monthlyDiscounts.putIfAbsent(discountName, () => []);
                        monthlyDiscounts[discountName]!.add({
                          'Week': "${month.first} - ${month.last}",
                          'Ticket': monthlyTicket,
                          'Amount': monthlyAmount,
                        });
                      }
                    });

                    return monthlyDiscounts;
                  }

                  Map<String, Map<String, double>> getMonthlySalesByOrderTypeRevenue(
                      Map<String, Map<String, dynamic>> salesbyordertypeTotals, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlySalesByOrderTypeRevenue = {};

                    salesbyordertypeTotals.forEach((salesbyordertypeType, salesbyordertypeData) {
                      double totalSalesByOrderTypeValue = salesbyordertypeData['Total'] ?? 0.0;

                      for (var month in monthlyRanges) {
                        double monthlyTotalSalesByOrderType = 0.0;

                        for (var dateStr in month) {
                          monthlyTotalSalesByOrderType += totalSalesByOrderTypeValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        monthlySalesByOrderTypeRevenue.putIfAbsent(salesbyordertypeType, () => {});
                        monthlySalesByOrderTypeRevenue[salesbyordertypeType]![month.join(', ')] = monthlyTotalSalesByOrderType;
                      }
                    });

                    return monthlySalesByOrderTypeRevenue;
                  }

                  Map<String, Map<String, double>> getMonthlyGiftCardRevenue(
                      Map<String, Map<String, dynamic>> giftcardTotals, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlyGiftCardRevenue = {
                      'Activations': {},
                      'Redeemtions': {},
                      'Refunds': {},
                    };

                    giftcardTotals.forEach((giftcardType, giftcardData) {
                      double totalGiftCardValue = giftcardData['Total'] ?? 0.0;

                      for (var month in monthlyRanges) {
                        double monthlyTotalGiftCard = 0.0;
                        for (var dateStr in month) {
                          monthlyTotalGiftCard += totalGiftCardValue;
                        }
                        monthlyGiftCardRevenue.putIfAbsent(giftcardType, () => {});
                        monthlyGiftCardRevenue[giftcardType]![month.join(', ')] = monthlyTotalGiftCard;
                      }
                    });

                    return monthlyGiftCardRevenue;
                  }

                  Map<String, Map<String, double>> getMonthlyCustomerRevenue(
                      Map<String, Map<String, dynamic>> customerTotals, List<List<String>> monthlyRanges) {
                    Map<String, Map<String, double>> monthlyCustomerRevenue = {};

                    customerTotals.forEach((customerType, customerData) {
                      double totalCustomerValue = customerData['Total'] ?? 0.0;

                      for (var month in monthlyRanges) {
                        double monthlyTotalCustomer = 0.0;

                        for (var dateStr in month) {
                          monthlyTotalCustomer += totalCustomerValue; // เพิ่มยอดฝากในแต่ละวัน
                        }

                        monthlyCustomerRevenue.putIfAbsent(customerType, () => {});
                        monthlyCustomerRevenue[customerType]![month.join(', ')] = monthlyTotalCustomer;
                      }
                    });

                    return monthlyCustomerRevenue;
                  }

                  Map<String, Map<String, double>> monthlyPaymentRevenue = getMonthlyPaymentRevenue(paymentTotals, monthlyRanges);
                  Map<String, Map<String, double>> monthlyDepositRevenue = getMonthlyDepositRevenue(totalDepositsByType, monthlyRanges);
                  Map<String, Map<String, double>> monthlyCreditCardRevenue = getMonthlyCreditCardRevenue(totalCreditCardsByType, monthlyRanges);
                  Map<String, Map<String, double>> monthlyServiceChargeRevenue =
                      getMonthlyServiceChargeRevenue(totalServiceChargeByType, monthlyRanges);
                  Map<String, List<Map<String, dynamic>>> monthlyDiscounts = getMonthlyDiscounts(discountSummary, monthlyRanges);
                  Map<String, Map<String, double>> monthlySalesByOrderTypeRevenue =
                      getMonthlySalesByOrderTypeRevenue(totalSalesByOrderTypeByType, monthlyRanges);
                  Map<String, Map<String, double>> monthlyGiftCardRevenue = getMonthlyGiftCardRevenue(totalGiftCardByType, monthlyRanges);
                  Map<String, Map<String, double>> monthlyCustomerRevenue = getMonthlyCustomerRevenue(totalCustomersByType, monthlyRanges);

                  monthlyPaymentRevenue.forEach((paymentType, monthlyData) {
                    monthlyData.forEach((month, totalRevenue) {});
                  });
                  monthlyDepositRevenue.forEach((depositType, monthlyData) {
                    monthlyData.forEach((month, totalRevenue) {});
                  });

                  Map<String, Map<String, double>> monthlyRevenue = getMonthlyRevenue(revenueByDateAndClass, monthlyRanges);

                  monthlyRevenue.forEach((category, monthlyData) {
                    monthlyData.forEach((month, totalRevenue) {});
                  });

                  monthlyDiscounts.forEach((discountName, data) {
                    for (var MonthData in data) {}
                  });
                  List<String> monthlyData(List<List<String>> monthlyRanges) {
                    return monthlyRanges.map((month) => "${month.first} - ${month.last}").toList();
                  }

                  monthlySalesByOrderTypeRevenue.forEach((salesbyordertypeType, monthlyData) {
                    monthlyData.forEach((month, totalRevenue) {});
                  });
                  monthlyGiftCardRevenue.forEach((giftcardType, monthlyData) {
                    monthlyData.forEach((month, totalRevenue) {});
                  });

                  List<double> totalRevenue(
                      Map<String, Map<String, double>> monthlyRevenue,
                      List<String> categories, // รายชื่อหมวดหมู่ที่ต้องการคำนวณ
                      List<List<String>> monthlyRanges) {
                    return monthlyRanges.map((month) {
                      double totalRevenue = 0;
                      for (var category in categories) {
                        // เพิ่มการคำนวณสำหรับแต่ละหมวดหมู่
                        for (var date in month) {
                          // ตรวจสอบว่า category และ date มีใน monthlyRevenue หรือไม่
                          double revenue = monthlyRevenue[category]?[date] ?? 0;
                          print('Category: $category, Date: $date, Revenue: $revenue');
                          totalRevenue += revenue;
                        }
                      }
                      logger.e('Total Revenue for this month: $totalRevenue');
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
                                    ...monthlyRanges.map((month) {
                                      String formattedMonthYear = formatMonthYear(month.first);
                                      return DataColumn(
                                        label: textheader(formattedMonthYear),
                                      );
                                    }).toList(),
                                  ],
                                  rows: monthlyRevenue.keys.map((category) {
                                    return DataRow(
                                      cells: [
                                        DataCell(textdetails(category)), // เซลล์สำหรับชื่อหมวดหมู่
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = month.join(', ');
                                          double totalRevenue = monthlyRevenue[category]?[MonthRange] ?? 0.0;
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 168,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...monthlyPaymentRevenue.keys.map((paymentType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(paymentType)),
                                          ...monthlyRanges.map((month) {
                                            String MonthRange = month.join(', ');
                                            double totalRevenue = monthlyPaymentRevenue[paymentType]?[MonthRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Payments')),
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = month.join(', ');
                                          double totalRevenueForWeek = monthlyPaymentRevenue.values.fold(0.0, (sum, paymentTypeRevenue) {
                                            return sum + (paymentTypeRevenue[MonthRange] ?? 0.0);
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...monthlyDepositRevenue.keys.map((depositType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(depositType)),
                                          ...monthlyRanges.map((month) {
                                            String MonthRange = month.join(', ');
                                            double totalRevenue = monthlyDepositRevenue[depositType]?[MonthRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Deposits')),
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = month.join(', ');
                                          double totalRevenueForWeek = monthlyDepositRevenue.values.fold(0.0, (sum, depositTypeRevenue) {
                                            return sum + (depositTypeRevenue[MonthRange] ?? 0.0);
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...monthlyCreditCardRevenue.keys.map((creditcardType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(creditcardType)),
                                          ...monthlyRanges.map((month) {
                                            String MonthRange = month.join(', ');
                                            double totalRevenue = monthlyCreditCardRevenue[creditcardType]?[MonthRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Deposits')),
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = month.join(', ');
                                          double totalRevenueForWeek = monthlyCreditCardRevenue.values.fold(0.0, (sum, creditcardTypeRevenue) {
                                            return sum + (creditcardTypeRevenue[MonthRange] ?? 0.0);
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
                                    ...monthlyRanges.map((month) {
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
                                        ...monthlyRanges.map((month) {
                                          final monthlyTotal = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";

                                            return month.contains(formattedDate);
                                          }).fold(0.0, (sum, summary) {
                                            final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                            final cashIn = deposits['CashIn'] ?? 0.0;
                                            return sum + cashIn;
                                          });

                                          return DataCell(textdetails(monthlyTotal == 0.0 ? "\$XX.XX" : "\$${monthlyTotal.toStringAsFixed(2)}"));
                                        }).toList(),
                                      ],
                                    ),
                                    // Cash Out Row
                                    DataRow(
                                      cells: [
                                        DataCell(textdetails('Cash Out')),
                                        ...monthlyRanges.map((month) {
                                          final monthlyTotal = filteredSummaries.where((summary) {
                                            final summaryDate = DateTime.parse(summary['Date']).toLocal();
                                            final formattedDate =
                                                "${summaryDate.month.toString().padLeft(2, '0')}/${summaryDate.day.toString().padLeft(2, '0')}";

                                            return month.contains(formattedDate);
                                          }).fold(0.0, (sum, summary) {
                                            final deposits = json.decode(summary['Data'] ?? '{}')['Deposits'] ?? {};
                                            final cashOut = deposits['CashOut'] ?? 0.0;
                                            return sum + cashOut;
                                          });

                                          return DataCell(textdetails(monthlyTotal == 0.0 ? "\$XX.XX" : "\$${monthlyTotal.toStringAsFixed(2)}"));
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...monthlyServiceChargeRevenue.keys.map((servicechargeType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(servicechargeType)),
                                          ...monthlyRanges.map((month) {
                                            String MonthRange = month.join(', ');
                                            double totalRevenue = monthlyServiceChargeRevenue[servicechargeType]?[MonthRange] ?? 0.0;
                                            return DataCell(textdetails(
                                                totalRevenue == 0.0 ? "\$XX.XX" : "\$${totalRevenue.toStringAsFixed(2)}")); // แสดงรายได้รายสัปดาห์
                                          }).toList(),
                                        ],
                                      );
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Service Charges')),
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = month.join(', ');
                                          double totalRevenueForWeek = monthlyCreditCardRevenue.values.fold(0.0, (sum, creditcardTypeRevenue) {
                                            return sum + (creditcardTypeRevenue[MonthRange] ?? 0.0);
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...monthlyDiscounts.entries.map((entry) {
                                      String discountName = entry.key;
                                      List<Map<String, dynamic>> data = entry.value;

                                      List<DataCell> rowCells = [
                                        DataCell(Text(discountName)),
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = "${month.first} - ${month.last}";
                                          var MonthData = data.firstWhere(
                                            (dataItem) => dataItem['Week'] == MonthRange,
                                            orElse: () => {'Amount': 0.0},
                                          );
                                          return DataCell(textdetails(MonthData['Amount'].toStringAsFixed(2)));
                                        }).toList(),
                                      ];

                                      return DataRow(cells: rowCells);
                                    }).toList(),
                                    DataRow(
                                      cells: [
                                        DataCell(textheader('Total Discounts')),
                                        ...monthlyRanges.map((month) {
                                          double totalAmountForWeek = monthlyDiscounts.values.fold(0.0, (sum, data) {
                                            var MonthRange = "${month.first} - ${month.last}";
                                            var MonthData =
                                                data.firstWhere((dataItem) => dataItem['Week'] == MonthRange, orElse: () => {'Amount': 0.0});
                                            return sum + MonthData['Amount'];
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: [
                                    ...monthlySalesByOrderTypeRevenue.keys.map((salesbyordertypeType) {
                                      return DataRow(
                                        cells: [
                                          DataCell(textdetails(salesbyordertypeType)),
                                          ...monthlyRanges.map((month) {
                                            String MonthRange = month.join(', ');
                                            double totalRevenue = monthlySalesByOrderTypeRevenue[salesbyordertypeType]?[MonthRange] ?? 0.0;
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: monthlyGiftCardRevenue.keys.map((giftcardType) {
                                    return DataRow(
                                      cells: [
                                        DataCell(textdetails(giftcardType)), // ชื่อประเภท Gift Card
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = month.join(', '); // เชื่อมวันในสัปดาห์
                                          double totalRevenue = monthlyGiftCardRevenue[giftcardType]?[MonthRange] ?? 0.0;
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
                                    ...monthlyRanges.map((month) {
                                      return DataColumn(
                                        label: SizedBox(
                                          width: 162,
                                          child: Text(''),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  rows: monthlyCustomerRevenue.keys.map((customerType) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(customerType)),
                                        ...monthlyRanges.map((month) {
                                          String MonthRange = month.join(', ');
                                          double totalRevenue = monthlyCustomerRevenue[customerType]?[MonthRange] ?? 0.0;
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
