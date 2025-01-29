// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supercharged/supercharged.dart';

class MoreFilterMenu extends StatefulWidget {
  @override
  _MoreFilterMenuState createState() => _MoreFilterMenuState();
}

class _MoreFilterMenuState extends State<MoreFilterMenu> {
  StreamController<bool> export = StreamController.broadcast();
  String? selectedEmployee = "All Employees";
  String? selectedOrdertype;
  // String? selectedSource = "All Sources";
  String? selectedSource;

  String? selectedSection = "All Sections";

  final List<String> employees = [
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
  List<String> ordertypes = [
    'All Order Types',
    'Dine In',
    'Togo Phone',
    'Togo Walk In',
    'Delivery',
  ];
  List<String> sources = [
    'All Sources',
    'Smile Dining',
    'Smile Contactless (In House)',
    'Self-Kiosk (In House)',
    'Uber Eats',
    'Cavior',
    'Eat Street'
  ];
  List<String> sections = [
    'All Sections',
    'Sales',
    'Payments',
    'Deposits',
    'Credit Cards',
    'Cash In/Cash Out',
    'Service Charges',
    'Discounts',
    'Sales by Order Type',
    'Gift Cards',
    'Customers',
  ];
  GlobalKey _moreFilterKey = GlobalKey(); // GlobalKey for the button

  List<String> selectedEmployees = [];
  List<String> selectedOrdertypes = [];
  // List<String> selectedSources = [];
  List<String> selectedSources = [];
  List<String> selectedSections = [];
  List<String> isChecked = [];

  @override
  void initState() {
    super.initState();
    // for (var type in ordertypes) {
    //   isChecked[type] = false;
    // }
  }

  Future<void> _showFilterDialog() async {
    final RenderBox renderBox = _moreFilterKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final top = position.dy + renderBox.size.height;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(top: top * 0.37, left: 270, right: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.213,
            height: MediaQuery.of(context).size.height * 0.51,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'More Filters',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: '#000000'.toColor(), fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        export.add(true);

                        selectedEmployee = "All Employees";
                        selectedOrdertype = "All Order Types";
                        selectedSource = "All Sources";
                        selectedSection = "All Sections";
                      },
                      child: Text(
                        'Reset Filters',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 12, color: '#2F80ED'.toColor(), fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                _dropdownEmployee(),
                SizedBox(height: 8),
                _dropdownOrderType(),
                SizedBox(height: 8),
                _dropdownSource(),
                SizedBox(height: 12),
                _dropdownSection(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: '#00000033'.toColor(),
                            width: 1,
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(Size(150, 50)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: '#6C757D'.toColor(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all('#496EE2'.toColor()),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        minimumSize: MaterialStateProperty.all(Size(150, 50)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: '#FFFFFF'.toColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: _moreFilterKey,
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
      onPressed: () {
        _showFilterDialog();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/more_filter.svg',
            width: 12,
            height: 12,
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
    );
  }

  Widget _dropdownEmployee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textheaderdropdown(
          'Employees',
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: '#CED4DA'.toColor(), width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: '#000000B2'.toColor()),
              hint: Text(
                selectedEmployees.isEmpty ? "Select employees" : "${selectedEmployees.length} Selected",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor()),
              ),
              items: employees.map((employee) {
                return DropdownMenuItem<String>(
                  value: employee,
                  child: StatefulBuilder(
                    builder: (context, setStateEmployee) {
                      final isSelected = selectedEmployees.contains(employee);
                      return CheckboxListTile(
                        title: Text(employee, style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor())),
                        value: isSelected,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: '#496EE2'.toColor(),
                        onChanged: (bool? value) {
                          setStateEmployee(() {
                            if (employee == employees.first) {
                              if (value == true) {
                                selectedEmployees = List.from(employees);
                              } else {
                                selectedEmployees.clear();
                              }
                            } else {
                              if (value == true) {
                                selectedEmployees.add(employee);
                                if (selectedEmployees.length == employees.length - 1) {
                                  selectedEmployees.insert(0, employees.first);
                                }
                              } else {
                                selectedEmployees.remove(employee);
                                selectedEmployees.remove(employees.first);
                              }
                            }
                          });
                          export.add(true);
                        },
                      );
                    },
                  ),
                );
              }).toList(),
              onChanged: (_) {},
              dropdownColor: Colors.white,
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownOrderType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textheaderdropdown(
          'Order Types',
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: '#CED4DA'.toColor(), width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: '#000000B2'.toColor()),
              hint: Text(
                selectedOrdertypes.isEmpty ? "Select ordertypes" : "${selectedOrdertypes.length} Selected",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor()),
              ),
              items: ordertypes.map((ordertype) {
                return DropdownMenuItem<String>(
                  value: ordertype,
                  child: StatefulBuilder(
                    builder: (context, setStateOrdertype) {
                      final isSelected = selectedOrdertypes.contains(ordertype);
                      return CheckboxListTile(
                        title: Text(ordertype, style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor())),
                        value: isSelected,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: '#496EE2'.toColor(),
                        onChanged: (bool? value) {
                          setStateOrdertype(() {
                            if (ordertype == ordertypes.first) {
                              if (value == true) {
                                selectedOrdertypes = List.from(ordertypes);
                              } else {
                                selectedOrdertypes.clear();
                              }
                            } else {
                              if (value == true) {
                                selectedOrdertypes.add(ordertype);
                                if (selectedOrdertypes.length == ordertypes.length - 1) {
                                  selectedOrdertypes.insert(0, ordertypes.first);
                                }
                              } else {
                                selectedOrdertypes.remove(ordertype);
                                selectedOrdertypes.remove(ordertypes.first);
                              }
                            }
                          });
                          export.add(true);
                        },
                      );
                    },
                  ),
                );
              }).toList(),
              onChanged: (_) {},
              dropdownColor: Colors.white,
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownSource() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textheaderdropdown(
          'Source of Revenue',
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: '#CED4DA'.toColor(), width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: '#000000B2'.toColor()),
              hint: Text(
                selectedSources.isEmpty ? "Select Sources" : "${selectedSources.length} Selected",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor()),
              ),
              items: sources.map((source) {
                return DropdownMenuItem<String>(
                  value: source,
                  child: StatefulBuilder(
                    builder: (context, setStateItem) {
                      final isSelected = selectedSources.contains(source);
                      return CheckboxListTile(
                        title: Text(source, style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor())),
                        value: isSelected,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: '#496EE2'.toColor(),
                        onChanged: (bool? value) {
                          setStateItem(() {
                            if (source == sources.first) {
                              if (value == true) {
                                selectedSources = List.from(sources);
                              } else {
                                selectedSources.clear();
                              }
                            } else {
                              if (value == true) {
                                selectedSources.add(source);
                                if (selectedSources.length == sources.length - 1) {
                                  selectedSources.insert(0, sources.first);
                                }
                              } else {
                                selectedSources.remove(source);
                                selectedSources.remove(sources.first);
                              }
                            }
                          });
                          export.add(true);
                        },
                      );
                    },
                  ),
                );
              }).toList(),
              onChanged: (_) {},
              dropdownColor: Colors.white,
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text(
          'Show/Hide',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        textheaderdropdown(
          'Show/Hide Sections',
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: '#CED4DA'.toColor(), width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: '#000000B2'.toColor()),
              hint: Text(
                selectedSections.isEmpty ? "Select sections" : "${selectedSections.length} Selected",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor()),
              ),
              items: sections.map((section) {
                return DropdownMenuItem<String>(
                  value: section,
                  child: StatefulBuilder(
                    builder: (context, setStateSection) {
                      final isSelected = selectedSections.contains(section);
                      return CheckboxListTile(
                        title: Text(section, style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: '#6C757D'.toColor())),
                        value: isSelected,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: '#496EE2'.toColor(),
                        onChanged: (bool? value) {
                          setStateSection(() {
                            if (section == sections.first) {
                              // ถ้าเลือก "All Sections"
                              if (value == true) {
                                selectedSections = List.from(sections);
                              } else {
                                selectedSections.clear();
                              }
                            } else {
                              // เลือก Section ปกติ
                              if (value == true) {
                                selectedSections.add(section);
                                if (selectedSections.length == sections.length - 1) {
                                  selectedSections.insert(0, sections.first);
                                }
                              } else {
                                selectedSections.remove(section);
                                selectedSections.remove(sections.first);
                              }
                            }
                          });
                          setState(() {});
                        },
                      );
                    },
                  ),
                );
              }).toList(),
              onChanged: (_) {},
              dropdownColor: Colors.white,
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Text textheaderdropdown(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: '#000000'.toColor(),
      ),
    );
  }
}
