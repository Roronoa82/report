// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class ExportMenu extends StatefulWidget {
  @override
  _ExportMenuState createState() => _ExportMenuState();
}

class _ExportMenuState extends State<ExportMenu> {
  final LayerLink _layerLink = LayerLink();
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  StreamController<bool> export = StreamController.broadcast();

  // ตัวแปรเพื่อเก็บตัวเลือกที่ผู้ใช้เลือก
  String? selectedOption;

  // ฟังก์ชันสำหรับสร้าง Overlay
  OverlayEntry _showOverlay(BuildContext context) {
    return OverlayEntry(
      builder: (context) => StreamBuilder<bool>(
          stream: export.stream,
          builder: (context, snapshot) {
            return Positioned(
              width: 300,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: Offset(0, 50),
                showWhenUnlinked: false,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...[
                          'PDF (*.pdf)',
                          'Excel (*.xlsx)',
                          'CSV (*.csv)',
                          'Image (*.png)',
                        ].map((option) {
                          return ListTile(
                            title: Text(option, style: TextStyle(fontSize: 14)),
                            leading: Radio<String>(
                              value: option,
                              groupValue: selectedOption,
                              onChanged: (value) {
                                export.add(true);
                                selectedOption = value!;
                              },
                            ),
                          );
                        }).toList(),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                _hideOverlay();
                              },
                              child: Text("Cancel", style: TextStyle(fontSize: 14)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print("Exporting as ${selectedOption ?? 'None'}");
                                _hideOverlay();
                              },
                              child: Text("Export", style: TextStyle(fontFamily: 'Roboto/Roboto-Thin.ttf', color: '#343A40'.toColor(), fontSize: 14)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  // ฟังก์ชันสำหรับเปิดหรือปิด Overlay
  void _toggleDropdown(BuildContext context) {
    if (isDropdownOpen) {
      _overlayEntry?.remove();
    } else {
      _overlayEntry = _showOverlay(context);
      Overlay.of(context)?.insert(_overlayEntry!);
    }
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  // ฟังก์ชันซ่อน Overlay
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
      link: _layerLink, // เชื่อมโยง LayerLink กับ CompositedTransformTarget
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: '#3C3C3C'.toColor(),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24), // ขนาดของปุ่ม
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // ความโค้งของมุม
          ),
          backgroundColor: '#FFFFFF'.toColor(),
        ),
        onPressed: () {
          _toggleDropdown(context);
        },

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Export", style: TextStyle(fontFamily: 'Roboto/Roboto-Thin.ttf', color: '#343A40'.toColor(), fontSize: 14)),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: '#343A40'.toColor(),
            ),
          ],
        ),
        // ),
      ),
      // ),
    );
  }
}
