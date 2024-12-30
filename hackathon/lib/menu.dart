import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'search_provider.dart';
import 'login_page.dart';
import 'recipes.dart';
import 'recipe_list.dart'

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<String> searchValues = Provider.of<SearchProvider>(context).searchValues;
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        title: Text('Menu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Enter ingredients seperately by ','',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                final searchValues = value.split(',').map((e) => e.trim()).toList();
                Provider.of<SearchProvider>(context, listen: false).updateSearchValues(value);

                fetchSuggestedRecipes(searchValues);
              },
            ),
            // SizedBox(height: 16.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ChoiceChipWidget(label: 'Key Ingredient(s)'),
            //     ChoiceChipWidget(label: 'Meal type'),
            //     ChoiceChipWidget(label: 'Missing one ingredient'),
            //   ],
            // ),
            SizedBox(height: 32.0),
            child: recipes.isEmpty
              ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Add your ingredients to get started',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('add ingredients'),
                  ),
                ],
              ),
            ),
            : RecipeList(recipes: recipes),
          ],
        ),
      ),
    );
  }

  Future<void> fetchSuggesstRecipes(List<String> ingredients) async {
    const String apiUrl = 'https://domain/api/v1/recipes/suggest';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ingredients': ingredients}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          recipes = data.map((json) => Recipe.fromJson(json)).toList();
        });
        print('Suggested recipes: $data');
      } else {
        print('Failed to fetch recipes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}

// class ChoiceChipWidget extends StatelessWidget {
//   final String label;

//   ChoiceChipWidget({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return ChoiceChip(
//       label: Text(label),
//       selected: false,
//       onSelected: (bool selected) {},
//     );
//   }
// }
