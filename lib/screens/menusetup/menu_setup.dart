// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';
import '../../bloc/data_result.state.dart';
import '../../bloc/data_result_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'foodset_dialog.dart';

final logger = Logger();

class FoodItemScreen extends StatefulWidget {
  @override
  _FoodItemScreenState createState() => _FoodItemScreenState();
}

class _FoodItemScreenState extends State<FoodItemScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> categoryKeys = {};
  String? selectedFoodSet;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DataLoaded) {
          final uniqueCategories = state.categories
              .where((category) =>
                  category.foodCatId != null && category.foodCatId!.isNotEmpty && state.foods.any((food) => food.foodCatId == category.foodCatId))
              .toList();
          _tabController = TabController(length: uniqueCategories.length, vsync: this);

          uniqueCategories.forEach((category) {
            categoryKeys[category.foodCatId] = GlobalKey();
          });
          final foodSetNames = state.sets
              .where((foodset) => foodset.foodSetName != null && foodset.foodSetName!.isNotEmpty)
              .map((foodset) => foodset.foodSetName!)
              .toSet()
              .toList();

          if (selectedFoodSet == null && foodSetNames.isNotEmpty) {
            selectedFoodSet = foodSetNames.first;
          }
          final foodNames = state.foods
              .where((foodname) => foodname.foodName != null && foodname.foodName!.isNotEmpty)
              .map((foodname) => foodname.foodName!)
              .toSet()
              .toList();
          return Scaffold(
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 12),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _searchbar(),
                          SizedBox(width: 14.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.116,
                            height: MediaQuery.of(context).size.height * 0.044,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: '#EEEEEE'.toColor(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              SvgPicture.asset(
                                'assets/filter.svg',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 18.0),
                              Text(
                                'Filter',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: '#00000080'.toColor(),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: '#00000033'.toColor(),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(children: [
                        _foodset(),
                        const SizedBox(height: 16),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: '#00000033'.toColor(),
                        ),
                        const SizedBox(height: 16),
                        _foodcategory(),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: '#EEEEEE'.toColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Stack(
                          children: [
                            TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              indicator: BoxDecoration(
                                color: '#FFFFFF'.toColor(),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              indicatorPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              labelPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 36),
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                              labelColor: '#496EE2'.toColor(),
                              unselectedLabelColor: '#939393'.toColor(),
                              tabs: uniqueCategories.map((category) {
                                return Tab(
                                  child: Text(
                                    category.foodCatName ?? 'ไม่ระบุชื่อหมวดหมู่',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                              onTap: (index) {
                                final category = uniqueCategories[index];
                                final categoryKey = categoryKeys[category.foodCatId];

                                if (categoryKey?.currentContext != null) {
                                  Scrollable.ensureVisible(
                                    categoryKey!.currentContext!,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 9,
                  child: Container(
                    color: '#EEEEEE'.toColor(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: uniqueCategories.map((category) {
                            final filteredFoods = state.foods
                                .where(
                                    (food) => food.foodCatId == category.foodCatId && (food.foodName?.toLowerCase().contains(_searchQuery) ?? false))
                                .toList();
                            if (filteredFoods.isEmpty) {
                              return SizedBox.shrink();
                            }
                            return Column(
                              key: categoryKeys[category.foodCatId],
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.433,
                                      height: MediaQuery.of(context).size.height * 0.065,
                                      padding: EdgeInsets.only(left: 14.0, right: 8),
                                      decoration: BoxDecoration(
                                        color: '#FFFFFF'.toColor(),
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: '#00000033'.toColor(),
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                category.foodCatName ?? '',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500,
                                                  color: '#000000B2'.toColor(),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                category.foodCatDesc != null
                                                    ? category.foodCatDesc!.length > 60
                                                        ? category.foodCatDesc!.substring(0, 50) + '...'
                                                        : category.foodCatDesc!
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500,
                                                  color: '#00000080'.toColor(),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  print('Edit Icon Pressed');
                                                },
                                                child: _boxCustom(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: SvgPicture.asset(
                                                    'assets/download.svg',
                                                    width: 25,
                                                    height: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              GestureDetector(
                                                onTap: () {
                                                  print('Edit Icon Pressed');
                                                },
                                                child: _boxCustom(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        size: 20,
                                                        color: '#00000080'.toColor(),
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        'Add Food',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18,
                                                          color: '#00000080'.toColor(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredFoods.length,
                                  itemBuilder: (context, index) {
                                    final food = filteredFoods[index];
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: '#00000033'.toColor(),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                            child: Stack(
                                              children: [
                                                food.isOutStock
                                                    ? ColorFiltered(
                                                        colorFilter: ColorFilter.mode(
                                                          Colors.grey.withOpacity(0.5), // ทำให้ภาพจางลงเป็นสีเทา
                                                          BlendMode.saturation,
                                                        ),
                                                        child: food.imageName!.isNotEmpty
                                                            ? Image.network(
                                                                food.imageName!,
                                                                width: 150,
                                                                height: 160,
                                                                fit: BoxFit.cover,
                                                              )
                                                            : Container(
                                                                width: 150,
                                                                height: 160,
                                                                child: const Icon(
                                                                  Icons.fastfood,
                                                                  size: 100,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                      )
                                                    : food.imageName!.isNotEmpty
                                                        ? Image.network(
                                                            food.imageName!,
                                                            width: 150,
                                                            height: 160,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Container(
                                                            width: 150,
                                                            height: 160,
                                                            child: const Icon(
                                                              Icons.fastfood,
                                                              size: 100,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                if (food.isOutStock)
                                                  Container(
                                                    width: 150,
                                                    height: 160,
                                                    color: Color.fromARGB(51, 0, 0, 0), // สีทับสีดำ #00000033 (โปร่งใส 20%)
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.216,
                                                        child: Text(
                                                          food.foodName,
                                                          style: TextStyle(
                                                            fontFamily: 'Roboto',
                                                            color: '#4F4F4F'.toColor(),
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        '\$${food.foodPrice.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: '#4F4F4F'.toColor(),
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  food.foodDesc != null
                                                      ? food.foodDesc!.length > 50
                                                          ? food.foodDesc!.substring(0, 45) + '\n' + food.foodDesc!.substring(30)
                                                          : food.foodDesc!
                                                      : '',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto', color: '#828282'.toColor(), fontSize: 14, fontWeight: FontWeight.w400),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    _boxCustom(
                                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                                      child: InkWell(
                                                        onTap: () {},
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Smile Dining",
                                                            style: TextStyle(
                                                              color: '#000000B2'.toColor(),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    _boxCustom(
                                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                                      child: InkWell(
                                                        onTap: () {},
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Contactless Dining",
                                                            style: TextStyle(
                                                              color: '#000000B2'.toColor(),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                                            child: Container(
                                              width: 1,
                                              height: 130,
                                              color: '#00000033'.toColor(),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 150,
                                            height: 160,
                                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 40.0, top: 0),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/copy.svg',
                                                        width: 25,
                                                        height: 20,
                                                      ),
                                                      SizedBox(width: 20),
                                                      PopupMenuButton<String>(
                                                        onSelected: (value) {
                                                          switch (value) {
                                                            case 'edit':
                                                              print('Edit Menu Selected');
                                                              break;
                                                            case 'copy':
                                                              print('Copy Menu Selected');
                                                              break;
                                                            case 'out_of_stock':
                                                              print('Out Of Stock Selected');
                                                              break;
                                                            case 'hide':
                                                              print('Hide Menu Selected');
                                                              break;
                                                          }
                                                        },
                                                        offset: Offset(0, 40),
                                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                          PopupMenuItem<String>(
                                                            value: 'edit',
                                                            child: Text('Edit Menu'),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            value: 'copy',
                                                            child: Text('Copy Menu'),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            value: 'out_of_stock',
                                                            child: Text('Out Of Stock'),
                                                          ),
                                                          PopupMenuItem<String>(
                                                            value: 'hide',
                                                            child: Text('Hide Menu'),
                                                          ),
                                                        ],
                                                        child: SvgPicture.asset(
                                                          'assets/moredetail.svg',
                                                          width: 25,
                                                          height: 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 60),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        food.isOutStock ? 'Out of stock' : (food.active ? 'Active' : 'Hide'),
                                                        style: TextStyle(
                                                          color: food.isOutStock
                                                              ? '#F44336'.toColor() // ใช้สีแดงถ้า out of stock
                                                              : (food.active
                                                                  ? '#000000B2'.toColor()
                                                                  : '#000000B2'.toColor()), // ใช้สีเขียวถ้า active, สีดำถ้า hide
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is DataError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No data loaded.'));
      },
    );
  }

  Widget _foodset() {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DataLoaded) {
          final uniqueCategories = state.categories
              .where((category) =>
                  category.foodCatId != null && category.foodCatId!.isNotEmpty && state.foods.any((food) => food.foodCatId == category.foodCatId))
              .toList();

          _tabController = TabController(length: uniqueCategories.length, vsync: this);

          final foodSetNames = state.sets
              .where((foodset) => foodset.foodSetName != null && foodset.foodSetName!.isNotEmpty)
              .map((foodset) => foodset.foodSetName!)
              .toSet()
              .toList();

          if (selectedFoodSet == null && foodSetNames.isNotEmpty) {
            selectedFoodSet = foodSetNames.first;
          }
          final foodNames = state.foods
              .where((foodname) => foodname.foodName != null && foodname.foodName!.isNotEmpty)
              .map((foodname) => foodname.foodName!)
              .toSet()
              .toList();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Food Set',
                style: TextStyle(fontFamily: 'Roboto', color: '#3C3C3C'.toColor(), fontSize: 32, fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.233,
                    height: MediaQuery.of(context).size.height * 0.046,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: '#FFFFFF'.toColor(),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: '#00000033'.toColor(),
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedFoodSet,
                            isExpanded: true,
                            underline: SizedBox(),
                            items: foodSetNames.map((foodSetName) {
                              return DropdownMenuItem<String>(
                                value: foodSetName,
                                child: Text(
                                  foodSetName,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: '#3C3C3C'.toColor(),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedFoodSet = newValue!;
                              });
                              print('Selected Food Set: $newValue');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      print('Edit Icon Pressed');
                    },
                    child: _boxCustom(
                      padding: EdgeInsets.all(12.0),
                      child: SvgPicture.asset('assets/edit.svg', width: 18, height: 20, color: '#000000'.toColor()),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      print('Edit Icon Pressed');
                    },
                    child: _boxCustom(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                      child: SvgPicture.asset('assets/swap.svg', width: 25, height: 20, color: '#000000'.toColor()),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      print('Edit Icon Pressed');
                      showFoodSetDialog(context);
                    },
                    child: _boxCustom(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.add_circle_rounded,
                            size: 20,
                            color: '#00000080'.toColor(),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Food Set',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: '#00000080'.toColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        } else if (state is DataError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No data loaded.'));
      },
    );
  }

  Widget _foodcategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Food Category',
          style: TextStyle(fontFamily: 'Roboto', color: '#3C3C3C'.toColor(), fontSize: 32, fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                print('Edit Icon Pressed');
              },
              child: _boxCustom(
                padding: EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/edit.svg',
                  width: 18,
                  height: 20,
                ),
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                print('Edit Icon Pressed');
              },
              child: _boxCustom(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                child: SvgPicture.asset(
                  'assets/swap.svg',
                  width: 25,
                  height: 20,
                ),
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                print('Edit Icon Pressed');
              },
              child: _boxCustom(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_circle_rounded,
                      size: 20,
                      color: '#00000080'.toColor(),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Category',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: '#00000080'.toColor(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _searchbar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.325,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: '#00000080'.toColor(),
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              'assets/search.svg',
              width: 20,
              height: 20,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: '#00000080'.toColor(),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          filled: true,
          fillColor: '#EEEEEE'.toColor(),
        ),
      ),
    );
  }

  Widget _boxCustom({
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ?? EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: '#EEEEEE'.toColor(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
