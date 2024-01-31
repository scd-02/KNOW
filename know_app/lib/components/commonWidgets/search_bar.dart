// Importing necessary packages and libraries
import 'package:flutter/material.dart';

// Definition of a stateless widget for a custom search bar
class SearchBar extends StatelessWidget {
  // Constructor for the SearchBar widget
  const SearchBar({super.key});

  // Build method to create the widget's UI
  // @override
  // Widget build(BuildContext context) {
  //   // Container widget for the search bar with padding
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     // Text field for user input
  //     child: const TextField(
  //       decoration: InputDecoration(
  //         labelText: 'Search',
  //         border: OutlineInputBorder(),
  //         prefixIcon: Icon(Icons.search),
  //       ),
  //     ),
  //   );
  // }

  // Build method to create the widget's UI
  @override
  Widget build(BuildContext context) {
    // Container widget for the search bar with padding
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(15),
          hintText: 'Search',
          hintStyle: const TextStyle(color: Color(0x0ffDDDADA), fontSize: 14),
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
