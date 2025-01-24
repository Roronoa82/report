// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, unnecessary_null_comparison

import 'dart:async';

import 'package:develop_resturant/bloc/date_filter_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';

import '../bloc/date_filter_bloc.dart';
import '../bloc/date_filter_state.dart';
import 'custom_date_picker_dropdown.dart';

final logger = Logger();

class DropdownFilterButton extends StatefulWidget {
  final String? reportname;
  final DateTime? fromDate;
  final DateTime? toDate;
  final Function(Map<String, dynamic>) onDateSelected;
  final int initialSelectedReport;
  final Function(int) onReportSelected;

  DropdownFilterButton({
    Key? key,
    this.fromDate,
    this.toDate,
    required this.onDateSelected,
    required this.onReportSelected,
    required this.initialSelectedReport,
    this.reportname,
  }) : super(key: key);

  @override
  _DropdownFilterButtonState createState() => _DropdownFilterButtonState();
}

class _DropdownFilterButtonState extends State<DropdownFilterButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;
  StreamController<bool> export = StreamController.broadcast();
  late int selectedReport;
  String selectedMenu = 'Overall Summary';

  @override
  void initState() {
    super.initState();
    selectedReport = widget.initialSelectedReport;
    selectedMenu = widget.reportname ?? '';
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => StreamBuilder<bool>(
          stream: export.stream,
          builder: (context, snapshot) {
            return Positioned(
              width: 620,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: Offset(0, 55),
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
                    child: _buildDropdownContent(),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _toggleDropdown() {
    if (isDropdownOpen) {
      widget.onReportSelected;
      _overlayEntry?.remove();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  Widget _buildDropdownContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Report : ", style: TextStyle(fontWeight: FontWeight.normal)),
          SizedBox(width: 12),
          if (selectedMenu == 'Overall Summary')
            Row(children: [
              Radio<int>(
                value: 1,
                groupValue: selectedReport,
                onChanged: (selectedValue) {
                  export.add(true);
                  selectedReport = selectedValue!;
                  widget.onReportSelected(selectedReport);
                },
              ),
              SizedBox(width: 20),
              Text("Summary", style: TextStyle(fontFamily: 'Inter', color: '#3C3C3C'.toColor(), fontSize: 14, fontWeight: FontWeight.bold)),
              Text(" (Select up to 366 day)", style: TextStyle(fontFamily: 'Inter', color: '#959595'.toColor(), fontSize: 12)),
              SizedBox(width: 30),
            ]),
          // Daily
          Radio<int>(
            value: 2,
            groupValue: selectedReport,
            onChanged: (selectedValue) {
              export.add(true);

              selectedReport = selectedValue!;
              widget.onReportSelected(selectedReport);
            },
          ),
          SizedBox(width: 20),

          Text("Daily", style: TextStyle(fontFamily: 'Inter', color: '#3C3C3C'.toColor(), fontSize: 14, fontWeight: FontWeight.bold)),
          Text(" (Select up to 45 day)", style: TextStyle(fontFamily: 'Inter', color: '#959595'.toColor(), fontSize: 12)),
        ],
      ),
      Row(
        children: [
          SizedBox(width: 65),
          // Weekly
          Radio<int>(
            value: 3,
            groupValue: selectedReport,
            onChanged: (selectedValue) {
              export.add(true);

              selectedReport = selectedValue!;
              widget.onReportSelected(selectedReport);
            },
          ),
          SizedBox(width: 20),

          Text("Weekly", style: TextStyle(fontFamily: 'Inter', color: '#3C3C3C'.toColor(), fontSize: 14, fontWeight: FontWeight.bold)),
          Text(" (Select up to 30 Weeks)", style: TextStyle(fontFamily: 'Inter', color: '#959595'.toColor(), fontSize: 12)),
          SizedBox(width: 34),

          // Monthly
          Radio<int>(
            value: 4,
            groupValue: selectedReport,
            onChanged: (selectedValue) {
              export.add(true);

              selectedReport = selectedValue!;
              widget.onReportSelected(selectedReport);
            },
          ),
          SizedBox(width: 20),

          Text("Monthly", style: TextStyle(fontFamily: 'Inter', color: '#3C3C3C'.toColor(), fontSize: 14, fontWeight: FontWeight.bold)),
          Text(" (Select up to 12 Month)", style: TextStyle(fontFamily: 'Inter', color: '#959595'.toColor(), fontSize: 12)),
        ],
      ),
      SizedBox(height: 8),
      Divider(),
      BlocProvider<DateFilterBloc>(
          create: (_) => DateFilterBloc(
                widget.fromDate,
                widget.toDate,
              ),
          child: BlocListener<DateFilterBloc, DateFilterState>(
            listener: (context, state) {},
            child: BlocBuilder<DateFilterBloc, DateFilterState>(builder: (context, state) {
              return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'From:',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: '#4F4F4F'.toColor(),
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          width: 200,
                          child: CustomDatePickerDropdown(
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
                        ),
                        SizedBox(width: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'To:',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: '#4F4F4F'.toColor(),
                              ),
                            ),
                            SizedBox(width: 30),
                            Container(
                              width: 200,
                              child: CustomDatePickerDropdown(
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
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),

                    SizedBox(height: 8),
                    // Period (All Day & Custom)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Period :", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text("Clear all filters", style: TextStyle(color: Colors.red)),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _toggleDropdown,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontFamily: 'Inter', color: '#6C757D'.toColor()),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (state.fromDate != null && state.toDate != null) {
                                  widget.onReportSelected(selectedReport);
                                  if (selectedReport == 1) {
                                    // Summary
                                  } else if (selectedReport == 2) {
                                    // Daily
                                  } else if (selectedReport == 3) {
                                    // Weekly
                                  } else if (selectedReport == 4) {
                                    // Monthly
                                  }

                                  final filterData = {
                                    'filteredFromDate': DateFormat('yyyy-MM-dd').format(state.fromDate!),
                                    'filteredToDate': DateFormat('yyyy-MM-dd').format(state.toDate!),
                                  };
                                  widget.onDateSelected(filterData);
                                  logger.e(filterData);
                                  final onReportSelect = {
                                    'reportType': selectedReport,
                                  };
                                  logger.e(selectedReport);
                                  logger.e(onReportSelect);

                                  _toggleDropdown();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Please select both From and To dates'),
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: '#496EE2'.toColor(),
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ]));
            }),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: '#3C3C3C'.toColor(),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.007,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: '#FFFFFF'.toColor(),
        ),
        onPressed: _toggleDropdown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune,
              color: '#3C3C3C'.toColor(),
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              "Filters Report / Date",
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

  @override
  void dispose() {
    super.dispose();
  }
}
