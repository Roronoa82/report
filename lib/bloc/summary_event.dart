import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSummary extends SummaryEvent {}

class FilterSummaryByDate extends SummaryEvent {
  final DateTime fromDate;
  final DateTime toDate;

  FilterSummaryByDate({required this.fromDate, required this.toDate});
}

class DateFilterChanged extends SummaryEvent {
  final DateTime startDate;
  final DateTime endDate;

  DateFilterChanged({required this.startDate, required this.endDate});
}

class FilterDateEvent extends SummaryEvent {
  final DateTime fromDate;
  final DateTime toDate;

  FilterDateEvent({required this.fromDate, required this.toDate});
}

abstract class SummarySalesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSummarySales extends SummaryEvent {}
