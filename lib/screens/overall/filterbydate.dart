// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../bloc/summary_bloc.dart';
// import '../../bloc/summary_state.dart';

// class FilterByDateScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Filter by Date")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Select Date:", style: TextStyle(fontSize: 18)),
//             SizedBox(height: 10),
//             TextField(
//               readOnly: true,
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 // TODO: Save picked date
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 suffixIcon: Icon(Icons.calendar_today),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Trigger filter action
//               },
//               child: Text("Filter Data"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FilterResultScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FilterBloc, FilterState>(
//       builder: (context, state) {
//         if (state is FilterLoading) {
//           return Center(child: CircularProgressIndicator());
//         } else if (state is FilterLoaded) {
//           return ListView.builder(
//             itemCount: state.filteredData.length,
//             itemBuilder: (context, index) {
//               final data = state.filteredData[index];
//               return ListTile(
//                 title: Text(data['OrderType'] ?? "Unknown"),
//                 subtitle: Text("Value: ${data['Value']}"),
//               );
//             },
//           );
//         } else if (state is FilterError) {
//           return Center(child: Text("Error: ${state.error}"));
//         }
//         return Center(child: Text("Select a date to filter data"));
//       },
//     );
//   }
// }
// import 'package:develop_resturant/screens/overall/cradit_cart_table.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/summary_bloc.dart';
// import '../../bloc/summary_event.dart';
// import '../../bloc/summary_state.dart';
// import '../../model_summary.dart';

// class FilterView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () async {
//             final selectedDate = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(2020),
//               lastDate: DateTime.now(),
//             );
//             if (selectedDate != null) {
//               context.read<FilterBloc>().add(FilterByDateEvent(selectedDate));
//             }
//           },
//           child: Text('Select Date'),
//         ),
//         Expanded(
//           child: BlocBuilder<FilterBloc, FilterState>(
//             builder: (context, state) {
//               if (state is FilterLoadingState) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (state is FilterLoadedState) {
//                 return ListView.builder(
//                   itemCount: state.filteredData.length,
//                   itemBuilder: (context, index) {
//                     final summary = state.filteredData[index] as Summary;
//                     return ListTile(
//                       title: Text('ID: ${summary.rpOverAllSummaryID}'),
//                       subtitle: Text('Date: ${summary.date.toLocal()}'),
//                     );
//                   },
//                 );
//               } else if (state is FilterErrorState) {
//                 return Center(child: Text(state.error));
//               }
//               return Center(child: Text('No data found'));
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
