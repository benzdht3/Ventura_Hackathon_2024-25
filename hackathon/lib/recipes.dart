class Recipe {
  final String title;
  final String imageUrl;
  final String source;
  final String ingredientCount;
  final List<String> ingredients;
  final String nutritionFacts;
  final int cookingTime;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.ingredientCount,
    required this.ingredients,
    required this.nutritionFacts,
    required this.cookingTime,
  });
}
