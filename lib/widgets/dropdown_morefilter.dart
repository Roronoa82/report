// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class MoreFilterMenu extends StatefulWidget {
  @override
  _MoreFilterMenuState createState() => _MoreFilterMenuState();
}

class _MoreFilterMenuState extends State<MoreFilterMenu> {
  final LayerLink _layerLink = LayerLink();
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;

  String? selectedMainOption; // ตัวเลือกหลักที่ผู้ใช้เลือก
  List<String> subOptions = []; // ตัวเลือกย่อยที่เกี่ยวข้อง
  List<String> selectedSubOptions = []; // ตัวเลือกย่อยที่ผู้ใช้เลือกไว้

  final Map<String, List<String>> mainOptions = {
    "Fruits": ["Apple", "Banana", "Cherry"],
    "Vegetables": ["Carrot", "Broccoli", "Spinach"],
    "Drinks": ["Water", "Juice", "Soda"],
  };

  // ฟังก์ชันสร้าง Overlay
  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, 50),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Main Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...mainOptions.keys.map((category) {
                    return CheckboxListTile(
                      title: Text(category),
                      value: selectedMainOption == category,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedMainOption = category;
                            subOptions = mainOptions[category]!;
                            selectedSubOptions.clear();
                          } else {
                            selectedMainOption = null;
                            subOptions = [];
                            selectedSubOptions.clear();
                          }
                        });
                      },
                    );
                  }).toList(),
                  if (subOptions.isNotEmpty) ...[
                    SizedBox(height: 10),
                    Text(
                      "Select Sub Categories",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children: subOptions.map((subCategory) {
                        final isSelected = selectedSubOptions.contains(subCategory);
                        return ChoiceChip(
                          label: Text(subCategory),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedSubOptions.add(subCategory);
                              } else {
                                selectedSubOptions.remove(subCategory);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _hideOverlay,
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print("Selected: $selectedMainOption, $selectedSubOptions");
                          _hideOverlay();
                        },
                        child: Text("Apply"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // แสดงหรือซ่อน Overlay
  void _toggleDropdown() {
    if (isDropdownOpen) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      isDropdownOpen = true;
    });
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: '#3C3C3C'.toColor(),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24), // ขนาดของปุ่ม
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // ความโค้งของมุม
          ),
          backgroundColor: '#FFFFFF'.toColor(),
        ),
        onPressed: _toggleDropdown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt,
              color: Colors.black,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              "More Filter",
              style: TextStyle(
                fontFamily: 'Inter',
                color: '#3C3C3C'.toColor(),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, color: '#3C3C3C'.toColor()),
          ],
        ),
      ),
    );
  }
}
