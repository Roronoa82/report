// sales_state.dart

import '../model_data_result.dart';

abstract class FoodItemState {}

class FoodItemLoadingState extends FoodItemState {}

class FoodItemLoadedState extends FoodItemState {
  final List<FoodItemData> fooditemData;
  FoodItemLoadedState(this.fooditemData);
}

class FoodItemErrorState extends FoodItemState {
  final String message;
  FoodItemErrorState(this.message);
}
