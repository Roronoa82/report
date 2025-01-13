import 'dart:ui';

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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(), // ใช้ ScrollBehavior ที่ปรับแต่ง
      title: 'Develop Restaurant', // ชื่อแอป
      theme: ThemeData(
        primarySwatch: Colors.blue, // เลือกสีหลักของแอป
        // selectedTileColor: Colors.black, // กำหนดสีเมื่อ ListTile ถูกเลือก

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReportPage(), // ตั้งค่า CashInReportScreen เป็นหน้าแรก
    );
  }
}

/// กำหนด CustomScrollBehavior เพื่อรองรับการเลื่อนแบบ Horizontal
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch, // รองรับการเลื่อนบนหน้าจอสัมผัส
        PointerDeviceKind.mouse, // รองรับการเลื่อนด้วยเมาส์
      };
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
