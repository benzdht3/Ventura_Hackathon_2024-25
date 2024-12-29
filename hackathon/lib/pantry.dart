import 'package:flutter/material.dart';
import 'package:hackathon/login_page.dart';

class Pantry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        title: Text('Pantry'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'add/remove/paste ingredients',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 2.0,
                child: ListTile(
                  leading: Icon(Icons.mic, color: Colors.pink),
                  title: Text('Use your voice'),
                  subtitle: Text('Dictate many ingredients at once'),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'The only ingredients we assume you have are salt, pepper and water',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            PantryCategory(title: 'Pantry Essentials', items: ['butter', 'egg', 'garlic', 'milk', 'onion', 'sugar', 'flour', 'olive oil', 'garlic powder', 'white rice']),
            PantryCategory(title: 'Vegetables & Greens', items: []),
          ],
        ),
      ),
    );
  }
}

class PantryCategory extends StatelessWidget {
  final String title;
  final List<String> items;

  PantryCategory({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        items.isEmpty
            ? Text('No items added')
            : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: items.map((item) => Chip(label: Text(item))).toList(),
              ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
