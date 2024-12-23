// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';

// import '../../bloc/summary_bloc.dart';
// import '../../bloc/summary_event.dart';
// import '../../bloc/summary_state.dart';

// // import '../model_summary_sale.dart';
// final logger = Logger();

// class SummarySaleScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => SummaryBloc()..add(LoadSummarySale()), // เรียก Event โหลดข้อมูล
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Summary Sale'),
//         ),
//         body: BlocBuilder<SummaryBloc, SummaryState>(
//           builder: (context, state) {
//             if (state is SummaryLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is SummarySaleLoaded) {
//               final sales = state.allSummarySales; // ดึงข้อมูล summary_sale ทั้งหมด
//               logger.e(state.allSummarySales);
//               return ListView.builder(
//                 itemCount: sales.length,
//                 itemBuilder: (context, index) {
//                   final sale = sales[index];
//                   return ListTile(
//                     title: Text('Date: ${sale.date.toIso8601String()}'),
//                     // subtitle: Text('Net Sales: \$${sale.netSales.toStringAsFixed(2)}'),
//                   );
//                 },
//               );
//             } else if (state is SummaryError) {
//               return Center(child: Text('Error: ${state.message}'));
//             }
//             return Center(child: Text('No data available'));
//           },
//         ),
//       ),
//     );
//   }
// }
