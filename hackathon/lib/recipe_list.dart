import 'package:flutter/material.dart';

import 'recipe_detail.dart';
import 'recipes.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeList({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recipes")),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                recipe.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.instruction, style: TextStyle(color: Colors.grey)),
                ],
              ),
              trailing: Icon(Icons.favorite_border),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetail(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
