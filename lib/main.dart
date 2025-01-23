import 'dart:ui';

import 'package:develop_resturant/bloc/data_result_bloc.dart';
import 'package:develop_resturant/bloc/data_result_event.dart';
import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/bloc/summary_sale_bloc.dart';
import 'package:flutter/material.dart';
import 'bloc/date_filter_bloc.dart';
import 'bloc/summary_sale_event.dart';
import 'reports.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<SummaryBloc>(create: (_) => SummaryBloc()),
        Provider<DateFilterBloc>(
            create: (_) => DateFilterBloc(
                  DateTime.now(),
                  DateTime.now(),
                )),
        Provider<SalesBloc>(create: (_) => SalesBloc()..add(LoadSalesDataEvent())),
        Provider<DataBloc>(create: (_) => DataBloc()..add(LoadDataEvent())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      title: 'Develop Restaurant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReportPage(
        initialSelectedReport: 1,
        onReportSelected: (int) {},
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
