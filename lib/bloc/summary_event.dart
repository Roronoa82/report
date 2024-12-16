import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSummary extends SummaryEvent {}

// Event สำหรับกรองข้อมูลตามวันที่ที่เลือก
class FilterSummaryByDate extends SummaryEvent {
  final DateTime fromDate;
  final DateTime toDate;
  // final String reportType;
  // final List<dynamic> getData;

  FilterSummaryByDate({required this.fromDate, required this.toDate});

  // FilterSummaryByDate({
  //   required this.fromDate,
  //   required this.toDate,
  //   required this.reportType,
  //   required this.getData,
  // });

  // @override
  // List<Object> get props => [fromDate, toDate, reportType];
}

// Constructor สำหรับรับวันที่ที่เลือก
//   FilterSummaryByDate({required this.selectedDate});

//   @override
//   List<Object> get props => [selectedDate]; // เพิ่ม selectedDate เพื่อให้สามารถตรวจสอบการเปลี่ยนแปลงได้
// }
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
