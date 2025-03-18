import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logo_screen.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<dynamic> _logos = [];
  Set<int> _answeredLogos = {}; // Store answered logos

  @override
  void initState() {
    super.initState();
    _loadAnsweredLogos();
    
    _loadLogos();

  }

  Future<void> _loadLogos() async {
    final String jsonString = await rootBundle.loadString('lib/assets/logos.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    print('Available categories: ${jsonData.keys}');
    print('Selected category: ${widget.category}');
    print('Logos found: ${jsonData[widget.category]}');

    setState(() {
      _logos = jsonData[widget.category] ?? [];
    });
  }


  Future<void> _loadAnsweredLogos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _answeredLogos = prefs.getKeys().map((key) => int.tryParse(key)).whereType<int>().toSet();
    });
  }

  void _markAsAnswered(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(index.toString(), true);
    setState(() {
      _answeredLogos.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Logos', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _logos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Adjust for better spacing
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _logos.length,
          itemBuilder: (context, index) {
            bool isAnswered = _answeredLogos.contains(index);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogoScreen(
                      category: widget.category,
                      logoIndex: index,
                      logos: _logos,
                      onAnswered: _markAsAnswered,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isAnswered ? Colors.green[200] : Colors.white,
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: 'logo_$index',
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (isAnswered)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle, color: Colors.green[800], size: 24),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
