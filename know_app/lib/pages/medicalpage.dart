// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:know/components/commonWidgets/search_bar.dart' as search_bar;
import 'package:know/components/commonWidgets/floating_action_button.dart';
import 'package:know/components/commonWidgets/app_bar.dart';

// Define a stateful widget for the MedicalPage
class MedicalPage extends StatefulWidget {
  const MedicalPage({Key? key}) : super(key: key);

  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  List<Widget> _containersButton1 = [];
  List<Widget> _containersButton2 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Medicals'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          search_bar.SearchBar(),
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
        padding: EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: MyFloatingActionButton(
            btn1: 'Medicine timer',
            btn2: 'Appointments',
            onButtonPressed: (String btnText) {
              setState(() {
                if (btnText == 'Medicine timer') {
                  _containersButton1.insert(0, _buildDynamicContainer(btnText));
                } else if (btnText == 'Appointments') {
                  _containersButton2.insert(0, _buildDynamicContainer(btnText));
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
            color: Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: [
            // Your existing content
            Text('Container for $btnText'),
            // Additional content with a TextField
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
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
