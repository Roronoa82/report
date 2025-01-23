import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model_data_result.dart';
import 'data_result.state.dart';
import 'data_result_event.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataInitial()) {
    on<LoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      // โหลดข้อมูลจากไฟล์ JSON
      String jsonString = await rootBundle.loadString('assets/data_result.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // แปลงข้อมูล
      final List<FoodItemData> foods = (jsonData['result']['food'] as List<dynamic>).map((item) => FoodItemData.fromJson(item)).toList();
      final List<FoodCategory> categories = (jsonData['result']['foodCategory'] as List<dynamic>).map((item) => FoodCategory.fromJson(item)).toList();
      final List<FoodSet> sets = (jsonData['result']['foodSet'] as List<dynamic>).map((item) => FoodSet.fromJson(item)).toList();

      // ส่ง State ที่มีข้อมูลไปยัง UI
      emit(DataLoaded(foods: foods, categories: categories, sets: sets));
    } catch (e) {
      emit(DataError('Failed to load data: $e'));
    }
  }
}
