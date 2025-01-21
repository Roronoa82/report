// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class SettingMenu extends StatefulWidget {
  @override
  _SettingMenuState createState() => _SettingMenuState();
}

class _SettingMenuState extends State<SettingMenu> {
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final StreamController<String> _widgetController = StreamController<String>.broadcast();
  bool isSalesActive = true;
  StreamController<bool> export = StreamController.broadcast();
  bool isFoodActive = true; // กำหนดสถานะเริ่มต้น
  bool isLiquorActive = false; // กำหนดสถานะเริ่มต้น

  // Options for settings
  Map<String, bool> salesOptions = {
    "Food": true,
    "Liquor": true,
    "Net Sales": true,
    "Taxes": false,
    "Total Sales": false,
  };

  Map<String, bool> salesbyordertype = {
    "Dine in": true,
    "Togo": false,
    "Delivery": true,
  };
  Map<String, bool> payments = {
    "Cash": true,
    "Check": true,
    "Coupon": true,
    "3rd Party": true,
    "Credit (EMV)": true,
    "Credit (Clover Flex)": true,
    "Smile Dining": true,
    "Smile Contactless (On Table)": true,
  };
  Map<String, bool> servicechargeandfee = {
    "Service Charge": true,
    "Gratuity": true,
    "Online Custom Charge": true,
    "Contactless Custom Charge": true,
    "Smile POS Auto Charge": true,
    "Delivery": true,
    "Others": true,
    "Utensils": true,
    "Marketing Serviec Fee": true,
    "Credit Card Fee": true,
  };
  Map<String, bool> giftcertificate = {
    "Gift Sales": true,
    "Gift Redeem": false,
    "E-Gift Sales": false,
  };
  Map<String, bool> checkboxValues = {
    "Cash In": true,
    "Gift Other": false,
    "Cash Out": true,
    "Check Change": false,
    "Gift Refund": true,
  };

  // สถานะของ Percentage Inputs
  Map<String, String> percentageValues = {
    "Gratuity": "0.00",
    "Credit Card Tip": "3.00",
    "Prepaid Tip": "3.00",
    "Prepaid Gift Card Tip": "3.00",
    "Coupon Tip": "3.00",
    "Clover Flex Tip": "3.00",
    "Deliverly Charge": "3.00",
  };

  @override
  void initState() {
    super.initState();
    _widgetController.add('Sales');
  }

  @override
  void dispose() {
    _widgetController.close();
    super.dispose();
  }

  void toggleOption(String option, bool value) {
    (value) {
      salesOptions[option] = value;
      isSalesActive = salesOptions.containsValue(true);
    };
    export.add(true); // ส่งค่าผ่าน StreamController
  }

