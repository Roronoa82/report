// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomDatePickerDropdown extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  CustomDatePickerDropdown({required this.initialDate, required this.onDateSelected});
  @override
  _CustomDatePickerDropdownState createState() => _CustomDatePickerDropdownState();
}

class _CustomDatePickerDropdownState extends State<CustomDatePickerDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isOverlayOpen = false;

  DateTime? _selectedDate;

  // สร้าง Overlay สำหรับ DatePicker
  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200, // ความกว้างของ DatePicker
        height: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, 50), // ตำแหน่งที่ DatePicker จะปรากฏ (ด้านล่างของ TextField)
          showWhenUnlinked: false,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
                onDateChanged: (pickedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                    widget.onDateSelected(_selectedDate!);
                  });
                  _toggleOverlay(); // ปิด Overlay หลังเลือกวันที่
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

// เปิดหรือปิด Overlay
  void _toggleOverlay() {
    if (isOverlayOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _createOverlayEntry(context);

      // เลื่อนการแทรก Overlay ไปยัง frame ถัดไป
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Overlay.of(context)?.insert(_overlayEntry!);
        }
      });
    }
    setState(() {
      isOverlayOpen = !isOverlayOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        readOnly: true,
        controller: TextEditingController(
          text: _selectedDate != null
              ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
              : "",
        ),
        decoration: InputDecoration(
          hintText: "Select Date",
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: _toggleOverlay, // เปิด/ปิด DatePicker
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
