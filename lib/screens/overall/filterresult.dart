import 'package:develop_resturant/bloc/summary_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/summary_bloc.dart';
import '../../isar/isarservice.dart';
import '../../models/daily_summary.dart';

class FilterResultWidget extends StatelessWidget {
  final DateTime selectedDate;

  const FilterResultWidget({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailySummary>>(
      future: context.read<IsarService>().getSummaryByDate(selectedDate), // เรียกใช้งานฟังก์ชันเพื่อดึงข้อมูล
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return Center(child: Text("No data found for the selected date."));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final dailySummary = data[index];
            return ListTile(
              title: Text(dailySummary.date.toIso8601String()),
              subtitle: Text(dailySummary.data),
            );
          },
        );
      },
    );
  }
}
