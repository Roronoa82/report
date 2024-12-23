// ignore_for_file: prefer_const_constructors

import 'package:develop_resturant/screens/summary/summary_sales.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'header.dart';
import 'screens/overall/overall_summary.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedMenu = 'Overall Summary';

  Map<String, dynamic> payments = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 300, right: 300, top: 10),
          child: Row(
            children: [
              // Sidebar
              Container(
                width: 250, // ความกว้างของ sidebar
                color: Colors.grey[100],
                child: ListView(
                  children: [
                    // หัวข้อหลัก
                    const ListTile(
                      leading: Icon(Icons.settings, color: Colors.grey),
                      title: Text("Store Setting"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.emoji_emotions, color: Colors.grey),
                      title: Text("Smile Dining"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.phone_android, color: Colors.grey),
                      title: Text("Contactless"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.restaurant_menu, color: Colors.grey),
                      title: Text("Menu Setup"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.card_giftcard, color: Colors.grey),
                      title: Text("E-Card"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.campaign, color: Colors.grey),
                      title: Text("Marketing"),
                    ),
                    const Divider(),
                    ExpansionTile(
                      leading: Icon(Icons.insert_drive_file, color: Colors.black),
                      title: const Text("Report"),
                      initiallyExpanded: true, // เปิดเมนู Report ไว้ตั้งแต่เริ่ม
                      children: [
                        ListTile(
                          title: const Text("Overall Summary"),
                          onTap: () {
                            setState(() {
                              selectedMenu = 'Overall Summary'; // เปลี่ยนค่าเมื่อคลิก
                            });
                          },
                          tileColor: selectedMenu == 'Overall Summary' ? '#000000'.toColor() : Colors.white, // เปลี่ยนสีพื้นหลังเมื่อเลือก
                          selectedTileColor: Colors.blue[100], // สีพื้นหลังเมื่อเลือก
                          selected: selectedMenu == 'Overall Summary',
                        ),
                        ListTile(
                          title: Text("Summary Sales"),
                          onTap: () {
                            setState(() {
                              selectedMenu = 'Summary Sales'; // เปลี่ยนค่าเมื่อคลิก
                            });
                          },
                          tileColor: selectedMenu == 'Summary Sales' ? '#000000'.toColor() : Colors.white,
                          selectedTileColor: '#000000'.toColor(),
                          selected: selectedMenu == 'Summary Sales',
                        ),
                        const ListTile(
                          title: Text("Credit Card Types"),
                        ),
                        const ListTile(
                          title: Text("Discounts"),
                        ),
                        const ListTile(
                          title: Text(
                            "Labor",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 16,
                              // color:'#000000'.toColor(),
                            ),
                          ),
                        ),
                        const ListTile(
                          title: Text("Employee Auditing"),
                        ),
                        const ListTile(
                          title: Text("Employee Sales"),
                        ),
                        const ListTile(
                          title: Text("Food Sales"),
                        ),
                        const ListTile(
                          title: Text("Choice Sales"),
                        ),
                        const ListTile(
                          title: Text("Sales by 3rd Party"),
                        ),
                        const ListTile(
                          title: Text("Gift Cards"),
                        ),
                        const ListTile(
                          title: Text("Customers Sales"),
                        ),
                        const ListTile(
                          title: Text("Access Log History"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Content Area
              Expanded(
                child: Container(
                  color: "#EEEEEE".toColor(),
                  padding: const EdgeInsets.all(16),
                  child: selectedMenu == 'Overall Summary'
                      ? OverallSummaryPage(payments: {}) // แสดง OverallSummaryPage
                      : SummarysalesPage(
                          payments: {},
                        ), // แสดง SummarySalesPage
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
