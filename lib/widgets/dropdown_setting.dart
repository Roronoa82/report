import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class SettingMenu extends StatefulWidget {
  @override
  _SettingMenuState createState() => _SettingMenuState();
}

class _SettingMenuState extends State<SettingMenu> {
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;

  // Options for settings
  final Map<String, bool> settings = {
    "Sales": true,
    "Food": true,
    "Liquor": true,
    "Net Sales": true,
    "Taxes": false,
    "Total Sales": false,
  };

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (context) => Center(
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Setting",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: '#3C3C3C'.toColor(),
                  ),
                ),
                SizedBox(height: 20),
                ...settings.keys.map((key) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // สีพื้นหลังของปุ่ม
                      borderRadius: BorderRadius.circular(8), // มุมโค้งมน
                      border: Border.all(color: Colors.grey, width: 1), // เส้นขอบของปุ่ม
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          key,
                          style: TextStyle(fontSize: 16, color: '#3C3C3C'.toColor()),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              settings[key] = !(settings[key] ?? false);
                            });
                            _overlayEntry?.markNeedsBuild(); // Rebuild overlay for updates
                          },
                          child: Container(
                            width: 50,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: (settings[key] ?? false) ? Colors.blue : Colors.grey[300],
                            ),
                            child: AnimatedAlign(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              alignment: (settings[key] ?? false) ? Alignment.centerRight : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _hideOverlay,
                      child: Text("Close"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("Settings: $settings");
                        _hideOverlay();
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
