// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: Text('Print Example')),
//         body: Center(child: ShareMenu()),
//       ),
//     );
//   }
// }

Future<Uint8List> generatePDF() async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Sales', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Beverage: \$320.00'),
            pw.Text('Food: \$2,282.14'),
            pw.Text('Beer: \$180.50'),
            pw.Text('Wine: \$210.00'),
            pw.SizedBox(height: 20),
            pw.Text('Total Sales: \$2,992.64', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            // Example of adding a chart placeholder
            pw.Text('Graph Placeholder', style: pw.TextStyle(color: PdfColors.grey)),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

class ShareMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => generatePDF(),
        );
      },
      child: Text('Print'),
    );
  }
}
