import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:know/components/commonWidgets/search_bar.dart' as search_bar;
import 'package:know/components/commonWidgets/floating_action_button.dart';
import 'package:know/components/commonWidgets/app_bar.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class BillsPage extends StatefulWidget {
  const BillsPage({Key? key}) : super(key: key);

  @override
  _BillsPageState createState() => _BillsPageState();
}

class Template {
  final String bankName;
  final String regexPattern;
  final String propertyMap;

  Template(
      {required this.bankName,
      required this.regexPattern,
      required this.propertyMap});

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      bankName: json['bankName'],
      regexPattern: json['template'][0]['regexPattern'],
      propertyMap: json['template'][0]['propertyMap'],
    );
  }
}

class _BillsPageState extends State<BillsPage> {
  List<Template> templates = [];

  Future<void> fetchTemplates() async {
    final response =
        await http.get(Uri.parse('http://192.168.51.70:8000/bank/all'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];
      setState(() {
        templates =
            data.map((template) => Template.fromJson(template)).toList();
      });
    } else {
      throw Exception('Failed to load templates');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTemplates();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Templates'),
      ),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(templates[index].bankName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Regex Pattern: ${templates[index].regexPattern}'),
                Text('Property Map: ${templates[index].propertyMap}'),
              ],
            ),
          );
        },
      ),
    );

    // String balance = "5000";
    // List<Widget> _containersButton1 = [];
    // List<Widget> _containersButton2 = [];

    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //     appBar: const PreferredSize(
    //       preferredSize: Size.fromHeight(kToolbarHeight),
    //       child: CustomAppBar(title: 'Bills & Payments'),
    //     ),
    //     backgroundColor: Colors.white,
    //     body: Stack(
    //       children: [
    //         Column(
    //           children: [
    //             const search_bar.SearchBar(),
    //             Expanded(
    //               child: ListView(
    //                 children: [
    //                   ..._containersButton1,
    //                   ..._containersButton2,
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //         Positioned(
    //           top: kToolbarHeight + 40, // Adjust the top value as needed
    //           left: 16.0,
    //           right: 16.0,
    //           child: Container(
    //             padding: EdgeInsets.all(16.0),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.circular(15),
    //               boxShadow: [
    //                 BoxShadow(
    //                   color: Color(0xff1D1617).withOpacity(0.11),
    //                   blurRadius: 40,
    //                   spreadRadius: 0.0,
    //                 ),
    //               ],
    //             ),
    //             child: RichText(
    //               text: TextSpan(
    //                 text: 'Available Balance: ',
    //                 style: const TextStyle(
    //                   color: Colors.black,
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //                 children: [
    //                   TextSpan(
    //                     text: '$balance/-',
    //                     style: const TextStyle(
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.normal,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //     floatingActionButton: Padding(
    //       padding: const EdgeInsets.only(left: 15.0),
    //       child: Align(
    //         alignment: Alignment.bottomLeft,
    //         child: MyFloatingActionButton(
    //           btn1: 'Update Balance',
    //           btn2: 'Add Expense',
    //           onButtonPressed: (String btnText) {
    //             setState(() {
    //               if (btnText == 'Update Balance') {
    //                 _containersButton1.add(_buildDynamicContainer(btnText));
    //               } else if (btnText == 'Add Expense') {
    //                 _containersButton2.add(_buildDynamicContainer(btnText));
    //               }
    //             });
    //           },
    //         ),
    //       ),
    //     ),
    //   );
  }

  // Widget _buildDynamicContainer(String btnText) {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Color(0xff1D1617).withOpacity(0.11),
  //           blurRadius: 40,
  //           spreadRadius: 0.0,
  //         ),
  //       ],
  //     ),
  //     child: Container(
  //       margin: EdgeInsets.all(16.0),
  //       padding: EdgeInsets.all(16.0),
  //       color: Colors.white,
  //       child: Column(
  //         children: [
  //           Text('Container for $btnText'),
  //           TextField(
  //             decoration: InputDecoration(
  //               fillColor: Colors.white,
  //               contentPadding: EdgeInsets.all(15),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(15),
  //                 borderSide: BorderSide.none,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
