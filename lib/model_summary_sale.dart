// import 'dart:convert';

// class RpSummarySales {
//   final int rpSummarySalesID;
//   final int year;
//   final int month;
//   final int day;
//   final DateTime date;
//   final SalesData data;

//   RpSummarySales({
//     required this.rpSummarySalesID,
//     required this.year,
//     required this.month,
//     required this.day,
//     required this.date,
//     required this.data,
//   });

//   factory RpSummarySales.fromJson(Map<String, dynamic> json) {
//     return RpSummarySales(
//       rpSummarySalesID: json['RpSummarySalesID'],
//       year: json['Year'],
//       month: json['Month'],
//       day: json['Day'],
//       date: DateTime.parse(json['Date']),
//       data: SalesData.fromJson(jsonDecode(json['Data'])),
//     );
//   }
// }

// class SalesData {
//   final DateTime date;
//   final Sales sales;
//   final SalesByOrderType salesByOrderType;
//   final Payments payments;
//   final ServiceChargeAndFee serviceChargeAndFee;
//   final GiftCertificate giftCertificate;
//   final Other other;

//   SalesData({
//     required this.date,
//     required this.sales,
//     required this.salesByOrderType,
//     required this.payments,
//     required this.serviceChargeAndFee,
//     required this.giftCertificate,
//     required this.other,
//   });

//   factory SalesData.fromJson(Map<String, dynamic> json) {
//     return SalesData(
//       date: DateTime.parse(json['Date']),
//       sales: Sales.fromJson(json['Sales']),
//       salesByOrderType: SalesByOrderType.fromJson(json['SalesByOrderType']),
//       payments: Payments.fromJson(json['Payments']),
//       serviceChargeAndFee: ServiceChargeAndFee.fromJson(json['ServiceChargeAndFee']),
//       giftCertificate: GiftCertificate.fromJson(json['GiftCertificate']),
//       other: Other.fromJson(json['Other']),
//     );
//   }
// }

// class Sales {
//   final double food;
//   final double liquor;
//   final double netSales;
//   final double taxes;

//   Sales({
//     required this.food,
//     required this.liquor,
//     required this.netSales,
//     required this.taxes,
//   });

//   factory Sales.fromJson(Map<String, dynamic> json) {
//     return Sales(
//       food: json['Food'].toDouble(),
//       liquor: json['Liquor'].toDouble(),
//       netSales: json['NetSales'].toDouble(),
//       taxes: json['Taxes'].toDouble(),
//     );
//   }
// }

// class SalesByOrderType {
//   final double dineIn;
//   final double togo;
//   final double delivery;

//   SalesByOrderType({
//     required this.dineIn,
//     required this.togo,
//     required this.delivery,
//   });

//   factory SalesByOrderType.fromJson(Map<String, dynamic> json) {
//     return SalesByOrderType(
//       dineIn: json['DineIn'].toDouble(),
//       togo: json['Togo'].toDouble(),
//       delivery: json['Delivery'].toDouble(),
//     );
//   }
// }

// class Payments {
//   final double cash;
//   final double emvCCSales;
//   final double emvCCTips;
//   final double smileDiningPP;
//   final double smileDiningPPTips;

//   Payments({
//     required this.cash,
//     required this.emvCCSales,
//     required this.emvCCTips,
//     required this.smileDiningPP,
//     required this.smileDiningPPTips,
//   });

//   factory Payments.fromJson(Map<String, dynamic> json) {
//     return Payments(
//       cash: json['Cash'].toDouble(),
//       emvCCSales: json['EMVCCSales'].toDouble(),
//       emvCCTips: json['EMVCCTips'].toDouble(),
//       smileDiningPP: json['SmileDiningPP'].toDouble(),
//       smileDiningPPTips: json['SmileDiningPPTips'].toDouble(),
//     );
//   }
// }

// class ServiceChargeAndFee {
//   final double gratuity;
//   final double deliveryDoorDashDrive;

//   ServiceChargeAndFee({
//     required this.gratuity,
//     required this.deliveryDoorDashDrive,
//   });

//   factory ServiceChargeAndFee.fromJson(Map<String, dynamic> json) {
//     return ServiceChargeAndFee(
//       gratuity: json['Gratuity'].toDouble(),
//       deliveryDoorDashDrive: json['DeliveryDoorDashDrive'].toDouble(),
//     );
//   }
// }

// class GiftCertificate {
//   final double giftSales;

//   GiftCertificate({
//     required this.giftSales,
//   });

//   factory GiftCertificate.fromJson(Map<String, dynamic> json) {
//     return GiftCertificate(
//       giftSales: json['GiftSales'].toDouble(),
//     );
//   }
// }

// class Other {
//   final double discount;
//   final double cashDeposit;

//   Other({
//     required this.discount,
//     required this.cashDeposit,
//   });

//   factory Other.fromJson(Map<String, dynamic> json) {
//     return Other(
//       discount: json['Discount'].toDouble(),
//       cashDeposit: json['CashDeposit'].toDouble(),
//     );
//   }
// }
import 'dart:convert';

import 'package:logger/logger.dart';

final logger = Logger();

class SummarySale {
  final int rpSummarySalesID;
  final int year;
  final int month;
  final int day;
  final DateTime date;
  final List<Map<String, dynamic>> data;

  SummarySale({
    required this.rpSummarySalesID,
    required this.year,
    required this.month,
    required this.day,
    required this.date,
    required this.data,
  });

  factory SummarySale.fromJson(Map<String, dynamic> json) {
    return SummarySale(
      rpSummarySalesID: json['RpSummarySalesID'],
      year: json['Year'],
      month: json['Month'],
      day: json['Day'],
      date: DateTime.parse(json['Date']),
      data: _parseJson(json['Data']), // แปลง JSON string จากฟิลด์ 'Data'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RpSummarySalesID': rpSummarySalesID,
      'Year': year,
      'Month': month,
      'Day': day,
      'Date': date.toIso8601String(),
      'Data': _jsonToString(data),
    };
  }

  // Helper method to parse JSON string into List<Map<String, dynamic>>
  static List<Map<String, dynamic>> _parseJson(String jsonString) {
    try {
      final decoded = json.decode(jsonString);
      logger.t(decoded);
      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
      } else if (decoded is Map) {
        // ถ้าเป็น Map ให้แปลงเป็น List ที่มีแค่ 1 ไอเท็ม
        return [Map<String, dynamic>.from(decoded)];
      } else {
        throw FormatException("Expected a List but got ${decoded.runtimeType}");
      }
    } catch (e) {
      print("Error parsing JSON: $e");
      return []; // คืนค่าลิสต์ว่างในกรณีผิดพลาด
    }
  }

  // Helper method to convert List<Map<String, dynamic>> to JSON string
  static String _jsonToString(List<Map<String, dynamic>> list) {
    return json.encode(list);
  }

  @override
  String toString() {
    return 'Summary{'
        'RpSummarySalesID: $rpSummarySalesID, '
        'year: $year, '
        'month: $month, '
        'day: $day, '
        'date: $date, '
        'data: $data, ';
  }
}
