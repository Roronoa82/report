// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:develop_resturant/screens/overall/deposit_report_page.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // นำเข้ามาเพื่อใช้งาน pw

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';

import 'bar_chart.dart';
import 'average_sale_perticket.dart';
import 'discounts.dart';
import 'payments_table.dart';
import 'sales_by_order_type.dart';
import 'sales_table.dart';
import 'summary_screen.dart';

final GlobalKey _key = GlobalKey();
final logger = Logger();

class DailyTableSection extends StatelessWidget {
  final dynamic getDate;

  DailyTableSection({required this.getDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: _key, // ใช้ GlobalKey เพื่อจับภาพ
          child: Column(children: [
            SizedBox(height: 16),
            Container(height: 400, child: LineChartSample()),
            SizedBox(height: 16),
            Container(
              child: DepositReportPage(
                key: ValueKey(getDate),
                selectDate: getDate,
              ),
            ),
            SizedBox(height: 16),
          ]),
        )
      ],
    );
  }

  Future<ui.Image> _capturePng() async {
    final RenderRepaintBoundary boundary = _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    return image;
  }

  Future<void> _printContent() async {
    final image = await _capturePng();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    await Printing.layoutPdf(
      onLayout: (format) async {
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            build: (context) {
              // ใช้ MemoryImage ในการแสดงผลภาพ
              return pw.Image(pw.MemoryImage(buffer));
            },
          ),
        );
        return pdf.save();
      },
    );
  }
}
