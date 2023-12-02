import 'package:calories_calc/common/common.dart';
import 'package:calories_calc/common/constants.dart';
import 'package:calories_calc/models/food.dart';
import 'package:calories_calc/screens/add_food_screen.dart';
import 'package:calories_calc/screens/meal_plan_screen.dart';
import 'package:calories_calc/services/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class AddMealPlanScreen extends StatefulWidget {
  const AddMealPlanScreen({super.key});

  @override
  _AddMealPlanScreenState createState() => _AddMealPlanScreenState();
}

class _AddMealPlanScreenState extends State<AddMealPlanScreen> {
  final dbHelper = DatabaseHelper();
  final TextEditingController caloriesController =
      TextEditingController(text: '1000'); // default value;

  DateTime? date;

  List<Food> foodItems = [];

  @override
  void initState() {
    super.initState();

    date = DateTime.now();
  }

  Future _loadMealPlan() async {
    final localDate = dateFormat.format(date!);
    final result = await dbHelper.getMealPlan(localDate);
    setState(() {
      foodItems = result;
    });

    return 1.seconds.delay;
  }

  _pickDate() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          date = value;

          _loadMealPlan();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal Plan'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                child: ListTile(
                  onTap: _pickDate,
                  title: Text(
                    DateFormat.yMMMEd().format(date!),
                    style: boldTextStyle(color: white),
                  ),
                  subtitle: Text(
                    'Click to change',
                    style: secondaryTextStyle(color: whiteSmoke),
                  ),
                ),
              ),
              20.height,
              TextField(
                controller: caloriesController,
                decoration:
                    inputDecoration(context, labelText: 'Total Calories'),
                keyboardType: TextInputType.number,
              ),
              if (foodItems.isEmpty) ...{
                CupertinoButton(
                  child: const Text('Choose Meals'),
                  onPressed: () {
                    AddFoodScreen(
                      selectedFood: const [],
                      totalCalories: caloriesController.text.toInt(),
                    ).launch(context).then((value) {
                      foodItems = value;
                      setState(() {});
                    });
                  },
                ).center().paddingSymmetric(vertical: 10),
              } else ...{
                10.height,
                CupertinoButton(
                  child: const Text('Add More Meals'),
                  onPressed: () {
                    AddFoodScreen(
                      selectedFood: foodItems,
                      totalCalories: caloriesController.text.toInt(),
                    ).launch(context).then((value) {
                      if (value != null) {
                        foodItems = value;
                        setState(() {});
                      }
                    });
                  },
                ).center(),
                AnimatedListView(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final food = foodItems[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: primaryColor.withOpacity(0.2),
                        child: Text(
                          (index + 1).toString(),
                          style: boldTextStyle(color: primaryColor),
                        ),
                      ),
                      title: Text(food.foodName),
                      subtitle: Text('Calories: ${food.calories}'),
                    );
                  },
                ).expand(),
              },
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: _addMeal,
        label: const Text('Save'),
      ),
    );
  }

  _addMeal() async {
    final sDate = dateFormat.format(date!);

    await dbHelper.getMealPlan(sDate).then((existingFoods) {
      for (var food in foodItems) {
        if (!existingFoods.any((e) => e.foodName == food.foodName)) {
          dbHelper.insertMealPlan({
            'foodName': food.foodName,
            'calories': food.calories,
            'date': sDate,
          });
        }
      }

      finish(context);
    });
  }
}
