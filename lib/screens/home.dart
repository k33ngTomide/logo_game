import 'package:flutter/material.dart';
import 'category_screen.dart'; // Import category screen

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {'name': 'Sports', 'icon': Icons.sports_soccer},
    {'name': 'Tech', 'icon': Icons.computer},
    {'name': 'Food', 'icon': Icons.fastfood},
    {'name': 'Cars', 'icon': Icons.directions_car},
    {'name': 'Fashion', 'icon': Icons.shopping_bag},
    {'name': 'Movies', 'icon': Icons.movie},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logo Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a Category',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(category: category['name']),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category['icon'], size: 50, color: Colors.blue),
                          const SizedBox(height: 10),
                          Text(category['name'], style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
