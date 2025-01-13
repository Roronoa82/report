// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';

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
        width: 300, // ความกว้างของ DatePicker
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
                initialDate: _selectedDate ?? DateTime(2023),
                firstDate: DateTime(2020),
                lastDate: DateTime(2026),
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
      child: Container(
        height: 38,
        child: TextFormField(
          textAlign: TextAlign.start,
          readOnly: true,
          controller: TextEditingController(
            text: _selectedDate != null
                ? "${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}"
                : "",
          ),
          decoration: InputDecoration(
            hintText: _selectedDate != null
                ? "${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}"
                : "${DateTime(2023).year}/${DateTime(08, 08).month.toString().padLeft(2, '0')}/${DateTime(01, 31).day.toString().padLeft(2, '0')}",
            suffixIcon: Padding(
              padding: EdgeInsetsDirectional.all(8),
              child: FaIcon(
                FontAwesomeIcons.solidCalendarDays,
                color: '#2F80ED'.toColor(),
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: '#00000033'.toColor(), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: '#00000033'.toColor(), width: 1.0),
            ),
          ),
          onTap: _toggleOverlay, // เปิด/ปิด DatePicker
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
