import 'package:flutter/material.dart';
import 'recipes.dart';

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  RecipeDetail({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  recipe.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: Icon(Icons.more_vert, color: Colors.white),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white.withOpacity(0.9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          recipe.ingredientCount,
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star_border, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("${recipe.cookingTime} mins", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Tags", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // Add tags dynamically if available
                  Text("No tags available"),
                  SizedBox(height: 20),
                  Text("Ingredients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Column(
                    children: recipe.ingredients.map((ingredient) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ingredient),
                          Icon(Icons.check_circle, color: Colors.green),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text("Nutrition Facts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Calories: ${recipe.nutritionFacts}"),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Open the recipe source
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      ),
                      child: Text("View Full Recipe"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
