// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Food {
  final int id;
  final String foodName;
  final int calories;

  Food({
    this.id = 0,
    required this.foodName,
    required this.calories,
  });

  Food copyWith({
    int? id,
    String? foodName,
    int? calories,
  }) {
    return Food(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'foodName': foodName,
      'calories': calories,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] as int,
      foodName: map['foodName'] as String,
      calories: map['calories'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Food.fromJson(String source) =>
      Food.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Food(id: $id, foodName: $foodName, calories: $calories)';

  @override
  bool operator ==(covariant Food other) {
    if (identical(this, other)) return true;

    return other.foodName == foodName && other.calories == calories;
  }

  @override
  int get hashCode => id.hashCode ^ foodName.hashCode ^ calories.hashCode;

  static List<Food> getAllItems() {
    List<Map<String, dynamic>> foodItems = [
      {'foodName': 'Apple', 'calories': 95},
      {'foodName': 'Banana', 'calories': 105},
      {'foodName': 'Orange', 'calories': 62},
      {'foodName': 'Grapes', 'calories': 62},
      {'foodName': 'Strawberries', 'calories': 49},
      {'foodName': 'Chicken Breast (cooked)', 'calories': 165},
      {'foodName': 'Salmon (cooked)', 'calories': 206},
      {'foodName': 'Brown Rice (cooked)', 'calories': 112},
      {'foodName': 'Quinoa (cooked)', 'calories': 120},
      {'foodName': 'Whole Wheat Bread', 'calories': 69},
      {'foodName': 'Avocado', 'calories': 234},
      {'foodName': 'Almonds', 'calories': 164},
      {'foodName': 'Greek Yogurt', 'calories': 59},
      {'foodName': 'Eggs', 'calories': 78},
      {'foodName': 'Spinach (raw)', 'calories': 7},
      {'foodName': 'Broccoli (cooked)', 'calories': 55},
      {'foodName': 'Carrots (raw)', 'calories': 52},
      {'foodName': 'Cheese (Cheddar)', 'calories': 113},
      {'foodName': 'Tofu (firm)', 'calories': 94},
      {'foodName': 'Oatmeal (cooked)', 'calories': 143},
    ];

    return foodItems
        .map((e) => Food(foodName: e['foodName'], calories: e['calories']))
        .toList();
  }
}
