// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:supercharged/supercharged.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:getwidget/getwidget.dart';

class MoreFilterMenu extends StatefulWidget {
  @override
  _MoreFilterMenuState createState() => _MoreFilterMenuState();
}

class _MoreFilterMenuState extends State<MoreFilterMenu> {
  StreamController<bool> export = StreamController.broadcast();

  List<String> employees = [
    'All Employees',
    'Lucas Anderson',
    'Amelia Wilson',
    'Nongnuch Jitdee',
    'James Torres',
    'Oliver Young',
    'Liam Nguyen',
    'Emma Miller',
    'Ava Martin'
  ];
  List<String> ordertype = [
    'All Order Types',
    'Dine In',
    'Togo Phone',
    'Togo Walk In',
    'Delivery',
  ];
  Map<String, bool> selectedEmployees = {};
  @override
  void initState() {
    super.initState();
    for (var employee in employees) {
      selectedEmployees[employee] = false;
    }
  }

  final LayerLink _layerLink = LayerLink();
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();
  OverlayEntry _showOverlay(BuildContext context) {
    return OverlayEntry(
      builder: (context) => StreamBuilder<bool>(
          stream: export.stream,
          builder: (context, snapshot) {
            return Positioned(
              width: 350,
              height: 450,
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...employees.map(
                            (employee) => CheckboxListTile(
                              title: Text(employee),
                              value: selectedEmployees[employee],
                              onChanged: (bool? value) {
                                export.add(true);
                                selectedEmployees[employee] = value ?? false;
                                // });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  export.add(true);
                                  for (var key in selectedEmployees.keys) {
                                    selectedEmployees[key] = false;
                                  }
                                  // });
                                },
                                child: Text("Reset"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _hideOverlay();
                                },
                                child: Text("Apply"),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<void> _printContent() async {
    await Printing.layoutPdf(
      onLayout: (format) async {
        final pdf = pw.Document();

        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Column(
                children: [
                  pw.Text('รายงานสรุป', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text('ข้อมูลจาก SummaryTableSection'),
                  pw.SizedBox(height: 20),
                ],
              );
            },
          ),
        );
        return pdf.save();
      },
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 50, color: '#3C3C3C'.toColor()),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: '#3C3C3C'.toColor()),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันเปิดหรือปิด Overlay
  void _toggleDropdown(BuildContext context) {
    if (isDropdownOpen) {
      _hideOverlay();
    } else {
      _overlayEntry = _showOverlay(context);
      Overlay.of(context)?.insert(_overlayEntry!);
      setState(() {
        isDropdownOpen = true;
      });
    }
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
        onPressed: () {
          _toggleDropdown(context);
        },
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
