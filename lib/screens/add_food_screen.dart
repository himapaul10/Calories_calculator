// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:calories_calc/common/common.dart';
import 'package:calories_calc/common/constants.dart';
import 'package:calories_calc/models/food.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AddFoodScreen extends StatefulWidget {
  final int totalCalories;
  final List<Food> selectedFood;

  const AddFoodScreen({
    Key? key,
    required this.totalCalories,
    required this.selectedFood,
  }) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final List<Food> selectedList = [];

  @override
  void initState() {
    super.initState();

    selectedList.addAll(widget.selectedFood);
    setState(() {});
  }

  bool checkCalories() {
    final total = countCalories(selectedList);
    return total < widget.totalCalories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Items'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () => finish(context, selectedList),
        label: const Text('Done'),
      ),
      body: AnimatedListView(
        itemCount: Food.getAllItems().length,
        itemBuilder: (context, index) {
          final food = Food.getAllItems()[index];

          return ListTile(
            onTap: () {
              if (!selectedList.contains(food)) {
                if (checkCalories()) {
                  selectedList.add(food);
                } else {
                  toastLong(
                      'You can\'t add food items more than ${widget.totalCalories} calories');
                }
              } else {
                selectedList.remove(food);
              }

              setState(() {});
            },
            title: Text(food.foodName),
            subtitle: Text('Calories: ${food.calories}'),
            trailing: selectedList.contains(food)
                ? const Icon(
                    Icons.check,
                    color: primaryColor,
                  )
                : null,
          );
        },
      ),
    );
  }
}
