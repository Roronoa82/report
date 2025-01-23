import 'package:equatable/equatable.dart';
import '../model_data_result.dart';

abstract class DataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<FoodItemData> foods;
  final List<FoodCategory> categories;
  final List<FoodSet> sets;

  DataLoaded({required this.foods, required this.categories, required this.sets});

  @override
  List<Object?> get props => [foods, categories, sets];
}

class DataError extends DataState {
  final String message;

  DataError(this.message);

  @override
  List<Object?> get props => [message];
}
