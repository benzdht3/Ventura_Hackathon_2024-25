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
                          recipe.instruction,
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
            )
          ],
        ),
      ),
    );
  }
}
