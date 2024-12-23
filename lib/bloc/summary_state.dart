// ignore_for_file: unused_local_variable

import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model_summary.dart';

abstract class SummaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  // final List<Map<String, dynamic>> rawSummaries; // Raw JSON
  final List<Map<String, dynamic>> summaries;
  final List<Summary> allSummaries; // เก็บข้อมูลทั้งหมด
  final List<Summary> filteredSummaries; // เก็บข้อมูลที่กรองแล้ว

  // final List<List<Map<String, dynamic>>> filteredData;

  SummaryLoaded(this.summaries, {required this.allSummaries, required this.filteredSummaries});

  // SummaryLoaded(this.summaries);

  @override
  List<Object?> get props => [summaries, allSummaries, filteredSummaries];
// }

// class SummarySaleLoaded extends SummaryState {
//   final List<Map<String, dynamic>> rawSummarySales; // Raw JSON
//   final List<SummarySale> allSummarySales; // List ของ SummarySale

//   SummarySaleLoaded({
//     required this.rawSummarySales,
//     required this.allSummarySales,
//   });

//   @override
//   List<Object?> get props => [rawSummarySales, allSummarySales];
}

class SummaryError extends SummaryState {
  final String message;

  SummaryError(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsLoaded extends PaymentsState {
  final List<Map<String, dynamic>> payments;

  PaymentsLoaded(this.payments);
}

class PaymentsError extends PaymentsState {
  final String message;

  PaymentsError(this.message);
}

abstract class FilterState extends Equatable {
  @override
  List<Object> get props => [];
}

class FilterInitialState extends FilterState {}

class FilterLoadingState extends FilterState {}

class FilterLoadedState extends FilterState {
  final List<dynamic> filteredData;

  FilterLoadedState(this.filteredData);

  @override
  List<Object> get props => [filteredData];
}

class FilterErrorState extends FilterState {
  final String error;

  FilterErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class DataLoaded extends SummaryState {
  @override
  List<Object?> get props => [];
}

List<FlSpot> getLineChartData(List<dynamic> summaries) {
  List<FlSpot> spots = [];
  for (int i = 0; i < summaries.length; i++) {
    final summary = summaries[i];
    final date = DateTime.parse(summary['Date']);
    final double value = double.tryParse(summary['Value'].toString()) ?? 0.0;
    spots.add(FlSpot(i.toDouble(), value));
  }
  return spots;
}

List<BarChartGroupData> getBarChartData(List<dynamic> summaries) {
  List<BarChartGroupData> bars = [];
  for (int i = 0; i < summaries.length; i++) {
    final summary = summaries[i];
    final double value = double.tryParse(summary['Value'].toString()) ?? 0.0;
    bars.add(BarChartGroupData(
      x: i,
      barRods: [BarChartRodData(toY: value, color: Colors.blue)],
    ));
  }
  return bars;
}

class PaymentState {
  final double totalSales;
  final double totalTips;
  final double totalPayments;

  PaymentState({
    this.totalSales = 0.0,
    this.totalTips = 0.0,
    this.totalPayments = 0.0,
  });
}

abstract class SummarySalesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SummarySalesInitial extends SummarySalesState {}

class SummarySalesLoading extends SummarySalesState {}

class SummarySalesLoaded extends SummarySalesState {
  final List<Map<String, dynamic>> summaries;
  final List<Summary> allSummaries; // เก็บข้อมูลทั้งหมด
  final List<Summary> filteredSummaries; // เก็บข้อมูลที่กรองแล้ว

  // final List<List<Map<String, dynamic>>> filteredData;

  SummarySalesLoaded(this.summaries, {required this.allSummaries, required this.filteredSummaries});

  // SummaryLoaded(this.summaries);

  @override
  List<Object?> get props => [summaries, allSummaries, filteredSummaries];
}

class SummarySalesError extends SummarySalesState {
  final String message;

  SummarySalesError(this.message);

  @override
  List<Object?> get props => [message];
}
