// ignore_for_file: unused_local_variable
import 'package:equatable/equatable.dart';

import '../model_summary.dart';

abstract class SummaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  final List<Map<String, dynamic>> summaries;
  final List<Summary> allSummaries;
  final List<Summary> filteredSummaries;

  SummaryLoaded(this.summaries, {required this.allSummaries, required this.filteredSummaries});

  @override
  List<Object?> get props => [summaries, allSummaries, filteredSummaries];
}

class SummaryError extends SummaryState {
  final String message;

  SummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
