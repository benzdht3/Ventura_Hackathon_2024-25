import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;

import 'auth_provider.dart';
import 'login_page.dart';
import 'search_provider.dart';
import 'user_page.dart';

class Pantry extends StatefulWidget {
  const Pantry({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _PantryState createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';
  final ImagePicker _picker = ImagePicker();

  void _pickImage(BuildContext context, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Image selected: ${image.name}')),
      );
      await detectIngredientByImage(image);
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
      });
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    if (_spokenText.isNotEmpty) {
      List<String> ingredients = _spokenText.split(',').map((s) => s.trim()).toList();
      Provider.of<SearchProvider>(context, listen: false).addMultipleSearchValues(ingredients);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingredients added: $_spokenText')),
      );
      _spokenText = '';
    }
  }

  Future<void> detectIngredientByImage(XFile image) async {
    const String apiUrl = 'http://35.226.32.22:3000/api/v1/detect_ingredient/detect';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image_path',
        image.path,
        filename: image.name,
      ),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        var responseBody = await http.Response.fromStream(response);
        var decodedBody = utf8.decode(responseBody.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody)['ingredients'];
        
        setState(() => Provider.of<SearchProvider>(context, listen: false).addSearchValues(jsonResponse));
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final TextEditingController _ingredientController = TextEditingController();
    List<String> ingredients = Provider.of<SearchProvider>(context).searchValues;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            if (authProvider.isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserPage()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
        title: const Text('Pantry'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: () => Provider.of<SearchProvider>(context, listen: false).sortIngredients(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                hintText: 'add/remove/paste ingredients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() => Provider.of<SearchProvider>(context, listen: false).updateSearchValues(value));
                  
                  _ingredientController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an ingredient')),
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              child: ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Upload or Take a Picture'),
                subtitle: const Text('Identify ingredients via photo'),
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Upload from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(context, ImageSource.gallery);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Take a Picture'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(context, ImageSource.camera);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              child: ListTile(
                leading: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : Colors.blue,
                ),
                title: const Text('Use your voice'),
                subtitle: const Text('Dictate many ingredients at once'),
                onTap: () {
                  if (_isListening) {
                    _stopListening();
                  } else {
                    _startListening();
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'The only ingredients we assume you have are salt, pepper and water',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ingredients.map((ingredient) {
                return Chip(
                  label: Text(ingredient),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => Provider.of<SearchProvider>(context, listen: false).removeSearchValue(ingredient)
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
