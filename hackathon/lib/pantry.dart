import 'package:flutter/material.dart';
import 'package:hackathon/login_page.dart';

class Pantry extends StatefulWidget {
  @override
  _PantryState createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';
  final ImagePicker _picker = ImagePicker();

  void _pickImage(BuildContext context, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selected: ${image.name}')),
      );
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

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    List<String> ingredients = Provider.of<SearchProvider>(context).searchValues;

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
            Card(
              elevation: 2.0,
              child: ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Upload or Take a Picture'),
                subtitle: Text('Identify ingredients via photo'),
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Upload from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(context, ImageSource.gallery);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Take a Picture'),
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
            SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              child: ListTile(
                leading: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : Colors.blue,
                ),
                title: Text('Use your voice'),
                subtitle: Text('Dictate many ingredients at once'),
                onTap: () {
                  if (_isListening) {
                    _stopListening();
                  } else {
                    _startListening();
                  }
                },
              ),
            ),
            // GestureDetector(
            //   onTap: () {},
            //   child: Card(
            //     elevation: 2.0,
            //     child: ListTile(
            //       leading: Icon(Icons.mic, color: Colors.pink),
            //       title: Text('Use your voice'),
            //       subtitle: Text('Dictate many ingredients at once'),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16.0),
            Text(
              'The only ingredients we assume you have are salt, pepper and water',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ingredients.map((ingredient) {
                return Chip(
                  label: Text(ingredient),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () => Provider.of<SearchProvider>(context, listen: false).removeSearchValue(ingredient);
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
