class Recipe {
  final String title;
  final String imageUrl;
  final String instruction;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.instruction,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      imageUrl: json['imageUrl'],
      instruction: json['instruction'],
    );
  }
}
