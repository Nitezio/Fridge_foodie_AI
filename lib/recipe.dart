// C:\Users\DELL\StudioProjects\Test5\lib\recipe.dart
class Recipe {
  final String id;
  final String title;
  final String description;
  final String cuisine;
  final int servings;
  final String totalTime;
  final List<String> ingredients;
  final String mealType;
  final String? imageUrl;
  bool isSaved;
  final List<String>? instructions;
  final double? calories; // Add calories
  final double? protein;       // Add protein (in grams)
  final double? fat;           // Add fat (in grams)
  final double? carbs;         // Add carbohydrates (in grams)

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cuisine,
    required this.servings,
    required this.totalTime,
    required this.ingredients,
    required this.mealType,
    this.imageUrl,
    this.isSaved = false,
    this.instructions,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
  });
}
