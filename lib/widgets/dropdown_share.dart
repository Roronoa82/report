// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:supercharged/supercharged.dart';
import 'package:pdf/widgets.dart' as pw;

class ShareMenu extends StatefulWidget {
  @override
  _ShareMenuState createState() => _ShareMenuState();
}

class _ShareMenuState extends State<ShareMenu> {
  final LayerLink _layerLink = LayerLink();
  bool isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();
  OverlayEntry _showOverlay(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.19,
        height: MediaQuery.of(context).size.height * 0.18,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(-135, 60),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.only(top: 8, left: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share with',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: '#000000'.toColor(), fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Row(
                      children: [
                        _buildShareOption(
                          icon: Icons.email_outlined,
                          label: "Email",
                          onTap: () {
                            _hideOverlay();
                          },
                        ),
                        SizedBox(width: 30),
                        Column(
                          children: [
                            Image.asset(
                              'assets/iconline.png',
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'LINE',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: '#3C3C3C'.toColor()),
                            )
                          ],
                        ),
                        SizedBox(width: 30),
                        _buildShareOption(
                          icon: Icons.print_outlined,
                          label: "Print",
                          onTap: () async {
                            _hideOverlay();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
          Icon(icon, size: 70, color: '#000000A6'.toColor()),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: '#3C3C3C'.toColor()),
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
      Overlay.of(context).insert(_overlayEntry!);
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
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.009,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: '#FFFFFF'.toColor(),
        ),
        onPressed: () {
          _toggleDropdown(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Share", style: TextStyle(color: '#343A40'.toColor(), fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.w400)),
            Icon(Icons.keyboard_arrow_down_rounded, color: '#343A400'.toColor()),
          ],
        ),
      ),
    );
  }
}
