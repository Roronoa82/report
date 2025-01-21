import 'dart:convert';
import 'package:flutter/services.dart';

class FoodItemData {
  final String foodId;
  final String foodName;
  final String? foodNameAlt;
  final double foodPrice;
  final String? foodDesc;
  final int foodSorting;
  final bool active;
  final String foodSetId;
  final String foodCatId;
  final String imageName;

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
    required this.imageName,
  });

  factory FoodItemData.fromJson(Map<String, dynamic> json) {
    return FoodItemData(
      foodId: json['foodId'],
      foodName: json['foodName'],
      foodNameAlt: json['foodNameAlt'],
      foodPrice: (json['foodPrice'] as num).toDouble(),
      foodDesc: json['foodDesc'],
      foodSorting: json['foodSorting'],
      active: json['active'],
      foodSetId: json['foodSetId'],
      foodCatId: json['foodCatId'],
      imageName: json['imageName'],
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
      'imageName': imageName,
    };
  }
}

Future<List<FoodItemData>> loadFoodItem() async {
  String jsonString = await rootBundle.loadString('assets/data_result.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  final List<dynamic> foodList = jsonData['result']['food'];

  return foodList.map((json) => FoodItemData.fromJson(json)).toList();
}
