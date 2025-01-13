// sales_bloc.dart
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model_summary_sale.dart';
import 'summary_sale_event.dart';
import 'summary_sale_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(SalesLoadingState()) {
    on<LoadSalesDataEvent>(_onLoadSalesDataEvent); // Register event handler
  }

  Future<void> _onLoadSalesDataEvent(LoadSalesDataEvent event, Emitter<SalesState> emit) async {
    try {
      // โหลดข้อมูลจาก JSON (หรือจาก API หรือฐานข้อมูล)
      String jsonString = await rootBundle.loadString('assets/summary_sale.json');
      List<dynamic> jsonList = json.decode(jsonString);
      List<SalesData> salesData = jsonList.map((json) => SalesData.fromJson(json)).toList();

      emit(SalesLoadedState(salesData)); // ส่งข้อมูลไปยัง UI
    } catch (e) {
      emit(SalesErrorState('Error loading sales data'));
    }
  }
}
