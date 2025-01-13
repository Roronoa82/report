import 'dart:convert';
import 'package:flutter/services.dart'; // สำหรับโหลดไฟล์ assets

class SalesData {
  final int rpSummarySalesID;
  final int year;
  final int month;
  final int day;
  final String date;
  final SalesDetail data;

  SalesData({
    required this.rpSummarySalesID,
    required this.year,
    required this.month,
    required this.day,
    required this.date,
    required this.data,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      rpSummarySalesID: json['RpSummarySalesID'],
      year: json['Year'],
      month: json['Month'],
      day: json['Day'],
      date: json['Date'],
      data: SalesDetail.fromJson(jsonDecode(json['Data'])),
    );
  }

  @override
  String toString() {
    return 'SalesData(rpSummarySalesID: $rpSummarySalesID, year: $year, month: $month, day: $day, date: $date, data: $data)';
  }
}

class SalesDetail {
  final String date;
  final Sales sales;
  final SalesByOrderType salesByOrderType;
  final Payments payments;
  final ServiceChargeAndFee serviceChargeAndFee;
  final GiftCertificate giftCertificate;
  final Other other;

  SalesDetail({
    required this.date,
    required this.sales,
    required this.salesByOrderType,
    required this.payments,
    required this.serviceChargeAndFee,
    required this.giftCertificate,
    required this.other,
  });

  factory SalesDetail.fromJson(Map<String, dynamic> json) {
    return SalesDetail(
      date: json['Date'],
      sales: Sales.fromJson(json['Sales']),
      salesByOrderType: SalesByOrderType.fromJson(json['SalesByOrderType']),
      payments: Payments.fromJson(json['Payments']),
      serviceChargeAndFee: ServiceChargeAndFee.fromJson(json['ServiceChargeAndFee']),
      giftCertificate: GiftCertificate.fromJson(json['GiftCertificate']),
      other: Other.fromJson(json['Other']),
    );
  }

  @override
  String toString() {
    return 'SalesDetail(date: $date, sales: $sales, salesByOrderType: $salesByOrderType, payments: $payments, serviceChargeAndFee: $serviceChargeAndFee, giftCertificate: $giftCertificate, other: $other)';
  }
}

class Sales {
  final double food;
  final double liquor;
  final double netSales;
  final double taxes;

  Sales({
    required this.food,
    required this.liquor,
    required this.netSales,
    required this.taxes,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      food: json['Food'],
      liquor: json['Liquor'],
      netSales: json['NetSales'],
      taxes: json['Taxes'],
    );
  }

  @override
  String toString() {
    return 'Sales(food: $food, liquor: $liquor, netSales: $netSales, taxes: $taxes)';
  }
}

class SalesByOrderType {
  final double dineIn;
  final double togo;
  final double delivery;

  SalesByOrderType({
    required this.dineIn,
    required this.togo,
    required this.delivery,
  });

  factory SalesByOrderType.fromJson(Map<String, dynamic> json) {
    return SalesByOrderType(
      dineIn: json['DineIn'],
      togo: json['Togo'],
      delivery: json['Delivery'],
    );
  }
}

class Payments {
  final double cash;
  final double check;
  final double coupon;
  final double pp;
  final double pPTips;
  final double emvccSales;
  final double emvcCTips;
  final double cloverFlexCCSales;
  final double cloverFlexCCTips;
  final double smileDiningPP;
  final double smileDiningPPTips;
  final double smileDiningPPGC;
  final double smileDiningPPGCTips;
  final double smileContactlessPP;
  final double smileContactlessPPTips;
  final double smileContactlessPPGC;
  final double smileContactlessPPGCTips;

