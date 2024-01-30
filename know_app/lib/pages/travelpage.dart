// Import necessary packages and files
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'home.dart';
import 'package:know/components/commonWidgets/search_bar.dart' as search_bar;
import 'package:know/components/commonWidgets/floating_action_button.dart';
import 'package:know/components/commonWidgets/app_bar.dart';

// Define a stateless widget for the TravelPage
class TravelPage extends StatelessWidget {
  // Constructor for the TravelPage widget
  const TravelPage({super.key});

  // Build method to create the widget's UI
  @override
  Widget build(BuildContext context) {
    // Scaffold widget for the overall structure of the page
    return const Scaffold(
      // AppBar at the top of the page
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Travels'),
      ),

      backgroundColor: Colors.white,

      // Body of the page
      body: Column(
        children: [
          // Custom search bar widget
          search_bar.SearchBar(),
          // Uncomment the lines below to add more content to the body
          // Expanded(
          //   child: Center(
          //     child: Text('Search results will be displayed here!'),
          //   ),
          // ),
        ],
      ),

      // Location of the floating action button on the screen
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Configuration for the floating action button
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          // Use the MyFloatingActionButton widget
          child: MyFloatingActionButton(
            btn1: 'Hotel Bookings',
            btn2: 'Transport Bookings',
          ),
        ),
      ),
    );
  }
}
