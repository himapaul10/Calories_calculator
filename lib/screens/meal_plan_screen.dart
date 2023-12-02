// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:calories_calc/common/common.dart';
import 'package:calories_calc/common/constants.dart';
import 'package:calories_calc/models/food.dart';
import 'package:calories_calc/screens/add_meal_screen.dart';
import 'package:calories_calc/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final dbHelper = DatabaseHelper();
  List<Food> mealPlanList = [];

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    init();
    _loadMealPlan();
  }

  init() {
    selectedDate = DateTime.now();
  }

  Future _loadMealPlan() async {
    final localDate = dateFormat.format(selectedDate!);
    final result = await dbHelper.getMealPlan(localDate);
    setState(() {
      mealPlanList = result;
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
          selectedDate = value;
          _loadMealPlan();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            /// Date Picker
            AppContainer(
              child: ListTile(
                onTap: _pickDate,
                title: Text(
                  DateFormat.yMMMEd().format(selectedDate!),
                  style: boldTextStyle(color: white),
                ),
                subtitle: Text(
                  'Click to change',
                  style: secondaryTextStyle(color: whiteSmoke),
                ),
              ),
            ),
            15.height,

            /// If meal list is empty
            if (mealPlanList.isEmpty) ...{
              const Center(
                child: Text('No data to display'),
              ),
            } else ...{
              Row(
                children: [
                  AppContainer(
                    child: ListTile(
                      title: Text(
                        mealPlanList.length.toString(),
                        style: boldTextStyle(color: white),
                      ),
                      subtitle: Text(
                        'Total Food Items',
                        style: secondaryTextStyle(color: whiteSmoke),
                      ),
                    ),
                  ).expand(),
                  10.width,
                  AppContainer(
                    child: ListTile(
                      title: Text(
                        countCalories(mealPlanList).toString(),
                        style: boldTextStyle(color: white),
                      ),
                      subtitle: Text(
                        'Total Calories',
                        style: secondaryTextStyle(color: whiteSmoke),
                      ),
                    ),
                  ).expand()
                ],
              )
            },

            /// List View of Meal Items
            AnimatedListView(
              onSwipeRefresh: _loadMealPlan,
              padding: const EdgeInsets.only(top: 10),
              itemCount: mealPlanList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    mealPlanList[index].foodName,
                    style: boldTextStyle(),
                  ),
                  subtitle: Text(
                    'Calories: ${mealPlanList[index].calories}',
                    style: boldTextStyle(weight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: const HeroIcon(
                      HeroIcons.trash,
                      color: redColor,
                    ),
                    onPressed: () {
                      _deleteMealPlan(mealPlanList[index].id);
                    },
                  ),
                );
              },
            ).expand(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          // Navigate to a screen where users can add a meal plan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMealPlanScreen()),
          ).then((_) {
            // Reload meal plan after adding a new entry
            _loadMealPlan();
          });
        },
        icon: const Icon(Icons.food_bank_outlined),
        label: const Text('Add New Meal'),
      ),
    );
  }

  void _deleteMealPlan(int id) async {
    await dbHelper.deleteMealPlan(id);
    _loadMealPlan(); // Reload meal plan after deleting an entry
  }
}

class AppContainer extends StatelessWidget {
  final Widget child;
  const AppContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: radius(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A4F9C),
            Color(0xFF4396C5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