  Payments({
    required this.cash,
    required this.check,
    required this.coupon,
    required this.pp,
    required this.pPTips,
    required this.emvccSales,
    required this.emvcCTips,
    required this.cloverFlexCCSales,
    required this.cloverFlexCCTips,
    required this.smileDiningPP,
    required this.smileDiningPPTips,
    required this.smileDiningPPGC,
    required this.smileDiningPPGCTips,
    required this.smileContactlessPP,
    required this.smileContactlessPPTips,
    required this.smileContactlessPPGC,
    required this.smileContactlessPPGCTips,
  });

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      cash: json['Cash'],
      check: json['Check'],
      coupon: json['Coupon'],
      pp: json['PP'],
      pPTips: json['PPTips'],
      emvccSales: json['EMVCCSales'],
      emvcCTips: json['EMVCCTips'],
      cloverFlexCCSales: json['CloverFlexCCSales'],
      cloverFlexCCTips: json['CloverFlexCCTips'],
      smileDiningPP: json['SmileDiningPP'],
      smileDiningPPTips: json['SmileDiningPPTips'],
      smileDiningPPGC: json['SmileDiningPPGC'],
      smileDiningPPGCTips: json['SmileDiningPPGCTips'],
      smileContactlessPP: json['SmileContactlessPP'],
      smileContactlessPPTips: json['SmileContactlessPPTips'],
      smileContactlessPPGC: json['SmileContactlessPPGC'],
      smileContactlessPPGCTips: json['SmileContactlessPPGCTips'],
    );
  }
}

class ServiceChargeAndFee {
  final double gratuity;
  final double onlineCustomCharge;
  final double contactlessCustomCharge;
  final double smilePOSAutoCharge;
  final double deliveryRestaurant;
  final double deliveryDoorDashDrive;
  final double others;
  final double utensils;
  final double paymentFee;
  final double serviceFeeOnCreditCard;
  final double serviceFeeAdjustment;

  ServiceChargeAndFee({
    required this.gratuity,
    required this.onlineCustomCharge,
    required this.contactlessCustomCharge,
    required this.smilePOSAutoCharge,
    required this.deliveryRestaurant,
    required this.deliveryDoorDashDrive,
    required this.others,
    required this.utensils,
    required this.paymentFee,
    required this.serviceFeeOnCreditCard,
    required this.serviceFeeAdjustment,
  });

  factory ServiceChargeAndFee.fromJson(Map<String, dynamic> json) {
    return ServiceChargeAndFee(
      gratuity: json['Gratuity'],
      onlineCustomCharge: json['OnlineCustomCharge'],
      contactlessCustomCharge: json['ContactlessCustomCharge'],
      smilePOSAutoCharge: json['SmilePOSAutoCharge'],
      deliveryRestaurant: json['DeliveryRestaurant'],
      deliveryDoorDashDrive: json['DeliveryDoorDashDrive'],
      others: json['Others'],
      utensils: json['Utensils'],
      paymentFee: json['PaymentFee'],
      serviceFeeOnCreditCard: json['ServiceFeeOnCreditCard'],
      serviceFeeAdjustment: json['ServiceFeeAdjustment'],
    );
  }
}

class GiftCertificate {
  final double giftSales;
  final double giftRedeem;
  final double eGiftSalesShop;
  final double eGiftSalesOnline;

  GiftCertificate({
    required this.giftSales,
    required this.giftRedeem,
    required this.eGiftSalesShop,
    required this.eGiftSalesOnline,
  });

  factory GiftCertificate.fromJson(Map<String, dynamic> json) {
    return GiftCertificate(
      giftSales: json['GiftSales'],
      giftRedeem: json['GiftRedeem'],
      eGiftSalesShop: json['EGiftSalesShop'],
      eGiftSalesOnline: json['EGiftSalesOnline'],
    );
  }
}

class Other {
  final double discount;
  final double cashInCashOut;
  final double cashDeposit;

  Other({
    required this.discount,
    required this.cashInCashOut,
    required this.cashDeposit,
  });

  factory Other.fromJson(Map<String, dynamic> json) {
    return Other(
      discount: json['Discount'],
      cashInCashOut: json['CashInCashOut'],
      cashDeposit: json['CashDeposit'],
    );
  }
}

Future<List<SalesData>> loadSalesData() async {
  // โหลดไฟล์ JSON จาก assets
  String jsonString = await rootBundle.loadString('assets/summary_sale.json');
  List<dynamic> jsonList = json.decode(jsonString);

  // แปลงข้อมูล JSON เป็น SalesData
  return jsonList.map((json) => SalesData.fromJson(json)).toList();
}
