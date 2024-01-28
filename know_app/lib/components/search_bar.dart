// Importing necessary packages and libraries
import 'package:flutter/material.dart';

// Definition of a stateless widget for a custom search bar
class SearchBar extends StatelessWidget {
  // Constructor for the SearchBar widget
  const SearchBar({super.key});

  // Build method to create the widget's UI
  @override
  Widget build(BuildContext context) {
    // Container widget for the search bar with padding
    return Container(
      padding: const EdgeInsets.all(16),
      // Text field for user input
      child: const TextField(
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          // Icon to indicate search functionality
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
