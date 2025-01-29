// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/model_summary_sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_sale_bloc.dart';
import '../../bloc/summary_sale_state.dart';

final logger = Logger();

class DailySalesPage extends StatefulWidget {
  const DailySalesPage({Key? key, required this.onTapDetail}) : super(key: key);
  final VoidCallback onTapDetail;

  @override
  _DailySalesPageState createState() => _DailySalesPageState();
}

class _DailySalesPageState extends State<DailySalesPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  int _selectedTabIndex = 0;

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

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        double targetOffset = _scrollOffsets[_tabController.index];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              height: 250,
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
                        padding: const EdgeInsets.only(right: 16.0, top: 70),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: '#000000DE'.toColor(),
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            Text(
                              'Current',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w300,
                                color: '#000000DE'.toColor(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: '#000000DE'.toColor(),
                              ),
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
      ),
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

        double totalFood = 0, totalLiquor = 0, totalNetSales = 0, totalTaxes = 0, totalTotalSales = 0;

        for (var data in salesData) {
          totalFood += data.data.sales.food;
          totalLiquor += data.data.sales.liquor;
          totalNetSales += data.data.sales.netSales;
          totalTaxes += data.data.sales.taxes;
          totalTotalSales += data.data.sales.food + data.data.sales.liquor + data.data.sales.netSales + data.data.sales.taxes;
        }

        double cellHeight = MediaQuery.of(context).size.height * 0.09;
        TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold);

        Widget buildCell(String text, {TextStyle? style}) => Container(
              height: cellHeight,
              alignment: Alignment.center,
              child: _buildHeaderCell(text),
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
                  Table(
                    border: TableBorder.all(color: '#868E96'.toColor(), width: 1),
                    columnWidths: const {
                      0: FixedColumnWidth(85.0),
                      1: FixedColumnWidth(85.0),
                      2: FixedColumnWidth(85.0),
                      3: FixedColumnWidth(85.0),
                      4: FixedColumnWidth(85.0),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                        children:
                            ['Food', 'Liquor', 'Net Sales', 'Taxes', 'Total Sales'].map((title) => buildCell(title, style: headerStyle)).toList(),
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                        children: [
                          totalFood,
                          totalLiquor,
                          totalNetSales,
                          totalTaxes,
                          totalTotalSales,
                        ].map((total) => buildDataCell(total.toStringAsFixed(2))).toList(),
                      ),
                      TableRow(
                        decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                        children: [
                          totalFood,
                          totalLiquor,
                          totalNetSales,
                          totalTaxes,
                          totalTotalSales,
                        ].map((total) => buildDataCell(total.toStringAsFixed(2))).toList(),
                      ),
                    ],
                  )
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

        double totalDineIn = 0, totalTogo = 0, totalDelivery = 0;

        for (var data in salesData) {
          totalDineIn += data.data.salesByOrderType.dineIn;
          totalTogo += data.data.salesByOrderType.togo;
          totalDelivery += data.data.salesByOrderType.delivery;
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
                        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 25, bottom: 27),
                        child: _buildHeaderCell(
                          title,
                        ),
                      );
                    }).toList(),
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: '#F8F7EA'.toColor()),
                    children: [
                      totalDineIn,
                      totalTogo,
                      totalDelivery,
                    ].map((total) => buildDataCell(total.toStringAsFixed(2))).toList(),
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: '#F8F7EA'.toColor()),
                    children: [
                      totalDineIn,
                      totalTogo,
                      totalDelivery,
                    ].map((total) => buildDataCell(total.toStringAsFixed(2))).toList(),
                  ),
                ]),
              ]),
            ),
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
        double totalCash = 0,
            totalCheck = 0,
            totalCoupon = 0,
            total3RDPP = 0,
            total3RDPPTips = 0,
            total3rdppTotal = 0,
            totalEmvCCsales = 0,
            totalEmvCCTips = 0,
            totalEmvCCTotal = 0,
            totalCloverFlexCCsales = 0,
            totalCloverFlexCCTips = 0,
            totalCloverFlexCCTotal = 0,
            totalSDPrepaidPP = 0,
            totalSDPrepaidPPTips = 0,
            totalSDGiftCardPPGC = 0,
            totalSDGiftCardPPGCTips = 0,
            totalSDGiftCardTotal = 0,
            totalSCPrepaidPP = 0,
            totalSCPrepaidPPTips = 0,
            totalSCGiftCardPPGC = 0,
            totalSCGiftCardPPGCTips = 0,
            totalSCGiftCardTotal = 0;

        for (var data in salesData) {
          totalCash += data.data.payments.cash;
          totalCheck += data.data.payments.check;
          totalCoupon += data.data.payments.coupon;
          total3RDPP += data.data.payments.pp;
          total3RDPPTips += data.data.payments.pPTips;
          total3rdppTotal += data.data.payments.pp + data.data.payments.pPTips;
          totalEmvCCsales += data.data.payments.emvccSales;
          totalEmvCCTips += data.data.payments.emvcCTips;
          totalEmvCCTotal += data.data.payments.emvccSales + data.data.payments.emvcCTips;
          totalCloverFlexCCsales += data.data.payments.cloverFlexCCSales;
          totalCloverFlexCCTips += data.data.payments.cloverFlexCCTips;
          totalCloverFlexCCTotal += data.data.payments.cloverFlexCCSales + data.data.payments.cloverFlexCCTips;
          totalSDPrepaidPP += data.data.payments.smileDiningPP;
          totalSDPrepaidPPTips += data.data.payments.smileDiningPPTips;
          totalSDGiftCardPPGC += data.data.payments.smileDiningPPGC;
          totalSDGiftCardPPGCTips += data.data.payments.smileContactlessPPGCTips;
          totalSDGiftCardTotal += data.data.payments.smileDiningPP + data.data.payments.smileDiningPPTips + data.data.payments.smileDiningPPGC;
          totalSCPrepaidPP += data.data.payments.smileContactlessPP;
          totalSCPrepaidPPTips += data.data.payments.smileContactlessPPTips;
          totalSCGiftCardPPGC += data.data.payments.smileContactlessPPGC;
          totalSCGiftCardPPGCTips += data.data.payments.smileContactlessPPGCTips;
          totalSCGiftCardTotal += data.data.payments.smileContactlessPP +
              data.data.payments.smileContactlessPPTips +
              data.data.payments.smileContactlessPPGC +
              data.data.payments.smileContactlessPPGCTips;
        }
        double cellHeight = MediaQuery.of(context).size.height * 0.091;
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
                                      ),
                                      Text('PP \nTotal', textAlign: TextAlign.center),
                                      Divider(color: '#868E96'.toColor(), height: 1),
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
                                      Divider(color: '#868E96'.toColor(), height: 1),
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
                                      Divider(color: '#868E96'.toColor(), height: 1),
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
                                                margin: EdgeInsets.symmetric(horizontal: 20),
                                              ),
                                              Text('PP Tips', textAlign: TextAlign.center),
                                              Divider(color: '#868E96'.toColor(), height: 1),
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
                                            style: TextStyle(fontWeight: FontWeight.w500),
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
                                                margin: EdgeInsets.symmetric(horizontal: 16),
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
                        TableRow(
                          decoration: BoxDecoration(color: '#E5F0F5'.toColor()),
                          children: [
                            buildDataCell(totalCash.toStringAsFixed(2)),
                            buildDataCell(totalCheck.toStringAsFixed(2)),
                            buildDataCell(totalCoupon.toStringAsFixed(2)),
                            // 3rd Party
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        total3RDPP.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        total3RDPPTips.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        total3rdppTotal.toStringAsFixed(2),
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
                                        totalEmvCCsales.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalEmvCCTips.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalEmvCCTotal.toStringAsFixed(2),
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
                                        totalCloverFlexCCsales.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalCloverFlexCCTips.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalCloverFlexCCTotal.toStringAsFixed(2),
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
                                  Text(totalSDPrepaidPP.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDPrepaidPPTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDGiftCardPPGC.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDGiftCardPPGCTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDGiftCardTotal.toStringAsFixed(2), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            // Smile Contactless
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(totalSCPrepaidPP.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCPrepaidPPTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCGiftCardPPGC.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCGiftCardPPGCTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCGiftCardTotal.toStringAsFixed(2), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: '#E5F0F5'.toColor()),
                          children: [
                            buildDataCell(totalCash.toStringAsFixed(2)),
                            buildDataCell(totalCheck.toStringAsFixed(2)),
                            buildDataCell(totalCoupon.toStringAsFixed(2)),
                            // 3rd Party
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        total3RDPP.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        total3RDPPTips.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: InkWell(
                                        onTap: widget.onTapDetail,
                                        child: Text(
                                          total3rdppTotal.toStringAsFixed(2),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: '#496EE2'.toColor(),
                                            fontSize: 14,
                                          ),
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
                                        totalEmvCCsales.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalEmvCCTips.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalEmvCCTotal.toStringAsFixed(2),
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
                                        totalCloverFlexCCsales.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalCloverFlexCCTips.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totalCloverFlexCCTotal.toStringAsFixed(2),
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
                                  Text(totalSDPrepaidPP.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDPrepaidPPTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDGiftCardPPGC.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDGiftCardPPGCTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSDGiftCardTotal.toStringAsFixed(2), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            // Smile Contactless
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(totalSCPrepaidPP.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCPrepaidPPTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCGiftCardPPGC.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCGiftCardPPGCTips.toStringAsFixed(2), textAlign: TextAlign.center),
                                  Text(totalSCGiftCardTotal.toStringAsFixed(2), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
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

  Widget _buildServiceChargeandFeeTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        // คำนวณผลรวมของแต่ละประเภทจากข้อมูลทั้งหมด

        double totalgratuity = 0,
            totalonlineCustomCharge = 0,
            totalcontactlessCustomCharge = 0,
            totalsmilePOSAutoCharge = 0,
            totaldeliveryRestaurant = 0,
            totaldeliveryDoorDashDrive = 0,
            totalothers = 0,
            totalutensils = 0,
            totalpaymentFee = 0,
            totalserviceFeeOnCreditCard = 0,
            totalserviceFeeAdjustment = 0;

        for (var data in salesData) {
          // ServiceChargeAndFee
          totalgratuity += data.data.serviceChargeAndFee.gratuity;
          totalonlineCustomCharge += data.data.serviceChargeAndFee.onlineCustomCharge;
          totalcontactlessCustomCharge += data.data.serviceChargeAndFee.contactlessCustomCharge;
          totalsmilePOSAutoCharge += data.data.serviceChargeAndFee.smilePOSAutoCharge;
          totaldeliveryRestaurant += data.data.serviceChargeAndFee.deliveryRestaurant;
          totaldeliveryDoorDashDrive += data.data.serviceChargeAndFee.deliveryDoorDashDrive;
          totalothers += data.data.serviceChargeAndFee.others;
          totalutensils += data.data.serviceChargeAndFee.utensils;
          totalpaymentFee += data.data.serviceChargeAndFee.paymentFee;
          totalserviceFeeOnCreditCard += data.data.serviceChargeAndFee.serviceFeeOnCreditCard;
          totalserviceFeeAdjustment += data.data.serviceChargeAndFee.serviceFeeAdjustment;
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
                        TableRow(
                          decoration: BoxDecoration(color: '#ECF5EB'.toColor()),
                          children: [
                            totalgratuity,
                            totalonlineCustomCharge,
                            totalcontactlessCustomCharge,
                            totalsmilePOSAutoCharge,
                            totaldeliveryRestaurant,
                            totaldeliveryDoorDashDrive,
                            totalothers,
                            totalutensils,
                            totalpaymentFee,
                            totalserviceFeeOnCreditCard,
                            totalserviceFeeAdjustment,
                          ].map((total) => buildDataCell(total.toStringAsFixed(2))).toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: '#ECF5EB'.toColor()),
                          children: [
                            totalgratuity,
                            totalonlineCustomCharge,
                            totalcontactlessCustomCharge,
                            totalsmilePOSAutoCharge,
                            totaldeliveryRestaurant,
                            totaldeliveryDoorDashDrive,
                            totalothers,
                            totalutensils,
                            totalpaymentFee,
                            totalserviceFeeOnCreditCard,
                            totalserviceFeeAdjustment,
                          ].map((total) => buildDataCell(total.toStringAsFixed(2))).toList(),
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

  Widget _buildGiftCertificateTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;

        double totalgiftSales = 0, totalgiftRedeem = 0, totaleGiftSalesShop = 0, totaleGiftSalesOnline = 0;
        for (var data in salesData) {
          totalgiftSales += data.data.giftCertificate.giftSales;
          totalgiftRedeem += data.data.giftCertificate.giftRedeem;
          totaleGiftSalesShop += data.data.giftCertificate.eGiftSalesShop;
          totaleGiftSalesOnline += data.data.giftCertificate.eGiftSalesOnline;
        }
        double cellHeight = MediaQuery.of(context).size.height * 0.091;

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
                                      ),
                                      Expanded(
                                        child: Text('Online', textAlign: TextAlign.center),
                                      ),
                                      Divider(color: '#868E96'.toColor(), height: 1),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: '#FCE9EA'.toColor()),
                          children: [
                            buildDataCell(totalgiftSales.toStringAsFixed(2)),
                            buildDataCell(totalgiftRedeem.toStringAsFixed(2)),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      totaleGiftSalesShop.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    color: '#868E96'.toColor(),
                                  ),
                                  Expanded(
                                    child: Text(
                                      totaleGiftSalesOnline.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: '#FCE9EA'.toColor()),
                          children: [
                            buildDataCell(totalgiftSales.toStringAsFixed(2)),
                            buildDataCell(totalgiftRedeem.toStringAsFixed(2)),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totaleGiftSalesShop.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        totaleGiftSalesOnline.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildOtherTable() {
    return BlocBuilder<SalesBloc, SalesState>(builder: (context, state) {
      if (state is SalesLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SalesErrorState) {
        return Center(child: Text('Error: ${state.message}'));
      } else if (state is SalesLoadedState) {
        List<SalesData> salesData = state.salesData;
        double totaldiscount = 0, totalcashInCashOut = 0, totalcashDeposit = 0;
        for (var data in salesData) {
          totaldiscount += data.data.other.discount;
          totalcashInCashOut += data.data.other.cashDeposit;
          totalcashDeposit += data.data.other.cashDeposit;
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
                                height: MediaQuery.of(context).size.height * 0.124,
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
                        TableRow(
                          decoration: BoxDecoration(color: '#EDEFF0'.toColor()),
                          children: [
                            buildDataCell(totaldiscount.toStringAsFixed(2)),
                            buildDataCell(totalcashInCashOut.toStringAsFixed(2)),
                            Center(
                                child: Text(totalcashDeposit.toStringAsFixed(2),
                                    style: TextStyle(color: '496EE2'.toColor()), textAlign: TextAlign.center)),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: '#EDEFF0'.toColor()),
                          children: [
                            buildDataCell(totaldiscount.toStringAsFixed(2)),
                            buildDataCell(totalcashInCashOut.toStringAsFixed(2)),
                            Center(
                                child: Text(totalcashDeposit.toStringAsFixed(2),
                                    style: TextStyle(color: '496EE2'.toColor()), textAlign: TextAlign.center)),
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
        style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, color: '#3C3C3C'.toColor()),
      ),
    );
  }

  Widget _buildSubHeaderCell(String text) {
    return Container(
      height: 22,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildDataCell(String text) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      child: Text(text),
    );
  }
}
