// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:develop_resturant/bloc/date_filter_event.dart';
import 'package:develop_resturant/widgets/custom_date_picker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../bloc/date_filter_bloc.dart';
import '../bloc/date_filter_state.dart';

class DropdownFilterButton extends StatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final Function(Map<String, dynamic>) onDateSelected;
  DropdownFilterButton({this.fromDate, this.toDate, required this.onDateSelected});

  @override
  _DropdownFilterButtonState createState() => _DropdownFilterButtonState();
}

class _DropdownFilterButtonState extends State<DropdownFilterButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;

  // Function สำหรับสร้าง Overlay
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 400,
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
              child: _buildDropdownContent(), // เนื้อหา Dropdown
            ),
          ),
        ),
      ),
    );
  }

  // Function สำหรับเปิดหรือปิด Dropdown
  void _toggleDropdown() {
    if (isDropdownOpen) {
      _overlayEntry?.remove();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  // เนื้อหา Dropdown
  Widget _buildDropdownContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Report (Radio Buttons)
        Text("Report", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Radio(value: 1, groupValue: 1, onChanged: (val) {}),
            Text("Summary"),
            Radio(value: 2, groupValue: 1, onChanged: (val) {}),
            Text("Daily"),
          ],
        ),
        Row(
          children: [
            Radio(value: 3, groupValue: 1, onChanged: (val) {}),
            Text("Weekly"),
            Radio(value: 4, groupValue: 1, onChanged: (val) {}),
            Text("Monthly"),
          ],
        ),

        SizedBox(height: 8),

        // Text("From - To", style: TextStyle(fontWeight: FontWeight.bold)),
        BlocProvider<DateFilterBloc>(
          create: (_) => DateFilterBloc(
            widget.fromDate,
            widget.toDate,
          ),
          child: BlocListener<DateFilterBloc, DateFilterState>(
            listener: (context, state) {},
            child: BlocBuilder<DateFilterBloc, DateFilterState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From:'),
                                CustomDatePickerDropdown(
                                  initialDate: state.fromDate,
                                  onDateSelected: (selectedDate) {
                                    context.read<DateFilterBloc>().add(
                                          UpdateDateRange(
                                            fromDate: selectedDate,
                                            toDate: state.toDate,
                                          ),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('To:'),
                                CustomDatePickerDropdown(
                                  initialDate: state.toDate,
                                  onDateSelected: (selectedDate) {
                                    context.read<DateFilterBloc>().add(
                                          UpdateDateRange(
                                            fromDate: state.fromDate,
                                            toDate: selectedDate,
                                          ),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (state.fromDate != null && state.toDate != null) {
                            final filterData = {
                              'filteredFromDate': DateFormat('yyyy-MM-dd').format(state.fromDate!),
                              'filteredToDate': DateFormat('yyyy-MM-dd').format(state.toDate!),
                            };
                            widget.onDateSelected(filterData);
                            _toggleDropdown();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select both From and To dates'),
                            ));
                          }
                        },
                        child: Text('Apply'),

                        // child: DateFilterPage(
                        //   onFilterApplied: (filterData) {
                        //     print('Filtered From: ${filterData['filteredFromDate']}');
                        //     print('Filtered To: ${filterData['filteredToDate']}');
                        //     widget.onDateSelected(filterData);
                        //     _toggleDropdown(); // ปิด Dropdown เมื่อ Apply
                        //   },
                        // ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: 8),
        // Period (All Day & Custom)
        Text("Period", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Radio(value: true, groupValue: true, onChanged: (val) {}),
            Text("All Day"),
            Radio(value: false, groupValue: true, onChanged: (val) {}),
            Text("Custom"),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: "Start Time"),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: "End Time"),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        // Buttons (Clear, Cancel, Apply)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text("Clear all filters", style: TextStyle(color: Colors.red)),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: _toggleDropdown, // ปิด Dropdown
                  child: Text("Cancel"),
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ElevatedButton.icon(
        label: Text("Filters Report / Date"),
        icon: Icon(Icons.keyboard_arrow_down),
        onPressed: _toggleDropdown,
      ),
    );
  }

  @override
  void dispose() {
    // ตรวจสอบว่า _overlayEntry ไม่เป็น null ก่อนที่จะลบ
    // if (_overlayEntry != null) {
    //   _overlayEntry?.remove(); // เคลียร์ Overlay ตอนปิด Widget
    // }
    super.dispose();
  }
}

final logger = Logger();

// class DateFilterPage extends StatelessWidget {
//   final Function(Map<String, dynamic>) onFilterApplied;
//   DateFilterPage({
//     Key? key,
//     required this.onFilterApplied,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DateFilterBloc, DateFilterState>(
//       listener: (context, state) {
//         // logger.e("Updated From Date: ${state.fromDate}");
//         // logger.e("Updated To Date: ${state.toDate}");
//       },
//       child: BlocBuilder<DateFilterBloc, DateFilterState>(
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Dropdown สำหรับเลือก From Date
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('From:'),
//                           CustomDatePickerDropdown(
//                             initialDate: state.fromDate,
//                             onDateSelected: (selectedDate) {
//                               // logger.f('Selected From Date: $selectedDate');
//                               // อัปเดตสถานะ From Date ผ่าน Bloc
//                               context.read<DateFilterBloc>().add(
//                                     UpdateDateRange(
//                                       fromDate: selectedDate,
//                                       toDate: state.toDate,
//                                     ),
//                                   );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     // Dropdown สำหรับเลือก To Date
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('To:'),
//                           CustomDatePickerDropdown(
//                             initialDate: state.toDate,
//                             onDateSelected: (selectedDate) {
//                               // logger.f('Selected To Date: $selectedDate'); // Log วันที่ที่เลือก
//                               context.read<DateFilterBloc>().add(
//                                     UpdateDateRange(
//                                       fromDate: state.fromDate,
//                                       toDate: selectedDate,
//                                     ),
//                                   );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (state.fromDate != null && state.toDate != null) {
//                       final filterData = {
//                         'filteredFromDate': DateFormat('yyyy-MM-dd').format(state.fromDate!),
//                         'filteredToDate': DateFormat('yyyy-MM-dd').format(state.toDate!),
//                       };
//                       // logger.d('Filter Data: $filterData'); // Log ข้อมูลที่จะส่งไปยัง onFilterApplied
//                       onFilterApplied(filterData);
//                       // logger.d('Filter Applied Successfully');
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('Please select both From and To dates'),
//                       ));
//                     }
//                   },
//                   child: Text('Apply'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
