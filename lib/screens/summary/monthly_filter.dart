// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:develop_resturant/model_summary_sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_sale_bloc.dart';
import '../../bloc/summary_sale_state.dart';

final logger = Logger();

class MonthlyFilterPage extends StatefulWidget {
  const MonthlyFilterPage({Key? key, required this.onTapDetail}) : super(key: key);
  final VoidCallback onTapDetail; // Callback สำหรับการเปลี่ยนหน้า

  @override
  _MonthlyFilterPageState createState() => _MonthlyFilterPageState();
}

class _MonthlyFilterPageState extends State<MonthlyFilterPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController(); // ประกาศ ScrollController
  int _selectedTabIndex = 0;

// กำหนดตำแหน่งที่ต้องการเลื่อน
  final List<double> _scrollOffsets = [0.0, 425.0, 680.0, 2550.0, 3485.0, 3825.0, 4080.0];
  final List<Color> _indicatorColors = [
    '#6C4E6F'.toColor(),
    '#BCB02C'.toColor(),
    '#00689D'.toColor(),
    '#41A036'.toColor(),
    '#E3262F'.toColor(),
    '#4E5D6B'.toColor(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // ซิงค์การเปลี่ยน TabBar และการเลื่อน
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        double targetOffset = _scrollOffsets[_tabController.index]; // เลื่อนไปที่ตำแหน่งจาก List
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  DateTime customDate = DateTime(2023, 8);

  String formatDate(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
        if (state is SalesLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SalesErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is SalesLoadedState) {
          List<SalesData> salesData = state.salesData;

          List<List<String>> months = [];
          List<String> currentMonth = [];
          int? currentMonthNumber;

          for (var sale in salesData) {
            DateTime date = DateTime.parse(sale.date);

            if (currentMonth.isEmpty || currentMonthNumber != date.month) {
              if (currentMonth.isNotEmpty) {
                months.add(List.from(currentMonth));
                currentMonth.clear();
              }
              currentMonthNumber = date.month;
            }

            currentMonth.add(sale.date);
          }

          if (currentMonth.isNotEmpty) {
            months.add(List.from(currentMonth));
          }
          String displayDate = formatDate(customDate);

          logger.w(months);
          return Container(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),
            color: '#EEEEEE'.toColor(),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 0),
                  decoration: BoxDecoration(
                    color: '#FFFFFF'.toColor(),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: _indicatorColors[_selectedTabIndex],
                    unselectedLabelColor: '#959595'.toColor(),
                    indicatorColor: _indicatorColors[_selectedTabIndex],
                    indicatorWeight: 4.0,
                    indicatorPadding: EdgeInsets.only(right: 30),
                    tabs: [
                      Tab(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 40,
                              child: Text('Sales', style: TextStyle(fontSize: 14)),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 0.5,
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 0.0, bottom: 0, right: 10),
                              width: 140,
                              child: Text('Sales By Order Type    ', style: TextStyle(fontSize: 14)),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 0.5,
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 0.0, bottom: 0, right: 20),
                              width: 85,
                              child: Text('Payments     ', style: TextStyle(fontSize: 14)),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 0.5,
                              width: 0,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 155,
                              child: Text('Service Charge & Fee', style: TextStyle(fontSize: 14)),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 0.5,
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 0.0, bottom: 0, right: 20),
                              width: 115,
                              child: Text('Gift Certificate    ', style: TextStyle(fontSize: 14)),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 0.5,
                              width: 0,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.only(left: 0.0, bottom: 0, right: 0),
                          width: 60,
                          child: Text('Other', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 400, // กำหนดความสูง 50 พิกเซล
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 16,
                    ),
                    decoration: BoxDecoration(
                      color: '#FFFFFF'.toColor(),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 0.0, top: 0), // เพิ่มระยะห่างด้านขวา
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: '#868E96'.toColor(),
                                  width: 100,
                                  height: 2,
                                ),
                                SizedBox(height: 55),

                                Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    color: '#000000DE'.toColor(),
                                  ),
                                ),
                                SizedBox(height: 47),
                                Container(
                                  color: '#868E96'.toColor(),
                                  width: 100,
                                  height: 2,
                                ),
                                // SizedBox(height: 50.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: months.map((week) {
                                    return Column(
                                      children: [
                                        // แสดงวันที่
                                        Text(
                                          "$displayDate",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w300,
                                            color: '#000000DE'.toColor(),
                                          ),
                                        ),
                                        SizedBox(height: 18),
                                        Container(
                                          color: '#E3E5E5'.toColor(),
                                          width: 100,
                                          height: 1,
                                        ),
                                        // SizedBox(height: 4),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    color: '#000000DE'.toColor(),
                                  ),
                                ),
                                const SizedBox(height: 6.0),

                                Container(
                                  color: '#868E96'.toColor(),
                                  width: 100,
                                  height: 2,
                                ),
                              ],
                            )),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildSalesTable(),
                                _buildSalesByOrderTypeTable(),
                                _buildPaymentsTable(),
                                _buildServiceChargeandFeeTable(),
                                _buildGiftCertificateTable(),
                                _buildOtherTable(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(child: Text('No Data'));
      }),
    );
  }

  // ตารางสำหรับแสดงข้อมูล Sales
  Widget _buildSalesTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        // logger.e(salesData);

        List<List<String>> months = [];
        List<String> currentMonth = [];
        Map<String, Map<String, double>> monthlySales = {};

        int? currentMonthNumber;

        for (var sale in salesData) {
          DateTime date = DateTime.parse(sale.date);

          if (currentMonth.isEmpty || currentMonthNumber != date.month) {
            if (currentMonth.isNotEmpty) {
              months.add(List.from(currentMonth));
              currentMonth.clear();
            }
            currentMonthNumber = date.month;
          }

          currentMonth.add(sale.date);
        }

        if (currentMonth.isNotEmpty) {
          months.add(List.from(currentMonth));
        }

        for (var month in months) {
          String monthRange = "${month.first} - ${month.last}";

          if (!monthlySales.containsKey(monthRange)) {
            monthlySales[monthRange] = {
              'food': 0,
              'liquor': 0,
              'netSales': 0,
              'taxes': 0,
              'totalSales': 0,
            };
          }

          for (var sale in salesData) {
            if (month.contains(sale.date)) {
              monthlySales[monthRange]!['food'] = (monthlySales[monthRange]!['food'] ?? 0) + sale.data.sales.food;
              monthlySales[monthRange]!['liquor'] = (monthlySales[monthRange]!['liquor'] ?? 0) + sale.data.sales.liquor;
              monthlySales[monthRange]!['netSales'] = (monthlySales[monthRange]!['netSales'] ?? 0) + sale.data.sales.netSales;
              monthlySales[monthRange]!['taxes'] = (monthlySales[monthRange]!['taxes'] ?? 0) + sale.data.sales.taxes;
              monthlySales[monthRange]!['totalSales'] = (monthlySales[monthRange]!['totalSales'] ?? 0) +
                  sale.data.sales.food +
                  sale.data.sales.liquor +
                  sale.data.sales.netSales +
                  sale.data.sales.taxes;
            }
          }
        }
        double cellHeight = MediaQuery.of(context).size.height * 0.09;
        TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold);

        Widget buildCell(String text, {TextStyle? style}) => Container(
              height: cellHeight,
              alignment: Alignment.center,
              child: Text(text, style: style),
            );
        Widget buildDataCell(String text) {
          return Container(
            alignment: Alignment.center,
            height: 40,
            child: Text(text),
          );
        }

        return SingleChildScrollView(
          controller: _scrollController1,
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(children: [
                  Row(
                    children: [
                      Container(
                        width: 425,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: '#E9E6EA'.toColor(),
                          border: Border.all(
                            color: '#868E96'.toColor(),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Sales',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Table(border: TableBorder.all(color: '#868E96'.toColor(), width: 1), columnWidths: const {
                    0: FixedColumnWidth(85.0),
                    1: FixedColumnWidth(85.0),
                    2: FixedColumnWidth(85.0),
                    3: FixedColumnWidth(85.0),
                    4: FixedColumnWidth(85.0),
                  }, children: [
                    TableRow(
                      decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                      children: ['Food', 'Liquor', 'Net Sales', 'Taxes', 'Total Sales'].map((title) => buildCell(title, style: headerStyle)).toList(),
                    ),
                    ...monthlySales.entries.map((entry) {
                      Map<String, double> totals = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                        children: [
                          // buildDataCell(week),
                          buildDataCell(totals['food']!.toStringAsFixed(2)),
                          buildDataCell(totals['liquor']!.toStringAsFixed(2)),
                          buildDataCell(totals['netSales']!.toStringAsFixed(2)),
                          buildDataCell(totals['taxes']!.toStringAsFixed(2)),
                          buildDataCell(totals['totalSales']!.toStringAsFixed(2)),
                        ],
                      );
                    }).toList(),
                    TableRow(
                      decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                      children: [
                        buildDataCell(monthlySales.values.fold(0.0, (sum, entry) => sum + entry['food']!).toStringAsFixed(2)),
                        buildDataCell(monthlySales.values.fold(0.0, (sum, entry) => sum + entry['liquor']!).toStringAsFixed(2)),
                        buildDataCell(monthlySales.values.fold(0.0, (sum, entry) => sum + entry['netSales']!).toStringAsFixed(2)),
                        buildDataCell(monthlySales.values.fold(0.0, (sum, entry) => sum + entry['taxes']!).toStringAsFixed(2)),
                        buildDataCell(monthlySales.values.fold(0.0, (sum, entry) => sum + entry['totalSales']!).toStringAsFixed(2)),
                      ],
                    )
                  ])
                ])),
          ]),
        );
      }
      return Container();
    });
  }

  Widget _buildSalesByOrderTypeTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        List<List<String>> months = [];
        List<String> currentMonth = [];
        Map<String, Map<String, double>> monthlySalesByOrderType = {};

        int? currentMonthNumber;

        for (var sale in salesData) {
          DateTime date = DateTime.parse(sale.date);

          if (currentMonth.isEmpty || currentMonthNumber != date.month) {
            if (currentMonth.isNotEmpty) {
              months.add(List.from(currentMonth));
              currentMonth.clear();
            }
            currentMonthNumber = date.month;
          }

          currentMonth.add(sale.date);
        }

        if (currentMonth.isNotEmpty) {
          months.add(List.from(currentMonth));
        }

        for (var month in months) {
          String monthRange = "${month.first} - ${month.last}";

          if (!monthlySalesByOrderType.containsKey(monthRange)) {
            monthlySalesByOrderType[monthRange] = {
              'dineIn': 0,
              'togo': 0,
              'delivery': 0,
            };
          }

          for (var data in salesData) {
            if (month.contains(data.date)) {
              monthlySalesByOrderType[monthRange]!['dineIn'] =
                  (monthlySalesByOrderType[monthRange]!['dineIn'] ?? 0) + data.data.salesByOrderType.dineIn;
              monthlySalesByOrderType[monthRange]!['togo'] = (monthlySalesByOrderType[monthRange]!['togo'] ?? 0) + data.data.salesByOrderType.togo;
              monthlySalesByOrderType[monthRange]!['delivery'] =
                  (monthlySalesByOrderType[monthRange]!['delivery'] ?? 0) + data.data.salesByOrderType.delivery;
              data.data.salesByOrderType.dineIn + data.data.salesByOrderType.togo + data.data.salesByOrderType.delivery;
            }
          }
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(children: [
                  Row(
                    children: [
                      Container(
                        width: 255,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: '#F8F7EA'.toColor(),
                          border: Border.all(
                            color: '#868E96'.toColor(),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Sales By Order Type',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Table(border: TableBorder.all(color: Colors.grey, width: 1), columnWidths: const {
                    0: FixedColumnWidth(85.0),
                    1: FixedColumnWidth(85.0),
                    2: FixedColumnWidth(85.0),
                  }, children: [
                    TableRow(
                      decoration: BoxDecoration(color: '#F8F7EA'.toColor()),
                      children: ['Dine in', 'Togo', 'Delivery'].map((title) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 25, bottom: 25),
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                    ...monthlySalesByOrderType.entries.map((entry) {
                      Map<String, double> totals = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(color: '#F8F7EA'.toColor()),
                        children: [
                          // buildDataCell(week),
                          buildDataCell(totals['dineIn']!.toStringAsFixed(2)),
                          buildDataCell(totals['togo']!.toStringAsFixed(2)),
                          buildDataCell(totals['delivery']!.toStringAsFixed(2)),
                        ],
                      );
                    }).toList(),
                    TableRow(
                      decoration: BoxDecoration(color: '#F8F7EA'.toColor()),
                      children: [
                        buildDataCell(monthlySalesByOrderType.values.fold(0.0, (sum, entry) => sum + entry['dineIn']!).toStringAsFixed(2)),
                        buildDataCell(monthlySalesByOrderType.values.fold(0.0, (sum, entry) => sum + entry['togo']!).toStringAsFixed(2)),
                        buildDataCell(monthlySalesByOrderType.values.fold(0.0, (sum, entry) => sum + entry['delivery']!).toStringAsFixed(2)),
                      ],
                    )
                  ])
                ])),
          ]),
        );
      }
      return Container();
    });
  }

  Widget _buildPaymentsTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        List<List<String>> months = [];
        List<String> currentMonth = [];
        Map<String, Map<String, double>> monthlyPayments = {};

        int? currentMonthNumber;

        for (var sale in salesData) {
          DateTime date = DateTime.parse(sale.date);

          if (currentMonth.isEmpty || currentMonthNumber != date.month) {
            if (currentMonth.isNotEmpty) {
              months.add(List.from(currentMonth));
              currentMonth.clear();
            }
            currentMonthNumber = date.month;
          }

          currentMonth.add(sale.date);
        }

        if (currentMonth.isNotEmpty) {
          months.add(List.from(currentMonth));
        }

        for (var month in months) {
          String monthRange = "${month.first} - ${month.last}";

          if (!monthlyPayments.containsKey(monthRange)) {
            monthlyPayments[monthRange] = {
              'cash': 0,
              'check': 0,
              'coupon': 0,
              '3RDPP': 0,
              '3RDPPTips': 0,
              '3rdpptotal': 0,
              'EmvCCsales': 0,
              'EmvCCTips': 0,
              'EmvCCtotal': 0,
              'CloverFlexCCsales': 0,
              'CloverFlexCCTips': 0,
              'CloverFlexCCtotal': 0,
              'SDPrepaidPP': 0,
              'SDPrepaidPPTips': 0,
              'SDGiftCardPPGC': 0,
              'SDGiftCardPPGCTips': 0,
              'SDGiftCardtotal': 0,
              'SCPrepaidPPTips': 0,
              'SCPrepaidPP': 0,
              'SCGiftCardPPGC': 0,
              'SCGiftCardPPGCTips': 0,
              'SCGiftCardTotal': 0,
              // 'TotalsAll' : 0,
            };
          }

          for (var data in salesData) {
            if (month.contains(data.date)) {
              monthlyPayments[monthRange]!['cash'] = (monthlyPayments[monthRange]!['cash'] ?? 0) + data.data.payments.cash;
              monthlyPayments[monthRange]!['check'] = (monthlyPayments[monthRange]!['check'] ?? 0) + data.data.payments.check;
              monthlyPayments[monthRange]!['coupon'] = (monthlyPayments[monthRange]!['coupon'] ?? 0) + data.data.payments.coupon;
              monthlyPayments[monthRange]!['pp'] = (monthlyPayments[monthRange]!['pp'] ?? 0) + data.data.payments.pp;
              monthlyPayments[monthRange]!['3RDPP'] = (monthlyPayments[monthRange]!['3RDPP'] ?? 0) + data.data.payments.pPTips;
              monthlyPayments[monthRange]!['3RDPPTips'] = (monthlyPayments[monthRange]!['3RDPPTips'] ?? 0) + data.data.payments.pPTips;
              monthlyPayments[monthRange]!['3rdpptotal'] =
                  (monthlyPayments[monthRange]!['3rdpptotal'] ?? 0) + data.data.payments.pp + data.data.payments.pPTips;
              monthlyPayments[monthRange]!['EmvCCsales'] = (monthlyPayments[monthRange]!['EmvCCsales'] ?? 0) + data.data.payments.emvccSales;
              monthlyPayments[monthRange]!['EmvCCTips'] = (monthlyPayments[monthRange]!['EmvCCTips'] ?? 0) + data.data.payments.emvcCTips;
              monthlyPayments[monthRange]!['EmvCCtotal'] =
                  (monthlyPayments[monthRange]!['EmvCCtotal'] ?? 0) + data.data.payments.emvccSales + data.data.payments.emvcCTips;
              monthlyPayments[monthRange]!['CloverFlexCCsales'] =
                  (monthlyPayments[monthRange]!['CloverFlexCCsales'] ?? 0) + data.data.payments.cloverFlexCCSales;
              monthlyPayments[monthRange]!['CloverFlexCCTips'] =
                  (monthlyPayments[monthRange]!['CloverFlexCCTips'] ?? 0) + data.data.payments.cloverFlexCCTips;
              monthlyPayments[monthRange]!['CloverFlexCCtotal'] = (monthlyPayments[monthRange]!['CloverFlexCCtotal'] ?? 0) +
                  data.data.payments.cloverFlexCCSales +
                  data.data.payments.cloverFlexCCTips;
              monthlyPayments[monthRange]!['SDPrepaidPP'] = (monthlyPayments[monthRange]!['SDPrepaidPP'] ?? 0) + data.data.payments.smileDiningPP;
              monthlyPayments[monthRange]!['SDPrepaidPPTips'] = (monthlyPayments[monthRange]!['togo'] ?? 0) + data.data.payments.smileDiningPPTips;
              monthlyPayments[monthRange]!['SDGiftCardPPGC'] =
                  (monthlyPayments[monthRange]!['SDGiftCardPPGC'] ?? 0) + data.data.payments.smileDiningPPGC;
              monthlyPayments[monthRange]!['SDGiftCardPPGCTips'] =
                  (monthlyPayments[monthRange]!['SDGiftCardPPGCTips'] ?? 0) + data.data.payments.smileContactlessPPGCTips;
              monthlyPayments[monthRange]!['SDGiftCardtotal'] = (monthlyPayments[monthRange]!['SDGiftCardtotal'] ?? 0) +
                  data.data.payments.smileDiningPP +
                  data.data.payments.smileDiningPPTips +
                  data.data.payments.smileDiningPPGC;
              monthlyPayments[monthRange]!['SCPrepaidPP'] =
                  (monthlyPayments[monthRange]!['SCPrepaidPP'] ?? 0) + data.data.payments.smileContactlessPP;
              monthlyPayments[monthRange]!['SCPrepaidPPTips'] =
                  (monthlyPayments[monthRange]!['SCPrepaidPPTips'] ?? 0) + data.data.payments.smileContactlessPPTips;
              monthlyPayments[monthRange]!['SCGiftCardPPGC'] =
                  (monthlyPayments[monthRange]!['SCGiftCardPPGC'] ?? 0) + data.data.payments.smileContactlessPPGC;
              monthlyPayments[monthRange]!['SCGiftCardPPGCTips'] =
                  (monthlyPayments[monthRange]!['SCGiftCardPPGCTips'] ?? 0) + data.data.payments.smileContactlessPPGCTips;
              monthlyPayments[monthRange]!['SCGiftCardTotal'] = (monthlyPayments[monthRange]!['SCGiftCardTotal'] ?? 0) +
                  data.data.payments.smileContactlessPP +
                  data.data.payments.smileContactlessPPTips +
                  data.data.payments.smileContactlessPPGC +
                  data.data.payments.smileContactlessPPGCTips;
            }
          }
        }

        double cellHeight = MediaQuery.of(context).size.height * 0.09;
        TextStyle headerStyle = TextStyle(fontWeight: FontWeight.w400, color: '#3C3C3C'.toColor());
        Widget buildCell(String text, {TextStyle? style}) => Container(
              height: cellHeight,
              alignment: Alignment.center,
              child: Text(text, style: style),
            );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 1870,
                          height: MediaQuery.of(context).size.height * 0.033,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: '#E5F0F5'.toColor(),
                            border: Border.all(
                              color: '#868E96'.toColor(),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            'Payments',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(color: '#868E96'.toColor(), width: 1),
                      columnWidths: const {
                        0: FixedColumnWidth(85.0), // Cash
                        1: FixedColumnWidth(85.0), // Check
                        2: FixedColumnWidth(85.0), // Coupon
                        3: FixedColumnWidth(255.0), // 3rd Party
                        4: FixedColumnWidth(255.0), // EMV
                        5: FixedColumnWidth(255.0), // Cover Flex
                        6: FixedColumnWidth(425.0), // Smile Dining
                        7: FixedColumnWidth(425.0), // SmileContact
                      },
                      children: [
                        // Header Row 1
                        TableRow(
                          decoration: BoxDecoration(color: '#E5F0F5'.toColor()),
                          children: [
                            buildCell('Cash', style: headerStyle),
                            buildCell('Check', style: headerStyle),
                            buildCell('Coupon', style: headerStyle),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: 20, child: Text('3rd Party', textAlign: TextAlign.center)),
                                  Divider(
                                    color: '#868E96'.toColor(),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('PP', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                      ),
                                      Text('PP Tips', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                        // margin: EdgeInsets.zero,
                                        // padding: EdgeInsets.zero,
                                      ),
                                      Text('PP \nTotal', textAlign: TextAlign.center),
                                      Divider(color: '#868E96'.toColor(), height: 1), // เส้นแบ่งระหว่างหัวข้อและตัวเลข
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    child: Text('Credit (EMV)', textAlign: TextAlign.center),
                                  ),
                                  Divider(
                                    color: '#868E96'.toColor(),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('CC \nSales', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Text('CC Tips', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Text('CC \nTotal', textAlign: TextAlign.center),
                                      Divider(color: '#868E96'.toColor(), height: 1), // เส้นแบ่งระหว่างหัวข้อและตัวเลข
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    child: Text('Credit (Clover Flex)', textAlign: TextAlign.center),
                                  ),
                                  Divider(
                                    color: '#868E96'.toColor(),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('CC \nSales', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Text('CC Tips', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Text('CC \nTotal', textAlign: TextAlign.center),
                                      Divider(color: '#868E96'.toColor(), height: 1), // เส้นแบ่งระหว่างหัวข้อและตัวเลข
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    child: Text(
                                      'Smile Dining',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: 425,
                                    height: 1,
                                    color: '#868E96'.toColor(),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text('Prepaid', textAlign: TextAlign.center),
                                          Container(
                                            width: 170,
                                            height: 1,
                                            color: '#868E96'.toColor(),
                                          ),
                                          Row(
                                            children: [
                                              Text('PP', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 45,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 20), // ระยะห่างจากข้อความ
                                              ),
                                              Text('PP Tips', textAlign: TextAlign.center),
                                              Divider(color: '#868E96'.toColor(), height: 1), // เส้นแบ่งระหว่างหัวข้อและตัวเลข
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Gift Card',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w500), // ตัวหนา (ถ้าต้องการ)
                                          ),
                                          Container(
                                            width: 170,
                                            height: 1,
                                            color: '#868E96'.toColor(),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('PPGC', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 45,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 16), // ระยะห่างจากข้อความ
                                              ),
                                              Text('PPGC Tips', textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 60,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Column(
                                        children: [
                                          Text('Total', textAlign: TextAlign.center),
                                          SizedBox(height: 4.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    child: Text(
                                      'Smile Contactless (On Table)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: 425,
                                    height: 1,
                                    color: '#868E96'.toColor(),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Prepaid',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              Container(
                                                width: 170,
                                                height: 1,
                                                color: '#868E96'.toColor(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('PP', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 45,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 28),
                                              ),
                                              Text('PP Tips', textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 60,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Gift Card',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              Container(
                                                width: 170,
                                                height: 1,
                                                color: '#868E96'.toColor(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('PPGC', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 45,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 20),
                                              ),
                                              Text('PPGC Tips', textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 65,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Total',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        ...monthlyPayments.entries.map((entry) {
                          Map<String, double> totals = entry.value;
                          return TableRow(
                            decoration: BoxDecoration(color: '#E5F0F5'.toColor()),
                            children: [
                              buildDataCell(totals['cash']!.toStringAsFixed(2)),
                              buildDataCell(totals['check']!.toStringAsFixed(2)),
                              buildDataCell(totals['coupon']!.toStringAsFixed(2)),
                              // 3rd Party
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['3RDPP']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['3RDPPTips']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['3rdpptotal']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: '#496EE2'.toColor(),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Credit (EMV)
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['EmvCCsales']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['EmvCCTips']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['EmvCCtotal']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Credit (Clover Flex)
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['CloverFlexCCsales']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['CloverFlexCCTips']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (totals['CloverFlexCCtotal']!.toStringAsFixed(2)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Smile Dining
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildDataCell(totals['SDPrepaidPP']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SDPrepaidPPTips']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SDGiftCardPPGC']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SDGiftCardPPGCTips']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SDGiftCardtotal']!.toStringAsFixed(2)),
                                  ],
                                ),
                              ),
                              // Smile Contactless
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildDataCell(totals['SCPrepaidPP']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SCPrepaidPPTips']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SCGiftCardPPGC']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SCGiftCardPPGCTips']!.toStringAsFixed(2)),
                                    buildDataCell(totals['SCGiftCardTotal']!.toStringAsFixed(2)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        TableRow(
                          decoration: BoxDecoration(color: '#E5F0F5'.toColor()),
                          children: [
                            buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['cash']!).toStringAsFixed(2)),
                            buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['check']!).toStringAsFixed(2)),
                            buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['coupon']!).toStringAsFixed(2)),
                            // 3rd Party
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['3RDPP']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['3RDPPTips']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['3rdpptotal']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: '#496EE2'.toColor(),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Credit (EMV)
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['EmvCCsales']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['EmvCCTips']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['EmvCCtotal']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Credit (Clover Flex)
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['CloverFlexCCsales']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['CloverFlexCCTips']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['CloverFlexCCtotal']!).toStringAsFixed(2)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Smile Dining
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SDPrepaidPP']!).toStringAsFixed(2)),
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SDPrepaidPPTips']!).toStringAsFixed(2)),
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SDGiftCardPPGC']!).toStringAsFixed(2)),
                                  buildDataCell(
                                      monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SDGiftCardPPGCTips']!).toStringAsFixed(2)),
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SDGiftCardtotal']!).toStringAsFixed(2)),
                                ],
                              ),
                            ),
                            // Smile Contactless
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SCPrepaidPP']!).toStringAsFixed(2)),
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SCPrepaidPPTips']!).toStringAsFixed(2)),
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SCGiftCardPPGC']!).toStringAsFixed(2)),
                                  buildDataCell(
                                      monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SCGiftCardPPGCTips']!).toStringAsFixed(2)),
                                  buildDataCell(monthlyPayments.values.fold(0.0, (sum, entry) => sum + entry['SCGiftCardTotal']!).toStringAsFixed(2)),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }

  Widget _buildServiceChargeandFeeTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        // คำนวณผลรวมของแต่ละประเภทจากข้อมูลทั้งหมด
        List<List<String>> months = [];
        List<String> currentMonth = [];
        Map<String, Map<String, double>> monthlyServiceChargeandFee = {};

        int? currentMonthNumber;

        for (var sale in salesData) {
          DateTime date = DateTime.parse(sale.date);

          if (currentMonth.isEmpty || currentMonthNumber != date.month) {
            if (currentMonth.isNotEmpty) {
              months.add(List.from(currentMonth));
              currentMonth.clear();
            }
            currentMonthNumber = date.month;
          }

          currentMonth.add(sale.date);
        }

        if (currentMonth.isNotEmpty) {
          months.add(List.from(currentMonth));
        }

        for (var month in months) {
          String monthRange = "${month.first} - ${month.last}";

          if (!monthlyServiceChargeandFee.containsKey(monthRange)) {
            monthlyServiceChargeandFee[monthRange] = {
              'Gratuity': 0,
              'OnlineCustomCharge': 0,
              'ContactlessCustomCharge': 0,
              'SmilePOSAutoCharge': 0,
              'DeliveryRestaurant': 0,
              'DeliveryDoorDashDrive': 0,
              'Others': 0,
              'Utensils': 0,
              'PaymentFee': 0,
              'ServiceFeeOnCreditCard': 0,
              'ServiceFeeAdjustment': 0,
            };
          }

          for (var data in salesData) {
            if (month.contains(data.date)) {
              monthlyServiceChargeandFee[monthRange]!['Gratuity'] =
                  (monthlyServiceChargeandFee[monthRange]!['Gratuity'] ?? 0) + data.data.serviceChargeAndFee.gratuity;
              monthlyServiceChargeandFee[monthRange]!['OnlineCustomCharge'] =
                  (monthlyServiceChargeandFee[monthRange]!['OnlineCustomCharge'] ?? 0) + data.data.serviceChargeAndFee.onlineCustomCharge;
              monthlyServiceChargeandFee[monthRange]!['ContactlessCustomCharge'] =
                  (monthlyServiceChargeandFee[monthRange]!['ContactlessCustomCharge'] ?? 0) + data.data.serviceChargeAndFee.contactlessCustomCharge;
              monthlyServiceChargeandFee[monthRange]!['SmilePOSAutoCharge'] =
                  (monthlyServiceChargeandFee[monthRange]!['SmilePOSAutoCharge'] ?? 0) + data.data.serviceChargeAndFee.smilePOSAutoCharge;
              monthlyServiceChargeandFee[monthRange]!['DeliveryRestaurant'] =
                  (monthlyServiceChargeandFee[monthRange]!['DeliveryRestaurant'] ?? 0) + data.data.serviceChargeAndFee.deliveryRestaurant;
              monthlyServiceChargeandFee[monthRange]!['DeliveryDoorDashDrive'] =
                  (monthlyServiceChargeandFee[monthRange]!['DeliveryDoorDashDrive'] ?? 0) + data.data.serviceChargeAndFee.deliveryDoorDashDrive;
              monthlyServiceChargeandFee[monthRange]!['Others'] =
                  (monthlyServiceChargeandFee[monthRange]!['Others'] ?? 0) + data.data.serviceChargeAndFee.others;
              monthlyServiceChargeandFee[monthRange]!['Utensils'] =
                  (monthlyServiceChargeandFee[monthRange]!['Utensils'] ?? 0) + data.data.serviceChargeAndFee.utensils;
              monthlyServiceChargeandFee[monthRange]!['PaymentFee'] =
                  (monthlyServiceChargeandFee[monthRange]!['PaymentFee'] ?? 0) + data.data.serviceChargeAndFee.paymentFee;
              monthlyServiceChargeandFee[monthRange]!['ServiceFeeOnCreditCard'] =
                  (monthlyServiceChargeandFee[monthRange]!['ServiceFeeOnCreditCard'] ?? 0) + data.data.serviceChargeAndFee.serviceFeeOnCreditCard;
              monthlyServiceChargeandFee[monthRange]!['ServiceFeeAdjustment'] =
                  (monthlyServiceChargeandFee[monthRange]!['ServiceFeeAdjustment'] ?? 0) + data.data.serviceChargeAndFee.serviceFeeAdjustment;
            }
          }
        }

        double cellHeight = MediaQuery.of(context).size.height * 0.09;
        TextStyle headerStyle = TextStyle(fontWeight: FontWeight.w400, color: '#3C3C3C'.toColor());
        Widget buildCell(String text, {TextStyle? style}) => Container(
              height: cellHeight,
              alignment: Alignment.center,
              child: Text(text, style: style),
            );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 935,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: '#ECF5EB'.toColor(),
                            border: Border.all(
                              color: '#868E96'.toColor(),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            'Service Charge & Fee',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(color: '#868E96'.toColor(), width: 1),
                      columnWidths: const {
                        0: FixedColumnWidth(85.0),
                        1: FixedColumnWidth(85.0),
                        2: FixedColumnWidth(85.0),
                        3: FixedColumnWidth(85.0),
                        4: FixedColumnWidth(85.0),
                        5: FixedColumnWidth(85.0),
                        6: FixedColumnWidth(85.0),
                        7: FixedColumnWidth(85.0),
                        8: FixedColumnWidth(85.0),
                        9: FixedColumnWidth(85.0),
                        10: FixedColumnWidth(85.0),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: '#ECF5EB'.toColor()),
                          children: [
                            'Gratuity',
                            'Online\nCustom\nCharge',
                            'Contactles\nCustom\nCharge',
                            'Smile\nPOS\nAuto\nCharge',
                            'Delivery',
                            'Delivery\nDoor Dash\nDrive',
                            'Others',
                            'Utensils',
                            'PaymentFee',
                            'Service\nFee On\nCredit Card',
                            'Service\nFee\nAdjustment',
                          ].map((title) => buildCell(title, style: headerStyle)).toList(),
                        ),
                        ...monthlyServiceChargeandFee.entries.map((entry) {
                          Map<String, double> totals = entry.value;
                          return TableRow(
                            decoration: BoxDecoration(color: '#ECF5EB'.toColor()),
                            children: [
                              buildDataCell(totals['Gratuity']!.toStringAsFixed(2)),
                              buildDataCell(totals['OnlineCustomCharge']!.toStringAsFixed(2)),
                              buildDataCell(totals['ContactlessCustomCharge']!.toStringAsFixed(2)),
                              buildDataCell(totals['SmilePOSAutoCharge']!.toStringAsFixed(2)),
                              buildDataCell(totals['DeliveryRestaurant']!.toStringAsFixed(2)),
                              buildDataCell(totals['DeliveryDoorDashDrive']!.toStringAsFixed(2)),
                              buildDataCell(totals['Others']!.toStringAsFixed(2)),
                              buildDataCell(totals['Utensils']!.toStringAsFixed(2)),
                              buildDataCell(totals['PaymentFee']!.toStringAsFixed(2)),
                              buildDataCell(totals['ServiceFeeOnCreditCard']!.toStringAsFixed(2)),
                              buildDataCell(totals['ServiceFeeAdjustment']!.toStringAsFixed(2)),
                            ],
                          );
                        }).toList(),
                        TableRow(
                          decoration: BoxDecoration(color: '#ECF5EB'.toColor()),
                          children: [
                            buildDataCell(monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['Gratuity']!).toStringAsFixed(2)),
                            buildDataCell(
                                monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['OnlineCustomCharge']!).toStringAsFixed(2)),
                            buildDataCell(monthlyServiceChargeandFee.values
                                .fold(0.0, (sum, entry) => sum + entry['ContactlessCustomCharge']!)
                                .toStringAsFixed(2)),
                            buildDataCell(
                                monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['SmilePOSAutoCharge']!).toStringAsFixed(2)),
                            buildDataCell(
                                monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['DeliveryRestaurant']!).toStringAsFixed(2)),
                            buildDataCell(monthlyServiceChargeandFee.values
                                .fold(0.0, (sum, entry) => sum + entry['DeliveryDoorDashDrive']!)
                                .toStringAsFixed(2)),
                            buildDataCell(monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['Others']!).toStringAsFixed(2)),
                            buildDataCell(monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['Utensils']!).toStringAsFixed(2)),
                            buildDataCell(monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['PaymentFee']!).toStringAsFixed(2)),
                            buildDataCell(monthlyServiceChargeandFee.values
                                .fold(0.0, (sum, entry) => sum + entry['ServiceFeeOnCreditCard']!)
                                .toStringAsFixed(2)),
                            buildDataCell(
                                monthlyServiceChargeandFee.values.fold(0.0, (sum, entry) => sum + entry['ServiceFeeAdjustment']!).toStringAsFixed(2)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }

  Widget _buildGiftCertificateTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        List<List<String>> months = [];
        List<String> currentMonth = [];
        Map<String, Map<String, double>> monthlyGiftCertificate = {};

        int? currentMonthNumber;

        for (var sale in salesData) {
          DateTime date = DateTime.parse(sale.date);

          if (currentMonth.isEmpty || currentMonthNumber != date.month) {
            if (currentMonth.isNotEmpty) {
              months.add(List.from(currentMonth));
              currentMonth.clear();
            }
            currentMonthNumber = date.month;
          }

          currentMonth.add(sale.date);
        }

        if (currentMonth.isNotEmpty) {
          months.add(List.from(currentMonth));
        }

        for (var month in months) {
          String monthRange = "${month.first} - ${month.last}";

          if (!monthlyGiftCertificate.containsKey(monthRange)) {
            monthlyGiftCertificate[monthRange] = {
              'GiftSales': 0,
              'GiftRedeem': 0,
              'EGiftSalesShop': 0,
              'EGiftSalesOnline': 0,
            };
          }

          for (var data in salesData) {
            if (month.contains(data.date)) {
              monthlyGiftCertificate[monthRange]!['GiftSales'] =
                  (monthlyGiftCertificate[monthRange]!['GiftSales'] ?? 0) + data.data.giftCertificate.giftSales;
              monthlyGiftCertificate[monthRange]!['GiftRedeem'] =
                  (monthlyGiftCertificate[monthRange]!['GiftRedeem'] ?? 0) + data.data.giftCertificate.giftRedeem;
              monthlyGiftCertificate[monthRange]!['EGiftSalesShop'] =
                  (monthlyGiftCertificate[monthRange]!['EGiftSalesShop'] ?? 0) + data.data.giftCertificate.eGiftSalesShop;
              monthlyGiftCertificate[monthRange]!['EGiftSalesOnline'] =
                  (monthlyGiftCertificate[monthRange]!['EGiftSalesOnline'] ?? 0) + data.data.giftCertificate.eGiftSalesOnline;
            }
          }
        }
        double cellHeight = MediaQuery.of(context).size.height * 0.09;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 340,
                          height: MediaQuery.of(context).size.height * 0.033,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: '#FCE9EA'.toColor(),
                            border: Border.all(
                              color: '#868E96'.toColor(),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            'Gift Certificate',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.grey, width: 1),
                      columnWidths: {
                        0: FixedColumnWidth(85.0),
                        1: FixedColumnWidth(85.0),
                        2: FixedColumnWidth(170.0),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: '#FCE9EA'.toColor()),
                          children: [
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Container(height: cellHeight, child: Text('Gift Sales', textAlign: TextAlign.center)),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Container(height: cellHeight, child: Text('Gift Redeem', textAlign: TextAlign.center)),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: 30, child: Text('E-Gift Sales', textAlign: TextAlign.center)),
                                  Divider(
                                    color: '#868E96'.toColor(),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('Shop', textAlign: TextAlign.center),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 60,
                                        color: '#868E96'.toColor(),

                                        // margin: EdgeInsets.zero, // ลบช่องว่างรอบเส้น
                                        // padding: EdgeInsets.zero,
                                      ),
                                      Expanded(
                                        child: Text('Online', textAlign: TextAlign.center),
                                      ),

                                      Divider(color: '#868E96'.toColor(), height: 1), // เส้นแบ่งระหว่างหัวข้อและตัวเลข
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ...monthlyGiftCertificate.entries.map((entry) {
                          Map<String, double> totals = entry.value;
                          return TableRow(
                            decoration: BoxDecoration(color: '#FCE9EA'.toColor()),
                            children: [
                              buildDataCell(totals['GiftSales']!.toStringAsFixed(2)),
                              buildDataCell(totals['GiftRedeem']!.toStringAsFixed(2)),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        totals['EGiftSalesShop']!.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      width: 1, // ความกว้างของเส้น
                                      color: '#868E96'.toColor(),
                                    ),
                                    Expanded(
                                      child: Text(
                                        totals['EGiftSalesOnline']!.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        TableRow(
                          decoration: BoxDecoration(color: '#FCE9EA'.toColor()),
                          children: [
                            buildDataCell(monthlyGiftCertificate.values.fold(0.0, (sum, entry) => sum + entry['GiftSales']!).toStringAsFixed(2)),
                            buildDataCell(monthlyGiftCertificate.values.fold(0.0, (sum, entry) => sum + entry['GiftRedeem']!).toStringAsFixed(2)),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: buildDataCell(
                                        monthlyGiftCertificate.values.fold(0.0, (sum, entry) => sum + entry['EGiftSalesShop']!).toStringAsFixed(2)),
                                  ),
                                  Container(
                                    width: 1, // ความกว้างของเส้น
                                    color: '#868E96'.toColor(),
                                  ),
                                  Expanded(
                                    child: buildDataCell(
                                        monthlyGiftCertificate.values.fold(0.0, (sum, entry) => sum + entry['EGiftSalesOnline']!).toStringAsFixed(2)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }

  Widget _buildOtherTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        List<List<String>> months = [];
        List<String> currentMonth = [];
        Map<String, Map<String, double>> monthlyOther = {};

        int? currentMonthNumber;

        for (var sale in salesData) {
          DateTime date = DateTime.parse(sale.date);

          if (currentMonth.isEmpty || currentMonthNumber != date.month) {
            if (currentMonth.isNotEmpty) {
              months.add(List.from(currentMonth));
              currentMonth.clear();
            }
            currentMonthNumber = date.month;
          }

          currentMonth.add(sale.date);
        }

        if (currentMonth.isNotEmpty) {
          months.add(List.from(currentMonth));
        }

        for (var month in months) {
          String monthRange = "${month.first} - ${month.last}";

          if (!monthlyOther.containsKey(monthRange)) {
            monthlyOther[monthRange] = {
              'Discount': 0,
              'CashInCashOut': 0,
              'CashDeposit': 0,
            };
          }

          for (var data in salesData) {
            if (month.contains(data.date)) {
              monthlyOther[monthRange]!['Discount'] = (monthlyOther[monthRange]!['Discount'] ?? 0) + data.data.giftCertificate.giftSales;
              monthlyOther[monthRange]!['CashInCashOut'] = (monthlyOther[monthRange]!['CashInCashOut'] ?? 0) + data.data.giftCertificate.giftRedeem;
              monthlyOther[monthRange]!['CashDeposit'] = (monthlyOther[monthRange]!['CashDeposit'] ?? 0) + data.data.giftCertificate.eGiftSalesShop;
            }
          }
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(color: Colors.grey, width: 1),
                      columnWidths: const {
                        0: FixedColumnWidth(85.0),
                        1: FixedColumnWidth(85.0),
                        2: FixedColumnWidth(85.0),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: '#EDEFF0'.toColor()),
                          children: [
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: SizedBox(child: Text('Discount', textAlign: TextAlign.center)),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.123,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Cash In\nCash Out', textAlign: TextAlign.center),
                                    Text('+Check Change\n +Gift Refund', style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.09,
                                  child: Text('Cash\nDeposit', style: TextStyle(color: '#496EE2'.toColor()), textAlign: TextAlign.center)),
                            ),
                          ],
                        ),
                        ...monthlyOther.entries.map((entry) {
                          Map<String, double> totals = entry.value;
                          return TableRow(
                            decoration: BoxDecoration(color: '#EDEFF0'.toColor()),
                            children: [
                              buildDataCell(totals['Discount']!.toStringAsFixed(2)),
                              buildDataCell(totals['CashInCashOut']!.toStringAsFixed(2)),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                child: Text(totals['CashDeposit']!.toStringAsFixed(2),
                                    style: TextStyle(color: '496EE2'.toColor()), textAlign: TextAlign.center),
                              ),
                            ],
                          );
                        }).toList(),
                        TableRow(
                          decoration: BoxDecoration(color: '#EDEFF0'.toColor()),
                          children: [
                            buildDataCell(monthlyOther.values.fold(0.0, (sum, entry) => sum + entry['Discount']!).toStringAsFixed(2)),
                            buildDataCell(monthlyOther.values.fold(0.0, (sum, entry) => sum + entry['CashInCashOut']!).toStringAsFixed(2)),
                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              child: Center(
                                child: Text(monthlyOther.values.fold(0.0, (sum, entry) => sum + entry['CashDeposit']!).toStringAsFixed(2),
                                    style: TextStyle(color: '496EE2'.toColor()), textAlign: TextAlign.center),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      height: 40.0,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSubHeaderCell(String text) {
    return Container(
      height: 22, // ลดความสูงจากเดิม
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 12), // อาจจะลดขนาดตัวอักษรด้วยถ้าต้องการ
        textAlign: TextAlign.center,
      ),
    );
  }

  // ฟังก์ชันสร้าง TableCell
  Widget buildDataCell(String text) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      child: Text(text),
    );
  }
}
