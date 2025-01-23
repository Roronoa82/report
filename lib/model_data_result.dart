import 'dart:convert';
import 'package:flutter/services.dart';

class FoodItemData {
  final String foodId;
  final String foodName;
  final String? foodNameAlt; // อนุญาตให้เป็น null
  final double foodPrice;
  final String? foodDesc; // อนุญาตให้เป็น null
  final int foodSorting;
  final bool active;
  final String foodSetId;
  final String foodCatId;
  final String revenueClassId;
  final String taxRateId;
  final String taxRate2Id;
  final bool priority;
  final bool printSingle;
  final bool isCommand;
  final bool foodShowOption;
  final String? foodPDANumber; // อนุญาตให้เป็น null
  final String modifyOn;
  final String createOn;
  final String? pureImageName; // อนุญาตให้เป็น null
  final String? imageName; // อนุญาตให้เป็น null
  final int qtyLimit;
  final bool isLimit;
  final String productId;
  final bool isOutStock;
  final bool isFree;
  final bool isShow;
  final bool isShowInstruction;
  final String? imageNameString; // อนุญาตให้เป็น null
  final int thirdPartyGroupId;
  final String foodBaseId;
  final bool isThirdParty;
  final String? plu; // อนุญาตให้เป็น null
  final String? imageThirdParty; // อนุญาตให้เป็น null

  FoodItemData({
    required this.foodId,
    required this.foodName,
    this.foodNameAlt,
    required this.foodPrice,
    this.foodDesc,
    required this.foodSorting,
    required this.active,
    required this.foodSetId,
    required this.foodCatId,
    required this.revenueClassId,
    required this.taxRateId,
    required this.taxRate2Id,
    required this.priority,
    required this.printSingle,
    required this.isCommand,
    required this.foodShowOption,
    this.foodPDANumber,
    required this.modifyOn,
    required this.createOn,
    this.pureImageName,
    this.imageName,
    required this.qtyLimit,
    required this.isLimit,
    required this.productId,
    required this.isOutStock,
    required this.isFree,
    required this.isShow,
    required this.isShowInstruction,
    this.imageNameString,
    required this.thirdPartyGroupId,
    required this.foodBaseId,
    required this.isThirdParty,
    this.plu,
    this.imageThirdParty,
  });

  factory FoodItemData.fromJson(Map<String, dynamic> json) {
    return FoodItemData(
      foodId: json['foodId'] ?? '',
      foodName: json['foodName'] ?? '',
      foodNameAlt: json['foodNameAlt'], // รองรับ null
      foodPrice: (json['foodPrice'] ?? 0.0) as double,
      foodDesc: json['foodDesc'], // รองรับ null
      foodSorting: json['foodSorting'] ?? 0,
      active: json['active'] ?? false,
      foodSetId: json['foodSetId'] ?? '',
      foodCatId: json['foodCatId'] ?? '',
      revenueClassId: json['revenueClassId'] ?? '',
      taxRateId: json['taxRateId'] ?? '',
      taxRate2Id: json['taxRate2Id'] ?? '',
      priority: json['priority'] ?? false,
      printSingle: json['printSingle'] ?? false,
      isCommand: json['isCommand'] ?? false,
      foodShowOption: json['foodShowOption'] ?? false,
      foodPDANumber: json['foodPDANumber'], // รองรับ null
      modifyOn: json['modifyOn'] ?? '',
      createOn: json['createOn'] ?? '',
      pureImageName: json['pureImageName'], // รองรับ null
      imageName: json['imageName'], // รองรับ null
      qtyLimit: json['qtyLimit'] ?? 0,
      isLimit: json['isLimit'] ?? false,
      productId: json['productId'] ?? '',
      isOutStock: json['isOutStock'] ?? false,
      isFree: json['isFree'] ?? false,
      isShow: json['isShow'] ?? false,
      isShowInstruction: json['isShowInstruction'] ?? false,
      imageNameString: json['imageNameString'], // รองรับ null
      thirdPartyGroupId: json['thirdPartyGroupId'] ?? 0,
      foodBaseId: json['foodBaseId'] ?? '',
      isThirdParty: json['isThirdParty'] ?? false,
      plu: json['plu'], // รองรับ null
      imageThirdParty: json['imageThirdParty'], // รองรับ null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'foodNameAlt': foodNameAlt,
      'foodPrice': foodPrice,
      'foodDesc': foodDesc,
      'foodSorting': foodSorting,
      'active': active,
      'foodSetId': foodSetId,
      'foodCatId': foodCatId,
      'revenueClassId': revenueClassId,
      'taxRateId': taxRateId,
      'taxRate2Id': taxRate2Id,
      'priority': priority,
      'printSingle': printSingle,
      'isCommand': isCommand,
      'foodShowOption': foodShowOption,
      'foodPDANumber': foodPDANumber,
      'modifyOn': modifyOn,
      'createOn': createOn,
      'pureImageName': pureImageName,
      'imageName': imageName,
      'qtyLimit': qtyLimit,
      'isLimit': isLimit,
      'productId': productId,
      'isOutStock': isOutStock,
      'isFree': isFree,
      'isShow': isShow,
      'isShowInstruction': isShowInstruction,
      'imageNameString': imageNameString,
      'thirdPartyGroupId': thirdPartyGroupId,
      'foodBaseId': foodBaseId,
      'isThirdParty': isThirdParty,
      'plu': plu,
      'imageThirdParty': imageThirdParty,
    };
  }

