// ignore_for_file: prefer_const_constructors

import 'package:develop_resturant/screens/summary/summary_sales.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'screens/overall/overall_summary.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedMenu = 'Overall Summary';

  final Map<String, Widget> menuContent = {
    'Overall Summary': OverallSummaryPage(payments: {}),
    'Summary Sales': SummarysalesPage(payments: {}),
    // เพิ่มเนื้อหาของเมนูอื่น ๆ ที่นี่
  };
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: "Thanapat",
                        onChanged: (String? newValue) {},
                        items: <String>['Thanapat', 'Logout'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
              // Sidebar
              Container(
                width: 250,
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
                    const ListTile(
                      leading: Icon(Icons.restaurant, color: Colors.grey),
                      title: Text(
                        "Menu Setup",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromRGBO(149, 149, 149, 1),
                        ),
                      ),
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
                    // const Divider(),
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
                child: Container(
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
