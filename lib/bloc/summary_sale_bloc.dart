// sales_bloc.dart
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model_summary_sale.dart';
import 'summary_sale_event.dart';
import 'summary_sale_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(SalesLoadingState()) {
    on<LoadSalesDataEvent>(_onLoadSalesDataEvent);
  }

  Future<void> _onLoadSalesDataEvent(LoadSalesDataEvent event, Emitter<SalesState> emit) async {
    try {
      String jsonString = await rootBundle.loadString('assets/summary_sale.json');
      List<dynamic> jsonList = json.decode(jsonString);
      List<SalesData> salesData = jsonList.map((json) => SalesData.fromJson(json)).toList();

      emit(SalesLoadedState(salesData));
    } catch (e) {
      emit(SalesErrorState('Error loading sales data'));
    }
  }
}
