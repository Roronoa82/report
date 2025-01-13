// sales_state.dart
import 'package:develop_resturant/model_summary_sale.dart';

abstract class SalesState {}

class SalesLoadingState extends SalesState {}

class SalesLoadedState extends SalesState {
  final List<SalesData> salesData;
  SalesLoadedState(this.salesData);
}

class SalesErrorState extends SalesState {
  final String message;
  SalesErrorState(this.message);
}
