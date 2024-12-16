import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'header.dart';
import 'screens/overall/overall_summary.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  //String? selectedMenu;
  String selectedMenu = 'Overall Summary'; // กำหนดค่าเริ่มต้นเป็น "Overall Summary"

  Map<String, dynamic> payments = {};
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 100, right: 100, top: 10),
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
                            // setState(() {
                            //   selectedMenu = 'Overall Summary'; // เปลี่ยนค่าเมื่อคลิก
                            // });
                          },
                          tileColor: selectedMenu == 'Overall Summary' ? Colors.blue[100] : Colors.white, // เปลี่ยนสีพื้นหลังเมื่อเลือก
                          selectedTileColor: Colors.blue[100], // สีพื้นหลังเมื่อเลือก
                          selected: selectedMenu == 'Overall Summary',
                        ),
                        const ListTile(
                          title: Text("Summary Sales"),
                        ),
                        const ListTile(
                          title: Text("Credit Card Types"),
                        ),
                        const ListTile(
                          title: Text("Discounts"),
                        ),
                        const ListTile(
                          title: Text("Labor"),
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
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: OverallSummaryPage(
                    selectedDate: '',
                    payments: {},
                    fromDate: fromDate,
                    toDate: toDate,
                  ), // แสดง OverallSummaryPage ทันที
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
