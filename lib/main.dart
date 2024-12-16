import 'package:develop_resturant/bloc/summary_bloc.dart';
import 'package:develop_resturant/widgets/filter_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/summary.dart';
import 'reports.dart';
import 'package:provider/provider.dart';

import 'screens/overall/overall_summary.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await copyFileToAppDirectory();
//   runApp(MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<SummaryBloc>(create: (_) => SummaryBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Develop Restaurant', // ชื่อแอป
      theme: ThemeData(
        primarySwatch: Colors.blue, // เลือกสีหลักของแอป
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReportPage(), // ตั้งค่า CashInReportScreen เป็นหน้าแรก
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:develop_resturant/bloc/summary_bloc.dart';
// import '../../isar/isarservice.dart';
// import 'screens/overall/filterbydate.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final isarService = IsarService();
//   await isarService.init();

//   runApp(MyApp(isarService: isarService));
// }

// class MyApp extends StatelessWidget {
//   final IsarService isarService;

//   const MyApp({required this.isarService});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => FilterBloc(isarService), // สร้าง FilterBloc
//         ),
//       ],
//       child: MaterialApp(
//         home: FilterByDateScreen(isarService: isarService),
//       ),
//     );
//   }
// }
