import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category Logos')),
      body: Center(
        child: Text(
          'Welcome to the $category category!',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
