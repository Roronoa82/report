import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supercharged/supercharged.dart';

import '../../bloc/data_result.state.dart';
import '../../bloc/data_result_bloc.dart';

class FoodSetDialog extends StatefulWidget {
  @override
  _FoodSetDialogState createState() => _FoodSetDialogState();
}

class _FoodSetDialogState extends State<FoodSetDialog> with TickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController _searchController = TextEditingController(); // ควบคุมค่าในช่องค้นหา
  String _searchQuery = ""; // ตัวแปรเก็บคำค้นหา
  ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> categoryKeys = {};
  String? selectedFoodSet;
  bool isActive = true;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DataLoaded) {
            final foodSet = state.sets;
            final foodSetNames = state.sets
                .where((foodset) => foodset.foodSetName != null && foodset.foodSetName!.isNotEmpty)
                .map((foodset) => foodset.foodSetName!)
                .toSet()
                .toList();
            final foodSetActiveStatus = foodSet
                .where((foodset) => foodset.active != null) // กรองเฉพาะ active ที่มีค่า
                .map((foodset) => foodset.active)
                .toList();

            if (selectedFoodSet == null && foodSetNames.isNotEmpty) {
              selectedFoodSet = foodSetNames.first;
            }
            return Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Setup Set Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Row 1 - Set Menu Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Set Menu Name',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: '#3C3C3C'.toColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 150),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: '#FFFFFF'.toColor(), // สีพื้นหลัง
                          borderRadius: BorderRadius.circular(8.0), // ความโค้งของกรอบ
                          border: Border.all(
                            color: '#00000033'.toColor(),
                            width: 2.0, // ความหนาของกรอบ
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              foodSetNames.isNotEmpty ? foodSetNames.first : 'เลือก Food Set', // ถ้า foodSetNames ไม่ว่าง ให้แสดงชื่อชุดอาหารแรก
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: '#3C3C3C'.toColor(), // สีของข้อความ
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // เพิ่มช่องว่างระหว่าง Row
                  // Row 2 - Option 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: '#3C3C3C'.toColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 230),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Switch(
                            value: isActive,
                            onChanged: (bool newValue) {
                              setState(() {
                                isActive = newValue;
                              });
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                          ),
                          if (!isActive)
                            Row(
                              children: [
                                Text(
                                  isActive ? 'Active' : 'Deactive',
                                  style: TextStyle(
                                    color: '#FF0000'.toColor(), // สีแดงสำหรับข้อความ
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                if (!isActive)
                                  GestureDetector(
                                    onTap: () {
                                      print("Delete clicked");
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Product Set Menu',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: '#3C3C3C'.toColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 150),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Radio Buttons สำหรับตัวเลือกแรก
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Dining',
                                groupValue: selectedOption,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                },
                              ),
                              Text(
                                'Dining,Contactless Dining',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: selectedOption == 'Dining'
                                      ? '#3C3C3C'.toColor() // สีปกติเมื่อเลือก
                                      : '#AAAAAA'.toColor(), // สีจางเมื่อไม่เลือก
                                ),
                              ),
                            ],
                          ),
                          // Radio Buttons สำหรับตัวเลือกที่ 2
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Third Party',
                                groupValue: selectedOption,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                },
                              ),
                              Text(
                                'Third Party',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: selectedOption == 'Third Party'
                                      ? '#3C3C3C'.toColor() // สีปกติเมื่อเลือก
                                      : '#AAAAAA'.toColor(), // สีจางเมื่อไม่เลือก
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: '#FFFFFF'.toColor(), // กำหนดสีพื้นหลังปุ่ม
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // ความโค้งมุมปุ่ม
                                side: BorderSide(width: 1)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // ปิด Dialog เมื่อกดปุ่ม
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0), // กำหนดสีข้อความ
                              fontSize: 16, // ขนาดข้อความ
                              fontWeight: FontWeight.w600, // ความหนาของข้อความ
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: '#496EE2'.toColor(), // กำหนดสีพื้นหลังปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // ความโค้งมุมปุ่ม
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // ปิด Dialog เมื่อกดปุ่ม
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white, // กำหนดสีข้อความ
                              fontSize: 16, // ขนาดข้อความ
                              fontWeight: FontWeight.w600, // ความหนาของข้อความ
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
    );
  }
}

void showFoodSetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FoodSetDialog();
    },
  );
}