  @override
  String toString() {
    return 'FoodItemData(foodId: $foodId, foodName: $foodName,foodNameAlt: $foodNameAlt, foodPrice: $foodPrice,foodDesc: $foodDesc,foodSorting: $foodSorting,active: $active,foodSetId: $foodSetId,foodCatId: $foodCatId,revenueClassId: $revenueClassId,taxRateId: $taxRateId,taxRate2Id: $taxRate2Id,priority: $priority,printSingle: $printSingle,isCommand: $isCommand,foodShowOption: $foodShowOption,foodPDANumber: $foodPDANumber,modifyOn: $modifyOn,createOn: $createOn,pureImageName: $pureImageName,imageName: $imageName,qtyLimit: $qtyLimit,isLimit: $isLimit,productId: $productId,isOutStock: $isOutStock,isFree: $isFree,isShow: $isShow,isShowInstruction: $isShowInstruction,imageNameString: $imageNameString,thirdPartyGroupId: $thirdPartyGroupId,foodBaseId: $foodBaseId,isThirdParty: $isThirdParty,plu: $plu,imageThirdParty: $imageThirdParty,)';
  }
}

class FoodCategory {
  final String foodCatId;
  final String? foodCatName;
  final String? foodCatDesc;
  final bool active;

  FoodCategory({
    required this.foodCatId,
    this.foodCatName,
    this.foodCatDesc,
    required this.active,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      foodCatId: json['foodCatId'],
      foodCatName: json['foodCatName'],
      foodCatDesc: json['foodCatDesc'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodCatId': foodCatId,
      'foodCatName': foodCatName,
      'foodCatDesc': foodCatDesc,
      'active': active,
    };
  }
}

class FoodSet {
  final String foodSetId;
  final String? foodSetName;
  final bool active;

  FoodSet({
    required this.foodSetId,
    this.foodSetName,
    required this.active,
  });

  factory FoodSet.fromJson(Map<String, dynamic> json) {
    return FoodSet(
      foodSetId: json['foodSetId'],
      foodSetName: json['foodSetName'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodSetId': foodSetId,
      'foodSetName': foodSetName,
      'active': active,
    };
  }
}

Future<Map<String, dynamic>> loadAllData() async {
  String jsonString = await rootBundle.loadString('assets/data_result.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  // โหลด food
  final List<FoodItemData> foods = (jsonData['result']['food'] as List<dynamic>).map((item) => FoodItemData.fromJson(item)).toList();

  // โหลด foodCategory
  final List<FoodCategory> categories = (jsonData['result']['foodCategory'] as List<dynamic>).map((item) => FoodCategory.fromJson(item)).toList();

  // โหลด foodSet
  final List<FoodSet> sets = (jsonData['result']['foodSet'] as List<dynamic>).map((item) => FoodSet.fromJson(item)).toList();

  return {
    'foods': foods,
    'categories': categories,
    'sets': sets,
  };
}