  void toggleAll(bool value) {
    (value) {
      salesOptions.updateAll((key, _) => value);
      isSalesActive = value;
    };
    export.add(value); // ส่งค่าผ่าน StreamController
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (context) => StreamBuilder<bool>(
          stream: export.stream,
          initialData: isSalesActive,
          builder: (context, snapshot) {
            return Center(
              child: Material(
                color: Colors.black54, // Background overlay
                child: Container(
                  width: 812,
                  height: 818,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ส่วนหัว Setting
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.settings,
                            size: 30,
                            color: '#000000B2'.toColor(),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Setting",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: '#000000B2'.toColor(),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey),
                            onPressed: _hideOverlay,
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Expanded(
                        child: Row(children: [
                          // Sidebar
                          Container(
                            width: 200,
                            color: '#FFFFFF'.toColor(),
                            child: Column(
                              children: [
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Sales'),
                                    onTap: () {
                                      _widgetController.add('Sales');
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Sales by Order Type'),
                                    onTap: () {
                                      _widgetController.add('Sales by Order Type');
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Payments'),
                                    onTap: () {
                                      _widgetController.add('Payments');
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Service Charge & Fee'),
                                    onTap: () {
                                      _widgetController.add('Service Charge & Fee');
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Gift Certificate'),
                                    onTap: () {
                                      _widgetController.add('Gift Certificate');
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Discount'),
                                    onTap: () {
                                      _widgetController.add('Discount');
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Cash In-Out'),
                                    onTap: () {
                                      _widgetController.add('Cash In-Out');
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                _decorationcustom(
                                  child: ListTile(
                                    title: _textsubHeader('Cash Deposit'),
                                    onTap: () {
                                      _widgetController.add('Cash Deposit');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                            width: 1,
                            color: '#00000033'.toColor(),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Center(
                              child: Expanded(
                            child: StreamBuilder<String>(
                              stream: _widgetController.stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return _Salesswitch();
                                }
                                switch (snapshot.data) {
                                  case 'Sales':
                                    return _Salesswitch();
                                  case 'Sales by Order Type':
                                    return _SalesByOrderTypeswitch();
                                  case 'Payments':
                                    return _Payments();
                                  case 'Service Charge & Fee':
                                    return _ServiceChargeAndFee();
                                  case 'Gift Certificate':
                                    return _GiftCertificate();
                                  case 'Discount':
                                    return _Discounts();
                                  case 'Cash In-Out':
                                    return _CashInOut();
                                  case 'Cash Deposit':
                                    return _CashDeposit();
                                  default:
                                    return Container();
                                }
                              },
                            ),
                          )),
                          // ),
                        ]),
                      ),
                      Divider(color: '#00000033'.toColor(), thickness: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _hideOverlay,
                              child: Text("Close",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    color: '#8B8B8B'.toColor(),
                                  )),
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            TextButton(
                              onPressed: () {
                                // Save logic here
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Settings saved!")));
                                _hideOverlay();
                              },
                              child: Text("Save",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    color: '#2A68FB'.toColor(),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _Salesswitch() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8), // เพิ่ม padding ถ้าต้องการ
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _decorationcustom(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  _textHeader('Sales'),
                  Expanded(
                    child: Container(),
                  ),
                  Switch(
                    activeColor: '#FFFFFF'.toColor(),
                    activeTrackColor: '#0D6EFD'.toColor(),
                    inactiveThumbColor: '#FFFFFF'.toColor(),
                    inactiveTrackColor: '#C6C6C6'.toColor(),
                    value: isSalesActive,
                    onChanged: (value) {
                      export.add(true);
                      isSalesActive = value;
                    },
                  ),
                  _textstatusHeader(
                    isSalesActive ? "Active" : "Deactive",
                    // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          buildSwitchList(salesOptions, toggleOption, isSalesActive),
        ],
      ),
    );
  }

  Widget _SalesByOrderTypeswitch() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _decorationcustom(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  _textHeader("Sales by Order Type"),
                  Expanded(
                    child: Container(),
                  ),
                  Switch(
                    activeColor: '#FFFFFF'.toColor(),
                    activeTrackColor: '#0D6EFD'.toColor(),
                    inactiveThumbColor: '#FFFFFF'.toColor(),
                    inactiveTrackColor: '#C6C6C6'.toColor(),
                    value: isSalesActive,
                    onChanged: (value) {
                      export.add(true);
                      isSalesActive = value;
                    },
                  ),
                  _textstatusHeader(
                    isSalesActive ? "Active" : "Deactive",
                    // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          buildSwitchList(salesbyordertype, toggleOption, isSalesActive),
        ],
      ),
    );
  }

  Widget _Payments() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _decorationcustom(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  _textHeader("Payments"),
                  Expanded(
                    child: Container(),
                  ),
                  Switch(
                    activeColor: '#FFFFFF'.toColor(),
                    activeTrackColor: '#0D6EFD'.toColor(),
                    inactiveThumbColor: '#FFFFFF'.toColor(),
                    inactiveTrackColor: '#C6C6C6'.toColor(),
                    value: isSalesActive,
                    onChanged: (value) {
                      export.add(true);
                      isSalesActive = value;
                    },
                  ),
                  _textstatusHeader(
                    isSalesActive ? "Active" : "Deactive",
                    // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          buildSwitchList(payments, toggleOption, isSalesActive),
        ],
      ),
    );
  }

  Widget _ServiceChargeAndFee() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _decorationcustom(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Row(
                  children: [
                    _textHeader("Service Charge & Fee"),
                    Expanded(
                      child: Container(),
                    ),
                    Switch(
                      activeColor: '#FFFFFF'.toColor(),
                      activeTrackColor: '#0D6EFD'.toColor(),
                      inactiveThumbColor: '#FFFFFF'.toColor(),
                      inactiveTrackColor: '#C6C6C6'.toColor(),
                      value: isSalesActive,
                      onChanged: (value) {
                        export.add(true);
                        isSalesActive = value;
                      },
                    ),
                    _textstatusHeader(
                      isSalesActive ? "Active" : "Deactive",
                      // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            buildSwitchList(servicechargeandfee, toggleOption, isSalesActive),
          ],
        ),
      ),
    );
  }

  Widget _GiftCertificate() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _decorationcustom(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  _textHeader("Gift Certificate"),
                  Expanded(
                    child: Container(),
                  ),
                  Switch(
                    activeColor: '#FFFFFF'.toColor(),
                    activeTrackColor: '#0D6EFD'.toColor(),
                    inactiveThumbColor: '#FFFFFF'.toColor(),
                    inactiveTrackColor: '#C6C6C6'.toColor(),
                    value: isSalesActive,
                    onChanged: (value) {
                      export.add(true);
                      isSalesActive = value;
                    },
                  ),
                  _textstatusHeader(
                    isSalesActive ? "Active" : "Deactive",
                    // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          buildSwitchList(giftcertificate, toggleOption, isSalesActive),
        ],
      ),
    );
  }

  Widget _Discounts() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _decorationcustom(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  _textHeader("Discount"),
                  Expanded(
                    child: Container(),
                  ),
                  Switch(
                    activeColor: '#FFFFFF'.toColor(),
                    activeTrackColor: '#0D6EFD'.toColor(),
                    inactiveThumbColor: '#FFFFFF'.toColor(),
                    inactiveTrackColor: '#C6C6C6'.toColor(),
                    value: isSalesActive,
                    onChanged: (value) {
                      export.add(true);
                      isSalesActive = value;
                    },
                  ),
                  _textstatusHeader(
                    isSalesActive ? "Active" : "Deactive",
                    // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          // buildSwitchList(discount, toggleOption, isSalesActive),
        ],
      ),
    );
  }

  Widget _CashInOut() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _decorationcustom(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  _textHeader("Cash In-Out"),
                  Expanded(
                    child: Container(),
                  ),
                  Switch(
                    activeColor: '#FFFFFF'.toColor(),
                    activeTrackColor: '#0D6EFD'.toColor(),
                    inactiveThumbColor: '#FFFFFF'.toColor(),
                    inactiveTrackColor: '#C6C6C6'.toColor(),
                    value: isSalesActive,
                    onChanged: (value) {
                      export.add(true);
                      isSalesActive = value;
                    },
                  ),
                  _textstatusHeader(
                    isSalesActive ? "Active" : "Deactive",
                    // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          // buildSwitchList(cashinout, toggleOption, isSalesActive),
        ],
      ),
    );
  }

  Widget _CashDeposit() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _decorationcustom(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Row(
                children: [
                  _textHeader("Cash Deposit"),
                  Expanded(
                    child: Container(),
                  ),
                  Switch(
                    activeColor: '#FFFFFF'.toColor(),
                    activeTrackColor: '#0D6EFD'.toColor(),
                    inactiveThumbColor: '#FFFFFF'.toColor(),
                    inactiveTrackColor: '#C6C6C6'.toColor(),
                    value: isSalesActive,
                    onChanged: (value) {
                      export.add(true);
                      isSalesActive = value;
                    },
                  ),
                  _textstatusHeader(
                    isSalesActive ? "Active" : "Deactive",
                    // style: TextStyle(fontSize: 16, color: isSalesActive ? '#000000B2'.toColor() : '#000000B2'.toColor()),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // สูตรคำนวณ
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "CASH DEPOSIT = (Cash Sales + Cash In - Cash Out - Gift Refund\n- Gift Other - Check Change - Gratuity(100%) - Credit Card Tip(97%)\n- Prepaid Tip(97%) - Prepaid Gift Tip(97%) - Coupon Tip(97%)\n- Clover Flex Tip(100%) - Deposit CashN + Deposit CashP)",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 16),
                // Checkbox Group
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: checkboxValues.keys.map((key) {
                    return _checkboxWithLabel(
                      label: key,
                      value: checkboxValues[key]!,
                      onValueChanged: (newValue) {
                        if (newValue != null) {
                          export.add(true);
                          checkboxValues[key] = newValue;
                        }
                      },
                    );
                  }).toList(),
                ),

                Divider(height: 32, thickness: 1),
                _textstatusHeader(
                  "Reserve fee to merchant",
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: percentageValues.keys.map((key) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: percentageValues[key] == 'true', // แปลงค่า String เป็น bool
                          onChanged: (bool? newValue) {
                            export.add(true);
                            // อัพเดตค่าใน percentageValues ให้เป็น String
                            percentageValues[key] = newValue != null ? newValue.toString() : 'false';
                          },
                        ),
                        _percentageInput(
                          label: key,
                          value: percentageValues[key]!,
                          onChanged: (newValue) {
                            export.add(true);
                            percentageValues[key] = newValue;
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitchList(Map<String, bool> options, Function(String, bool) onToggle, bool isEnabled) {
    return _decorationcustom(
        child: Column(
      children: options.keys.map((key) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0), // เพิ่ม Padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: isEnabled ? 1.0 : 0.5,
                child: _textsubHeader(key),
              ),
              Opacity(
                opacity: isEnabled ? 1.0 : 0.5,
                child: GestureDetector(
                    onTap: isEnabled ? () => onToggle(key, !options[key]!) : null,
                    child: Switch(
                      activeColor: '#FFFFFF'.toColor(),
                      activeTrackColor: '#0D6EFD'.toColor(),
                      inactiveThumbColor: '#FFFFFF'.toColor(),
                      inactiveTrackColor: '#C6C6C6'.toColor(),
                      value: options[key]!,
                      onChanged: isEnabled
                          ? (value) {
                              options[key] = value;
                              onToggle(key, value);
                              export.add(true);
                            }
                          : null,
                    )),
              ),
            ],
          ),
        );
      }).toList(),
    ));
  }

  Widget _checkboxWithLabel({
    required String label,
    required bool value,
    required ValueChanged<bool?> onValueChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onValueChanged,
          activeColor: '#0D6EFD'.toColor(),
        ),
        _textsubHeader(label),
      ],
    );
  }

// Helper Widget สำหรับ Percentage Input
  Widget _percentageInput({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        _textsubHeader(label),
        const SizedBox(width: 8),
        Container(
          width: 60,
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            controller: TextEditingController(text: value),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _decorationcustom({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: '#FFFFFF'.toColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: '#C3C3C3'.toColor(), width: 1),
      ),
      child: child,
    );
  }

  Widget _textHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w500, color: '#000000B2'.toColor()),
    );
  }

  Widget _textsubHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500, color: '#000000B2'.toColor()),
    );
  }

  Widget _textstatusHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500, color: '#000000B2'.toColor()),
    );
  }

  void _toggleDropdown() {
    if (isDropdownOpen) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return; // ป้องกันการสร้างซ้ำ
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      isDropdownOpen = true;
    });
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        isDropdownOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: '#FFFFFF'.toColor(),
      ),
      onPressed: _toggleDropdown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings, color: '#3C3C3C'.toColor()),
          SizedBox(width: 8),
          Text(
            "Setting",
            style: TextStyle(
              fontFamily: 'Inter',
              color: '#3C3C3C'.toColor(),
            ),
          ),
        ],
      ),
    );
  }
}
