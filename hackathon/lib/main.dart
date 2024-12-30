import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'favorites.dart';
import 'menu.dart';
import 'pantry.dart';
import 'shopping_list.dart';
import 'search_provider.dart';


const supabaseUrl = '';
const supabaseKey = String.fromEnvironment('');
Future<void> main() async {
  // await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(
    ChangeNotifierProvider(
      create: (context) => SearchProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChefMateAI',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Recipe> recipes = [
    Recipe(
      title: "Scrambled Eggs",
      imageUrl: "https://example.com/scrambled_eggs.jpg",
      source: "charlotteslivelykitchen.com",
      ingredientCount: "You have all the ingredients",
      ingredients: ["2 eggs", "60 ml full fat milk", "1 tsp butter", "salt and pepper"],
      nutritionFacts: "198 kcal",
      cookingTime: 8,
    ),
  ];
  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      Pantry(),
      Menu(),
      Favorites(),
      ShoppingList()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Pantry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping List',
          ),
        ],
      ),
    );
  }
}
