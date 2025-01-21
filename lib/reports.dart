// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:develop_resturant/screens/summary/summary_sales.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'screens/menusetup/menu_setup.dart';
import 'screens/overall/overall_summary.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportPage extends StatefulWidget {
  final int initialSelectedReport; // รับค่าเริ่มต้น
  final Function(int) onReportSelected; // Callback เมื่อมีการเลือก report

  ReportPage({
    Key? key,
    required this.initialSelectedReport,
    required this.onReportSelected,
  }) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedMenu = 'Overall Summary';
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  String _selectedValue = "Thanapat";
  late int selectedReport;

  // สร้าง StreamController สำหรับแต่ละ Switch
  final StreamController<bool> smileDiningController = StreamController.broadcast();

  final Map<String, Widget> menuContent = {
    'Overall Summary': OverallSummaryPage(payments: {}),
    'Summary Sales': SummarysalesPage(payments: {}),

    // เพิ่มเนื้อหาของเมนูอื่น ๆ ที่นี่
  };
  @override
  void initState() {
    super.initState();
    selectedReport = widget.initialSelectedReport; // กำหนดค่าเริ่มต้นจาก parent
    // smileDiningController.add(false); // ค่าเริ่มต้นของ Switch
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => StreamBuilder<bool>(
            stream: smileDiningController.stream,
            builder: (context, snapshot) {
              return Positioned(
                width: 300, // Adjust width as needed
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, 50), // Adjust offset for positioning
                  child: Material(
                    elevation: 4.0,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Section
                          Text(
                            "Email: Thanapat@smilepos.com",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Divider(),
                          // Restaurant ID Section
                          Text(
                            "Restaurant ID: Devwa",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Divider(),
                          // Toggle Switches
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Smile Dining:",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              StreamBuilder<bool>(
                                stream: smileDiningController.stream, // ใช้ StreamController สำหรับสถานะ
                                initialData: false, // ค่าเริ่มต้นของ Switch
                                builder: (context, snapshot) {
                                  final isSmileDiningOpen = snapshot.data ?? false;
                                  return Switch(
                                    value: isSmileDiningOpen, // กำหนดสถานะเปิด/ปิด
                                    onChanged: (value) {
                                      // อัปเดตสถานะ Switch
                                      smileDiningController.add(value);

                                      // อัปเดต selectedReport
                                      setState(() {
                                        selectedReport = value ? 1 : 0;
                                      });

                                      // แจ้งสถานะกลับไปยัง parent widget
                                      widget.onReportSelected(selectedReport);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Smile Contactless Dining:",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              StreamBuilder<bool>(
                                stream: smileDiningController.stream, // ใช้ StreamController สำหรับสถานะ
                                initialData: false, // ค่าเริ่มต้นของ Switch
                                builder: (context, snapshot) {
                                  final isSmileDiningOpen = snapshot.data ?? false;
                                  return Switch(
                                    value: isSmileDiningOpen, // กำหนดสถานะเปิด/ปิด
                                    onChanged: (value) {
                                      smileDiningController.add(value);

                                      setState(() {
                                        selectedReport = value ? 1 : 0;
                                      });

                                      widget.onReportSelected(selectedReport);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: const [
                              Icon(Icons.sync, size: 16),
                              SizedBox(width: 8),
                              Text(
                                "Switch Restaurant",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                side: BorderSide(color: Colors.grey),
                              ),
                              child: Text("Logout"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
          padding: EdgeInsets.only(left: 400, right: 400, top: 50),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Develop Resturant",
                    style: TextStyle(fontFamily: 'Inter', color: '#959595'.toColor(), fontSize: 30),
                  ),
                  Container(
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (_overlayEntry == null) {
                                _showOverlay(context);
                              } else {
                                _hideOverlay();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedValue,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(
                color: '#959595'.toColor(),
                height: 1,
              ),
            ],
          ),
        ),
      ),
      body: Stack(children: [
        Positioned(
          left: -260,
          top: 100,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.7,
                colors: [
                  '#FFD18D'.toColor(),
                  '#FFFFFF00'.toColor(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -260,
          top: 450,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.7,
                colors: [
                  '#FFD18D'.toColor(),
                  '#FFFFFF00'.toColor(),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 400, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.13,
                color: Colors.grey[100],
                child: ListView(
                  padding: const EdgeInsets.only(right: 16),
                  children: [
                    Divider(),
                    const ListTile(
                      leading: Icon(Icons.settings, color: Colors.grey),
                      title: Text(
                        "Store Setting",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Image.asset('assets/smile.png'),
                      title: Text(
                        "Smile Dining",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Image.asset('assets/smile.png'),
                      title: Text(
                        "Contactless",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
                    ),
                    Divider(),
                    ExpansionTile(
                      leading: Icon(Icons.restaurant, color: Colors.grey),
                      title: Text(
                        "Menu Setup",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: ListTile(
                            title: Text(
                              "Menu Setup",
                            ),
                            onTap: () {
                              setState(() {
                                selectedMenu = 'Menu Setup';
                              });
                            },
                            tileColor: selectedMenu == 'Menu Setup' ? Colors.black : Colors.white,
                            selected: selectedMenu == 'Menu Setup',
                            selectedTileColor: Colors.black,
                            textColor: selectedMenu == 'Menu Setup' ? Colors.white : Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: Column(
                            children: [
                              ...[
                                "Choice Group",
                                "Choice Option",
                                "Customize Menu",
                              ].map((item) {
                                return ListTile(
                                  title: Text(item),
                                  onTap: () {
                                    setState(() {
                                      selectedMenu = item;
                                    });
                                  },
                                  tileColor: selectedMenu == item ? '#000000'.toColor() : Colors.white,
                                  selected: selectedMenu == item,
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    const ListTile(
                      leading: Icon(Icons.card_giftcard, color: Colors.grey),
                      title: Text(
                        "E-Card",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.bullhorn,
                        color: Colors.grey,
                        size: 20,
                      ),
                      title: Text(
                        "Marketing",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
                    ),
                    ExpansionTile(
                      leading: FaIcon(FontAwesomeIcons.clipboardList, color: '#000000'.toColor()),
                      title: Text(
                        "Report",
                        style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: '#000000'.toColor(), fontSize: 18),
                      ),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: ListTile(
                            title: Text(
                              "Overall Summary",
                            ),
                            onTap: () {
                              setState(() {
                                selectedMenu = 'Overall Summary';
                              });
                            },
                            tileColor: selectedMenu == 'Overall Summary' ? Colors.black : Colors.white,
                            selected: selectedMenu == 'Overall Summary',
                            selectedTileColor: Colors.black,
                            textColor: selectedMenu == 'Overall Summary' ? Colors.white : Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: ListTile(
                            title: Text("Summary Sales"),
                            onTap: () {
                              setState(() {
                                selectedMenu = 'Summary Sales';
                              });
                            },
                            tileColor: selectedMenu == 'Summary Sales' ? Colors.black : Colors.white,
                            selected: selectedMenu == 'Summary Sales',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: Column(
                            children: [
                              ...[
                                "Credit Card Types",
                                "Discounts",
                                "Labor",
                                "Employee Auditing",
                                "Employee Sales",
                                "Food Sales",
                                "Choice Sales",
                                "Sales by 3rd Party",
                                "Gift Cards",
                                "Customers Sales",
                                "Access Log History"
                              ].map((item) {
                                return ListTile(
                                  title: Text(item),
                                  onTap: () {
                                    setState(() {
                                      selectedMenu = item;
                                    });
                                  },
                                  tileColor: selectedMenu == item ? '#000000'.toColor() : Colors.white,
                                  selected: selectedMenu == item,
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: selectedMenu == 'Menu Setup'
                    ? FoodItemScreen()
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: '#C3C3C3'.toColor(),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: selectedMenu == 'Overall Summary' ? OverallSummaryPage(payments: {}) : SummarysalesPage(payments: {}),
                      ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
