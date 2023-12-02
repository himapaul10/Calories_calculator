import 'package:calories_calc/common/constants.dart';
import 'package:calories_calc/common/theme.dart';
import 'package:calories_calc/screens/meal_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      navigatorKey: navigatorKey,
      theme: appTheme,
      home: const MealPlanScreen(),
    );
  }
}
