// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // นำเข้ามาเพื่อใช้งาน pw

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';

import 'line_chart_page.dart';
import 'average_sale_perticket.dart';
import 'discounts.dart';
import 'payments_table.dart';
import 'sales_by_order_type.dart';
import 'sales_table.dart';
import 'summary_screen.dart';

final GlobalKey _key = GlobalKey();
final logger = Logger();

class SummaryTableSection extends StatelessWidget {
  final dynamic getDate;

  SummaryTableSection({required this.getDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: _key, // ใช้ GlobalKey เพื่อจับภาพ
          child: Column(children: [
            SizedBox(height: 16),
            Container(height: MediaQuery.of(context).size.height * 0.346, child: LineChartPage()),
            SizedBox(height: 16),
            Container(
              child: SalesTable(
                key: ValueKey(getDate),
                selectDate: getDate,
              ),
            ),
            SizedBox(height: 16),
            Container(
              // color: '#EEEEEE'.toColor(),
              height: MediaQuery.of(context).size.height * 0.4,
              child: PaymentsTable(
                key: ValueKey(getDate),
                selectDate: getDate,
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: SummaryScreen(
                  showDepositsOnly: 1,
                  key: ValueKey(getDate),
                  selectDate: getDate,
                )),
            Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: '#868E96'.toColor(),
                child: SummaryScreen(
                  showDepositsOnly: 2,
                  key: ValueKey(getDate),
                  selectDate: getDate,
                )),
            Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: SummaryScreen(
                  showDepositsOnly: 3,
                  key: ValueKey(getDate),
                  selectDate: getDate,
                )),
            Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SummaryScreen(
                  showDepositsOnly: 4,
                  key: ValueKey(getDate),
                  selectDate: getDate,
                )),
            Container(
              child: Center(
                child: DiscountsTable(
                  key: ValueKey(getDate),
                  selectDate: getDate,
                ),
              ),
            ),
            Container(
              child: SalesByOrderTypeTable(
                key: ValueKey(getDate),
                selectDate: getDate,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,

              // child: Center(
              child: AverageSalePerTicketTable(
                key: ValueKey(getDate),
                selectDate: getDate,
              ),
              // ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: SummaryScreen(
                  showDepositsOnly: 5,
                  key: ValueKey(getDate),
                  selectDate: getDate,
                )),
            Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: SummaryScreen(
                  showDepositsOnly: 6,
                  key: ValueKey(getDate),
                  selectDate: getDate,
                )),
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
