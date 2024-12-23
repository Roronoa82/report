// date_filter_state.dart
import 'package:equatable/equatable.dart';

class DateFilterState extends Equatable {
  final DateTime fromDate;
  final DateTime toDate;

  const DateFilterState({
    required this.fromDate,
    required this.toDate,
  });

  DateFilterState copyWith({DateTime? fromDate, DateTime? toDate}) {
    return DateFilterState(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object> get props => [fromDate, toDate];
}
