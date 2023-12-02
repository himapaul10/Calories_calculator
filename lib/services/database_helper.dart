// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:calories_calc/models/food.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static late Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'calories.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Insert a meal plan entry
  Future<int> insertMealPlan(Map<String, dynamic> row) async {
    Database dbClient = await db;
    return await dbClient.insert('MealPlan', row);
  }

  // Retrieve meal plan entries for a specific date
  Future<List<Food>> getMealPlan(String date) async {
    Database dbClient = await db;
    final data =
        await dbClient.query('MealPlan', where: 'date = ?', whereArgs: [date]);
    return data.map((e) => Food.fromMap(e)).toList();
  }

  // Update a meal plan entry
  Future<int> updateMealPlan(Map<String, dynamic> row) async {
    Database dbClient = await db;
    return await dbClient
        .update('MealPlan', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  // Delete a meal plan entry
  Future<int> deleteMealPlan(int id) async {
    Database dbClient = await db;
    return await dbClient.delete('MealPlan', where: 'id = ?', whereArgs: [id]);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE MealPlan(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      foodName TEXT,
      calories INTEGER,
      date TEXT
    )
    ''');
  }
}
