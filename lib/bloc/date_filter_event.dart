// date_filter_event.dart
import 'package:equatable/equatable.dart';

abstract class DateFilterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateDateRange extends DateFilterEvent {
  final DateTime fromDate;
  final DateTime toDate;

  UpdateDateRange({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object> get props => [fromDate, toDate];
}
