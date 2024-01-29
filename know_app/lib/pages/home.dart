// Importing necessary packages and libraries
import 'package:flutter/material.dart';
import 'package:know/pages/travelpage.dart';
import 'package:know/pages/billspage.dart';
import 'package:know/pages/medicalpage.dart';
import 'package:know/templates/forms.dart';
import 'package:know/components/commonWidgets/app_bar.dart';

// Definition of a stateless widget for the HomePage
class HomePage extends StatelessWidget {
  // Constructor for the HomePage widget
  const HomePage({super.key});

  // Build method to create the widget's UI
  @override
  Widget build(BuildContext context) {
    // Scaffold widget for the overall structure of the page
    return Scaffold(
      // AppBar at the top of the page

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Know App'),
      ),

      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormsPage()),
            );
          },
          child: const Text("Form Page"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TravelPage()),
            );
          },
          child: const Text("Travel Page"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BillsPage()),
            );
          },
          child: const Text("Bills Page"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MedicalPage()),
            );
          },
          child: const Text("Medical Page"),
        ),
      ]),
    );
  }
}
