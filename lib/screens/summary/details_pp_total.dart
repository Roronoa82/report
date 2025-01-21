// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';

final logger = Logger();

class DetailPPTotal extends StatefulWidget {
  final dynamic selectDate;

  DetailPPTotal(
    Map map, {
    Key? key,
    this.selectDate,
  }) : super(key: key);
  @override
  _DetailPPTotalState createState() => _DetailPPTotalState();
}

class _DetailPPTotalState extends State<DetailPPTotal> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController(); // ประกาศ ScrollController
  int _selectedTabIndex = 0;
  String selectedProvider = ''; // ตัวแปรเก็บชื่อ provider ที่เลือก

  final List<double> _scrollOffsets = [0.0, 595.0];
  final List<Color> _indicatorColors = [
    '#496EE2'.toColor(),
    '#41A036'.toColor(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

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

  // ฟังก์ชันสำหรับเปลี่ยน provider ที่เลือก
  void _onProviderSelected(String provider) {
    setState(() {
      selectedProvider = provider;
    });
  }

  @override
  Widget build(BuildContext context) {
    // แปลงวันที่เป็นรูปแบบที่ต้องการ
    String formattedDate =
        widget.selectDate != null ? DateFormat('MMMM dd, yyyy').format(widget.selectDate) : "Mon, 08/01/2023"; // แสดงข้อความหากไม่มีวันที่
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),

        color: '#EEEEEE'.toColor(), // สีพื้นหลังของ Column
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, bottom: 10, right: 10),
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
                  indicatorPadding: EdgeInsets.only(right: 60, left: 30),
                  tabs: [
                    Tab(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 70.0, bottom: 0, right: 40),
                            width: 200,
                            child: Text('Sales', style: TextStyle(fontSize: 14)),
                          ),
                          VerticalDivider(
                            color: Colors.grey,
                            thickness: 0.5,
                            width: 10, // Adjust spacing between text and divider
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 70.0, bottom: 0, right: 30),
                            width: 200,
                            child: Text('Payments', style: TextStyle(fontSize: 14)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // ชิดขอบขวา
                    children: [
                      Text(
                        'From: $formattedDate\nTo: $formattedDate', // วันที่ที่เลือกจะถูกแสดง
                        style: TextStyle(
                          fontSize: 16,
                          color: '#343A40'.toColor(),
                        ),
                      )
                    ]),
              ),
            ],
          ),
          SizedBox(height: 16),
          selectedProvider == ''
              ? SizedBox(
                  height: 300, // กำหนดความสูง 50 พิกเซล
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 16,
                    ),
                    decoration: BoxDecoration(
                      color: '#FFFFFF'.toColor(),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 48), // เพิ่มระยะห่างด้านขวา

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    color: '#000000DE'.toColor(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 120,
                                  height: 1,
                                  color: '#868E96'.toColor(),
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 10.0),
                                GestureDetector(
                                    onTap: () => _onProviderSelected('Smile Dining'), // เมื่อคลิก Smile Dining
                                    child: Text(
                                      'Smile Dining',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        color: '#2F80ED'.toColor(),
                                        decoration: TextDecoration.underline,
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 120,
                                  height: 1,
                                  color: '#E3E5E5'.toColor(),
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 10.0),
                                GestureDetector(
                                  onTap: () => _onProviderSelected('Deliverect'), // เมื่อคลิก Deliverect
                                  child: Text(
                                    'Deliverect',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      color: '#2F80ED'.toColor(),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 120,
                                  height: 1,
                                  color: '#E3E5E5'.toColor(),
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 10.0),
                                GestureDetector(
                                  onTap: () => _onProviderSelected('Doordash'), // เมื่อคลิก Doordash
                                  child: Text(
                                    'Doordash',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      color: '#2F80ED'.toColor(),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),

                                Container(
                                  width: 120,
                                  height: 1,
                                  color: '#E3E5E5'.toColor(),
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                ),
                                // const SizedBox(height: 20.0),
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
                                selectedProvider == ''
                                    ? Row(
                                        children: [
                                          _buildSalesTable(),
                                          _buildPaymentsTable(),
                                        ],
                                      )
                                    : selectedProvider == 'Smile Dining'
                                        ? _buildSmileDiningTable()
                                        : selectedProvider == 'Deliverect'
                                            ? _buildDeliverectTable()
                                            : selectedProvider == 'Doordash'
                                                ? _buildDoordashTable()
                                                : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : selectedProvider == 'Smile Dining'
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.375,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16.0, top: 16),
                        decoration: BoxDecoration(
                          color: '#FFFFFF'.toColor(),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 48), // เพิ่มระยะห่างด้านขวา
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Smile Dining',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      color: '#2F80ED'.toColor(),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: 120,
                                    height: 1,
                                    color: '#868E96'.toColor(),
                                  ),
                                  const SizedBox(height: 10.0),
                                  ...List.generate(
                                    // วนลูปเพื่อสร้าง Text ที่มีวันที่
                                    5,
                                    (index) {
                                      String date = '08/0${index + 1}/23'; // สร้างวันที่แบบ 08/01/23, 08/02/23 ฯลฯ
                                      return Column(
                                        children: [
                                          Text(
                                            date,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w300,
                                              color: '#000000DE'.toColor(),
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: 120,
                                            height: 1,
                                            color: '#E3E5E5'.toColor(),
                                          ),
                                          const SizedBox(height: 10.0),
                                        ],
                                      );
                                    },
                                  ),
                                  // แสดง Total
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
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    selectedProvider == ''
                                        ? _buildSalesTable()
                                        : selectedProvider == 'Smile Dining'
                                            ? Row(
                                                children: [_buildSmileDiningTable(), _buildDeliverectTable()],
                                              )
                                            : selectedProvider == 'Deliverect'
                                                ? _buildDeliverectTable()
                                                : selectedProvider == 'Doordash'
                                                    ? _buildDoordashTable()
                                                    : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
        ]),
      ),
    );
  }

  // ตารางสำหรับแสดงข้อมูล Sales
  Widget _buildSalesTable() {
    List<Map<String, String>> mockData = [
      {
        'Count': '32',
        'Sales': '125.9',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': '40',
        'Sales': '224.5',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Sales': 'xx.xx',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Sales': 'xx.xx',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
    ];
    double cellHeight = MediaQuery.of(context).size.height * 0.04;
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
                    width: 595,
                    height: 50,
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
                  5: FixedColumnWidth(85.0),
                  6: FixedColumnWidth(85.0),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                    children: ['Count', 'Sales', 'Charge', 'Tax', 'Tips\nTogo', 'Tips\nDelivery', 'Total \nAmount']
                        .map((title) => buildCell(title, style: headerStyle))
                        .toList(),
                  ),
                  ...mockData.map((rowData) {
                    return TableRow(
                      decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                      children: [
                        buildDataCell(rowData['Count']!),
                        buildDataCell(rowData['Sales']!),
                        buildDataCell(rowData['Charge']!),
                        buildDataCell(rowData['Tax']!),
                        buildDataCell(rowData['Tips Togo']!),
                        buildDataCell(rowData['Tips Delivery']!),
                        buildDataCell(rowData['Total Amount']!),
                      ],
                    );
                  }).toList(),
                ],
              )
            ])),
      ]),
    );
  }

  Widget _buildPaymentsTable() {
    List<Map<String, String>> mockDataPayments = [
      {
        'Count': '32',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': '40',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
    ];
    double cellHeight = MediaQuery.of(context).size.height * 0.04;
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
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(children: [
            Row(
              children: [
                Container(
                  width: 680,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: '#f7f7f7'.toColor(),
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
            Table(border: TableBorder.all(color: Colors.grey, width: 1), columnWidths: const {
              0: FixedColumnWidth(85.0),
              1: FixedColumnWidth(85.0),
              2: FixedColumnWidth(85.0),
              3: FixedColumnWidth(85.0),
              4: FixedColumnWidth(85.0),
              5: FixedColumnWidth(85.0),
              6: FixedColumnWidth(85.0),
              7: FixedColumnWidth(85.0),
            }, children: [
              TableRow(
                decoration: BoxDecoration(color: '#f7f7f7'.toColor()),
                children: ['Count', 'Prepaid', 'Prepaid\nGift Card', 'Credit', 'Gift Card', 'Check', 'Coupon', 'Total\nAmount']
                    .map((title) => buildCell(title, style: headerStyle))
                    .toList(),
              ),
              ...mockDataPayments.map((rowData) {
                return TableRow(
                  decoration: BoxDecoration(color: '#f7f7f7'.toColor()),
                  children: [
                    buildDataCell(rowData['Count']!),
                    buildDataCell(rowData['Prepaid']!),
                    buildDataCell(rowData['Prepaid Gift Card']!),
                    buildDataCell(rowData['Credit']!),
                    buildDataCell(rowData['Gift Card']!),
                    buildDataCell(rowData['Check']!),
                    buildDataCell(rowData['Coupon']!),
                    buildDataCell(rowData['Total Amount']!),
                  ],
                );
              }).toList(),
            ]),
          ]),
        ),
      ]),
    );
  }

  // ฟังก์ชันสำหรับแสดงตารางสำหรับ Smile Dining
  Widget _buildSmileDiningTable() {
    List<Map<String, String>> mockData = [
      {
        'Count': '32',
        'Sales': '125.9',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': '40',
        'Sales': '224.5',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Sales': 'xx.xx',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Sales': 'xx.xx',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Sales': 'xx.xx',
        'Charge': 'xx.xx',
        'Tax': 'xx.xx',
        'Tips Togo': 'xx.xx',
        'Tips Delivery': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
    ];
    double cellHeight = MediaQuery.of(context).size.height * 0.042;
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
                    width: 595,
                    height: 50,
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
                  5: FixedColumnWidth(85.0),
                  6: FixedColumnWidth(85.0),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                    children: ['Count', 'Sales', 'Charge', 'Tax', 'Tips\nTogo', 'Tips\nDelivery', 'Total \nAmount']
                        .map((title) => buildCell(title, style: headerStyle))
                        .toList(),
                  ),
                  ...mockData.map((rowData) {
                    return TableRow(
                      decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                      children: [
                        buildDataCell(rowData['Count']!),
                        buildDataCell(rowData['Sales']!),
                        buildDataCell(rowData['Charge']!),
                        buildDataCell(rowData['Tax']!),
                        buildDataCell(rowData['Tips Togo']!),
                        buildDataCell(rowData['Tips Delivery']!),
                        buildDataCell(rowData['Total Amount']!),
                      ],
                    );
                  }).toList(),
                  TableRow(
                    decoration: BoxDecoration(color: '#E9E6EA'.toColor()),
                    children: [
                      buildDataCell(
                        mockData.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Count']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockData.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Sales']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockData.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Charge']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockData.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Tax']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockData.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Tips Togo']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockData.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Tips Delivery']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockData.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Total Amount']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                    ],
                  ),
                ],
              )
            ])),
      ]),
    );
  }

  // ฟังก์ชันสำหรับแสดงตารางสำหรับ Deliverect
  Widget _buildDeliverectTable() {
    List<Map<String, String>> mockDataPayments = [
      {
        'Count': '32',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': '40',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
      {
        'Count': 'xx.xx',
        'Prepaid': 'xx.xx',
        'Prepaid Gift Card': 'xx.xx',
        'Credit': 'xx.xx',
        'Gift Card': 'xx.xx',
        'Check': 'xx.xx',
        'Coupon': 'xx.xx',
        'Total Amount': 'xx.xx',
      },
    ];
    double cellHeight = MediaQuery.of(context).size.height * 0.042;
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
                    width: 680,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: '#f7f7f7'.toColor(),
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
                  0: FixedColumnWidth(85.0),
                  1: FixedColumnWidth(85.0),
                  2: FixedColumnWidth(85.0),
                  3: FixedColumnWidth(85.0),
                  4: FixedColumnWidth(85.0),
                  5: FixedColumnWidth(85.0),
                  6: FixedColumnWidth(85.0),
                  7: FixedColumnWidth(85.0),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: '#f7f7f7'.toColor()),
                    children: ['Count', 'Prepaid', 'Prepaid\nGift Card', 'Credit', 'Gift Card', 'Check', 'Coupon', 'Total\nAmount']
                        .map((title) => buildCell(title, style: headerStyle))
                        .toList(),
                  ),
                  ...mockDataPayments.map((rowData) {
                    return TableRow(
                      decoration: BoxDecoration(color: '#f7f7f7'.toColor()),
                      children: [
                        buildDataCell(rowData['Count']!),
                        buildDataCell(rowData['Prepaid']!),
                        buildDataCell(rowData['Prepaid Gift Card']!),
                        buildDataCell(rowData['Credit']!),
                        buildDataCell(rowData['Gift Card']!),
                        buildDataCell(rowData['Check']!),
                        buildDataCell(rowData['Coupon']!),
                        buildDataCell(rowData['Total Amount']!),
                      ],
                    );
                  }).toList(),
                  TableRow(
                    decoration: BoxDecoration(color: '#f7f7f7'.toColor()),
                    children: [
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Count']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Prepaid']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Prepaid Gift Card']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Credit']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Gift Card']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Check']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Coupon']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                      buildDataCell(
                        mockDataPayments.fold(0.0, (sum, rowData) {
                          double value = double.tryParse(rowData['Total Amount']!.replaceAll(',', '').trim()) ?? 0.0;
                          return sum + value;
                        }).toString(),
                      ),
                    ],
                  ),
                ],
              )
            ])),
      ]),
    );
  }

  // ฟังก์ชันสำหรับแสดงตารางสำหรับ Doordash
  Widget _buildDoordashTable() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Doordash Table'),
          // สร้างตารางตามที่ต้องการ
        ],
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
