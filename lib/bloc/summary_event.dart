import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSummary extends SummaryEvent {}

// class LoadSummarySale extends SummaryEvent {} // Event ใหม่สำหรับ summary_sale.json

// Event สำหรับกรองข้อมูลตามวันที่ที่เลือก
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

abstract class PaymentsEvent {}

class LoadPayments extends PaymentsEvent {}

abstract class FilterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadDataEvent extends FilterEvent {}

class FilterByDateEvent extends FilterEvent {
  final DateTime selectedDate;

  FilterByDateEvent(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
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
