// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:develop_resturant/screens/summary/summary_sales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  final StreamController<bool> smileDiningController = StreamController.broadcast();

  final Map<String, Widget> menuContent = {
    'Overall Summary': OverallSummaryPage(payments: {}),
    'Summary Sales': SummarysalesPage(payments: {}),
    'FoodItemScreen': FoodItemScreen(),
  };
  @override
  void initState() {
    super.initState();
    selectedReport = widget.initialSelectedReport;
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
                width: MediaQuery.of(context).size.width * 0.222,
                height: MediaQuery.of(context).size.height * 0.45,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(-260, 60), // Adjust offset for positioning
                  child: Material(
                    elevation: 4.0,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 14),
                            child: textdetails(
                              "Email: Thanapat@smilepos.com",
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0, bottom: 14, left: 24),
                          child: textstyledropdown(
                            "Restaurant ID: Devwa",
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        // Toggle Switches
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 14, left: 24),
                              child: textstyledropdown(
                                "Smile Dining:",
                                // style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 24),
                              child: textstyledropdown(
                                "Smile Contactless Dining:",
                                // style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
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
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sync,
                                size: 16,
                                color: '#3C3C3C'.toColor(),
                              ),
                              SizedBox(width: 8),
                              textstyledropdown(
                                "Switch Restaurant",
                              ),
                            ],
                          ),
                        ),
                        Divider(),

                        SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.077,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: '#C3C3C3'.toColor(), width: 1),
                            ),
                            child: Center(child: textstyledropdown("Logout")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding = screenWidth * 0.207;
    double verticalPadding = screenHeight * 0.05;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: verticalPadding,
          ),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Develop Resturant",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: '#959595'.toColor(),
                      fontSize: screenWidth * 0.0135,
                    ),
                  ),
                  if (selectedMenu == 'Menu Setup') // เงื่อนไขแสดง SearchBar
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 100, // or use MediaQuery for dynamic width
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth * 0.0088,
                                      color: '#959595'.toColor(),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: '#959595'.toColor(),
                                    ),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    filled: true,
                                    fillColor: '#EEEEEE'.toColor(),
                                  ),
                                  onChanged: (value) {
                                    print("Search: $value");
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: '#EEEEEE'.toColor(),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/microphone.svg',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.086,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              if (_overlayEntry == null) {
                                _showOverlay(context);
                              } else {
                                _hideOverlay();
                              }
                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedValue,
                                  style: TextStyle(fontSize: screenWidth * 0.01, color: '#000000'.toColor(), fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.002),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: screenWidth * 0.022,
                                  color: '#000000'.toColor(),
                                ),
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
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.0,
            horizontal: MediaQuery.of(context).size.width * 0.206,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.126,
                color: '#FFFFFF'.toColor(),
                child: ListView(
                  padding: const EdgeInsets.only(right: 16),
                  children: [
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.grey),
                      title: Text(
                        "Store Setting",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: '#959595'.toColor(),
                          fontWeight: FontWeight.w500,
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
                          color: '#959595'.toColor(),
                          fontWeight: FontWeight.w500,
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
                          color: '#959595'.toColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(),
                    ExpansionTile(
                      iconColor: '#959595'.toColor(),
                      collapsedIconColor: '#959595'.toColor(),
                      leading: Icon(Icons.restaurant, color: Colors.grey),
                      title: Text(
                        "Menu Setup",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: '#959595'.toColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: ListTile(
                            title: Text(
                              "Menu Setup",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: selectedMenu == 'Menu Setup' ? Colors.black : '#959595'.toColor(), // ✅ เปลี่ยนสีข้อความ
                              ),
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
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: '#959595'.toColor(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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
                    ListTile(
                      leading: Icon(Icons.card_giftcard, color: Colors.grey),
                      title: Text(
                        "E-Card",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: '#959595'.toColor(),
                          fontWeight: FontWeight.w500,
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
                          color: '#959595'.toColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ExpansionTile(
                      iconColor: '#959595'.toColor(),
                      collapsedIconColor: '#959595'.toColor(),
                      leading: FaIcon(FontAwesomeIcons.clipboardList, color: '#000000'.toColor()),
                      title: Text(
                        "Report",
                        style:
                            TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: '#000000'.toColor(), fontSize: screenWidth * 0.0088),
                      ),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: ListTile(
                            title: Text(
                              "Overall Summary",
                              style: TextStyle(
                                  color: selectedMenu == 'Overall Summary' ? Colors.black : '#959595'.toColor(), fontWeight: FontWeight.w500),
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
                            title: Text(
                              "Summary Sales",
                              style:
                                  TextStyle(color: selectedMenu == 'Summary Sales' ? Colors.black : '#959595'.toColor(), fontWeight: FontWeight.w500),
                            ),
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
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: '#959595'.toColor(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: '#C3C3C3'.toColor(),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: selectedMenu == 'Menu Setup'
                      ? FoodItemScreen()
                      : selectedMenu == 'Overall Summary'
                          ? OverallSummaryPage(payments: {})
                          : SummarysalesPage(payments: {}),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Text textdetails(String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: screenWidth * 0.0088,
        color: '#959595'.toColor(),
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Text textstyledropdown(String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: screenWidth * 0.0088,
        color: '#3C3C3C'.toColor(),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
