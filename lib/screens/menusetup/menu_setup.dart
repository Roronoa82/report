import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/data_result.state.dart';
import '../../bloc/data_result_bloc.dart';
import '../../bloc/data_result_event.dart';

class FoodItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodItemBloc()..add(LoadFoodItemDataEvent()),
      child: Scaffold(
        // appBar: AppBar(title: Text('Food Items')),
        body: BlocBuilder<FoodItemBloc, FoodItemState>(
          builder: (context, state) {
            if (state is FoodItemLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FoodItemLoadedState) {
              final foodItems = state.fooditemData;
              return ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final food = foodItems[index];
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white, // สีพื้นหลังของปุ่ม
                      borderRadius: BorderRadius.circular(8), // มุมโค้งมน
                      border: Border.all(color: Colors.grey, width: 1), // เส้นขอบของปุ่ม
                    ),
                    child: ListTile(
                      leading: food.imageName.isNotEmpty ? Image.network(food.imageName) : Icon(Icons.fastfood),
                      title: Text(food.foodName),
                      subtitle: Text('${food.foodPrice.toStringAsFixed(2)} USD'),
                    ),
                  );
                },
              );
            } else if (state is FoodItemErrorState) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
