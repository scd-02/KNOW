// Import necessary packages and files
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'home.dart';
import 'package:know/components/commonWidgets/search_bar.dart' as search_bar;
import 'package:know/components/commonWidgets/floating_action_button.dart';
import 'package:know/components/commonWidgets/app_bar.dart';

// Define a stateless widget for the TravelPage
class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final List<Widget> _containersButton1 = [];
  final List<Widget> _containersButton2 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Travels'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const search_bar.SearchBar(),
          // Use a ListView.builder to handle potentially many containers
          Expanded(
            child: ListView(
              children: [
                ..._containersButton1,
                ..._containersButton2,
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: MyFloatingActionButton(
            btn1: 'Hotel Bookings',
            btn2: 'Transport Bookings',
            onButtonPressed: (String btnText) {
              setState(() {
                if (btnText == 'Hotel Bookings') {
                  _containersButton1.insert(
                      0,
                      _buildDynamicContainer(
                          btnText)); // Add to the beginning of the list
                } else if (btnText == 'Transport Bookings') {
                  _containersButton2.insert(
                      0,
                      _buildDynamicContainer(
                          btnText)); // Add to the beginning of the list
                }
              });
            },
          ),
        ),
      ),
    );
  }

  // Method to build a dynamic container based on the pressed button
  Widget _buildDynamicContainer(String btnText) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: [
            // Your existing content
            Text('Container for $btnText'),
            // Additional content with a TextField
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
