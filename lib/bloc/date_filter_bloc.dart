// date_filter_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'date_filter_event.dart';
import 'date_filter_state.dart';

class DateFilterBloc extends Bloc<DateFilterEvent, DateFilterState> {
  DateFilterBloc(DateTime? fromDate, DateTime? toDate)
      : super(DateFilterState(
          fromDate: fromDate ?? DateTime(2023, 08, 01),
          toDate: toDate ?? DateTime(2023, 08, 31),
        )) {
    on<UpdateDateRange>((event, emit) {
      emit(state.copyWith(fromDate: event.fromDate, toDate: event.toDate));
    });
  }
}
