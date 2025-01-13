// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:develop_resturant/model_summary_sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/summary_sale_bloc.dart';
import '../../bloc/summary_sale_state.dart';

final logger = Logger();

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),

        color: '#EEEEEE'.toColor(), // สีพื้นหลังของ Column
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),
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
                tabs: const [
                  Tab(text: 'Sales'),
                  Tab(text: 'Sales By Order Type'),
                  Tab(text: 'Payments'),
                  Tab(text: 'Service Charge & Fee'),
                  Tab(text: 'Gift Certificate'),
                  Tab(text: 'Other'),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 250, // กำหนดความสูง 50 พิกเซล
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
                        padding: const EdgeInsets.only(right: 16.0, top: 70), // เพิ่มระยะห่างด้านขวา
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 25, bottom: 25),
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        // คำนวณผลรวมของแต่ละประเภทจากข้อมูลทั้งหมด
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
          // Payments
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
                          height: 34,
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
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: SizedBox(height: 40, child: Text('Cash', textAlign: TextAlign.center)),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: SizedBox(height: 40, child: Text('Check', textAlign: TextAlign.center)),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: SizedBox(height: 40, child: Text('Coupon', textAlign: TextAlign.center)),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('3rd Party', textAlign: TextAlign.center),
                                  Divider(color: '#868E96'.toColor()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('PP', textAlign: TextAlign.center),
                                      Text('PP Tips', textAlign: TextAlign.center),
                                      Text('PP \nTotal', textAlign: TextAlign.center),
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
                                  Text('Credit (EMV)', textAlign: TextAlign.center),
                                  Divider(color: '#868E96'.toColor()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('CC \nSales', textAlign: TextAlign.center),
                                      Text('CC Tips', textAlign: TextAlign.center),
                                      Text('CC \nTotal', textAlign: TextAlign.center),
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
                                  Text('Credit (Clover Flex)', textAlign: TextAlign.center),
                                  Divider(color: '#868E96'.toColor()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('CC \nSales', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Text('CC Tips', textAlign: TextAlign.center),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Text('CC \nTotal', textAlign: TextAlign.center),
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
                                  Text(
                                    'Smile Dining',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Divider(color: '#868E96'.toColor()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text('Prepaid', textAlign: TextAlign.center),
                                          Divider(),
                                          Row(
                                            children: [
                                              Text('PP', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 20,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 8), // ระยะห่างจากข้อความ
                                              ),
                                              Text('PP Tips', textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 70,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Gift Card',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w500), // ตัวหนา (ถ้าต้องการ)
                                          ),
                                          Divider(
                                            color: '#868E96'.toColor(),
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('PPGC', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 20,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 8), // ระยะห่างจากข้อความ
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
                                  Text(
                                    'Smile Contactless (On Table)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Divider(
                                    color: '#868E96'.toColor(),
                                    thickness: 1,
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                margin: EdgeInsets.only(top: 4),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('PP', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 30,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 8),
                                              ),
                                              Text('PP Tips', textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 70,
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
                                                margin: EdgeInsets.only(top: 4),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('PPGC', textAlign: TextAlign.center),
                                              Container(
                                                width: 1,
                                                height: 30,
                                                color: '#868E96'.toColor(),
                                                margin: EdgeInsets.symmetric(horizontal: 8),
                                              ),
                                              Text('PPGC Tips', textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 70,
                                        color: '#868E96'.toColor(),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Total',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        // Data Row 1
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
                                      ),
                                    ),
                                  ),
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

        double cellHeight = MediaQuery.of(context).size.height * 0.09;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 340,
                            height: 34,
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
                        columnWidths: const {
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
                                child: SizedBox(height: cellHeight, child: Text('Gift Sales', textAlign: TextAlign.center)),
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Center(child: Text('Gift Redeem', textAlign: TextAlign.center)),
                              ),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('E-Gift Sales', textAlign: TextAlign.center),
                                    Divider(color: '#868E96'.toColor()),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text('Shop', textAlign: TextAlign.center),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 40,
                                          color: '#868E96'.toColor(),

                                          margin: EdgeInsets.zero, // ลบช่องว่างรอบเส้น
                                          padding: EdgeInsets.zero,
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text('Online', textAlign: TextAlign.center),
                                          ),
                                        ),

                                        Divider(color: '#868E96'.toColor(), height: 1), // เส้นแบ่งระหว่างหัวข้อและตัวเลข
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
                                      child: Center(
                                        child: Text(
                                          totaleGiftSalesShop.toStringAsFixed(2),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1, // ความกว้างของเส้น
                                      color: '#868E96'.toColor(),
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
                                height: MediaQuery.of(context).size.height * 0.09,
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

  // ฟังก์ชันสำหรับสร้าง header ของตาราง
  Widget _buildHeaderCell(String text) {
    return Container(
      height: 50.0,
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
