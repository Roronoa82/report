import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../model_data_result.dart';
import 'data_result.state.dart';
import 'data_result_event.dart';

final logger = Logger();

class FoodItemBloc extends Bloc<FoodItemEvent, FoodItemState> {
  FoodItemBloc() : super(FoodItemLoadingState()) {
    on<LoadFoodItemDataEvent>(_onLoadFoodItemDataEvent);
  }

  Future<void> _onLoadFoodItemDataEvent(LoadFoodItemDataEvent event, Emitter<FoodItemState> emit) async {
    try {
      String jsonString = await rootBundle.loadString('assets/data_result.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> foodList = jsonData['result']['food'];

      List<FoodItemData> fooditemData = foodList.map((json) => FoodItemData.fromJson(json)).toList();

      logger.d(fooditemData);
      emit(FoodItemLoadedState(fooditemData));
    } catch (e) {
      logger.e('Error loading data', error: e);
      emit(FoodItemErrorState('Error loading food data'));
    }
  }
}
