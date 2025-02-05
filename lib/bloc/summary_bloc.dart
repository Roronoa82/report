//summary_Bloc
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../model_summary.dart';
import 'summary_event.dart';
import 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  List<Summary> _allSummaries = [];

  SummaryBloc() : super(SummaryInitial()) {
    on<LoadSummary>(_onLoadSummary);

    on<FilterDateEvent>(_onFilterSummaryByDate);
  }

  Future<void> _onLoadSummary(LoadSummary event, Emitter<SummaryState> emit) async {
    emit(SummaryLoading());
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/overall_summary.json';

      final file = File(filePath);

      if (!await file.exists()) {
        logger.w("File not found at $filePath");
        throw Exception('File not found');
      }

      final content = await file.readAsString();
      final List<dynamic> jsonData = json.decode(content);
      _allSummaries = jsonData.map((data) {
        return Summary.fromJson(data);
      }).toList();

      emit(SummaryLoaded(
        jsonData.cast<Map<String, dynamic>>(),
        allSummaries: _allSummaries,
        filteredSummaries: _allSummaries,
      ));
      logger.d("Loaded ${_allSummaries.length} summaries.");
    } catch (e) {
      logger.e('Error loading summary data', error: e);
      emit(SummaryError(e.toString()));
    }
  }

  Future<void> _onFilterSummaryByDate(FilterDateEvent event, Emitter<SummaryState> emit) async {
    if (_allSummaries.isEmpty) {
      emit(SummaryError('No data available to filter.'));
      return;
    }

    final fromDate = DateTime(event.fromDate.year, event.fromDate.month, event.fromDate.day);
    final toDate = DateTime(event.toDate.year, event.toDate.month, event.toDate.day, 23, 59, 59);

    final filteredSummaries = _allSummaries.where((summary) {
      return summary.date.isAfter(fromDate) && summary.date.isBefore(toDate);
    }).toList();

    if (filteredSummaries.isEmpty) {
      emit(SummaryError('No data found for the selected date range.'));
    } else {
      emit(SummaryLoaded(
        _allSummaries.map((e) => e.toJson()).toList(),
        allSummaries: _allSummaries,
        filteredSummaries: filteredSummaries,
      ));
    }
  }
}
