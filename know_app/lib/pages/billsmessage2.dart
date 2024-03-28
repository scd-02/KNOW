// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert';
// import 'package:know/components/commonWidgets/app_bar.dart';
// import 'package:telephony/telephony.dart';
// import 'bills/date_filter.dart';
// import 'bills/bank_names.dart';
// import 'bills/message_section.dart';
// import 'bills/total_amount_section.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BillsMessage extends StatefulWidget {
//   const BillsMessage({Key? key}) : super(key: key);

//   @override
//   State<BillsMessage> createState() => _BillsMessageState();
// }

// class _BillsMessageState extends State<BillsMessage> {
//   final Telephony telephony = Telephony.instance;
//   List<String?> _creditedMessages = [];
//   List<String?> _debitedMessages = [];
//   DateTime? _startDate;
//   DateTime? _endDate;
//   double totalCreditedAmount = 0.0;
//   double totalDebitedAmount = 0.0;

//   late SharedPreferences _prefs;
//   final Map<String, dynamic> bankTemplates = {};
//   Set<String> promotionalMessageList = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadBankTemplates(); // Load bank templates from local storage when the widget is initialized
//     _loadPromotionalMessageList(); // Load promotional message list from local storage when the widget is initialized
//   }

//   Future<void> _loadBankTemplates() async {
//     _prefs = await SharedPreferences.getInstance();
//     // Load bank templates from local storage
//     final String? bankTemplatesJson = _prefs.getString('bank_templates');
//     if (bankTemplatesJson != null) {
//       setState(() {
//         // bankTemplates
//         //     .clear(); // Clear the map before loading from local storage
//         bankTemplates.addAll(json.decode(bankTemplatesJson));
//       });
//     }
//   }

//   Future<void> _saveBankTemplates() async {
//     // Save bank templates to local storage
//     await _prefs.setString('bank_templates', json.encode(bankTemplates));
//   }

//   // promotional Message

//   Future<void> _loadPromotionalMessageList() async {
//     _prefs = await SharedPreferences.getInstance();
//     // Load promotional message list from local storage
//     final String? promotionalMessageJson =
//         _prefs.getString('promotional_message');
//     if (promotionalMessageJson != null) {
//       setState(() {
//         // promotionalMessageList
//         //     .clear(); // Clear the map before loading from local storage
//         promotionalMessageList.addAll(json.decode(promotionalMessageJson));
//       });
//     }
//   }

//   Future<void> _savePromotionalMessageList() async {
//     // Save bank templates to local storage
//     await _prefs.setString(
//         'promotional_message', json.encode(promotionalMessageList));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: CustomAppBar(title: 'Bills Messages'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DateFilter(
//               onStartDateSelected: (date) => _startDate = date,
//               onEndDateSelected: (date) => _endDate = date,
//             ),
//             const SizedBox(height: 10),
//             MessageSection(title: 'Credited', messages: _creditedMessages),
//             const SizedBox(height: 10),
//             MessageSection(title: 'Debited', messages: _debitedMessages),
//             const SizedBox(height: 10),
//             TotalAmountSection(
//               totalCreditedAmount: totalCreditedAmount,
//               totalDebitedAmount: totalDebitedAmount,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _fetchData,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }

//   Future<void> _fetchData() async {
//     final permission = await telephony.requestPhoneAndSmsPermissions;
//     if (permission == true && _startDate != null && _endDate != null) {
//       final data = await _getDataFromMessages();
//       _processData(data);
//     }
//   }

//   Future<Map<String, dynamic>> _getDataFromMessages() async {
//     final Map<String, dynamic> data = {
//       'creditedMessages': [],
//       'debitedMessages': [],
//       'totalCreditedAmount': 0.0,
//       'totalDebitedAmount': 0.0,
//     };

//     try {
//       final String endDateString = (_endDate!.add(const Duration(days: 1)))
//           .millisecondsSinceEpoch
//           .toString();
//       final String startDateString =
//           _startDate!.millisecondsSinceEpoch.toString();

//       Set<String> userBankNameList = {};

//       List<SmsMessage> userMessageHeader = await telephony.getInboxSms(
//         columns: [SmsColumn.ADDRESS],
//         filter: SmsFilter.where(SmsColumn.ADDRESS).like('%-%'),
//       );

//       for (SmsMessage messageHeader in userMessageHeader) {
//         String? address = messageHeader.address;
//         if (address != null) {
//           int lastIndex = address.lastIndexOf('-') + 1;
//           String substring = address.substring(lastIndex);
//           if (bankNameList.contains(substring)) {
//             userBankNameList.add(substring);
//           }
//         }
//       }

//       List<String?> creditedMessages = [];
//       List<String?> debitedMessages = [];
//       double creditedAmount = 0.0;
//       double debitedAmount = 0.0;

//       for (var bankName in userBankNameList) {
//         bankName = bankName.toLowerCase();
//         List<SmsMessage> bankMessages = await telephony.getInboxSms(
//           columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
//           filter: SmsFilter.where(SmsColumn.ADDRESS)
//               .like('%$bankName')
//               .and(SmsColumn.DATE)
//               .greaterThanOrEqualTo(startDateString)
//               .and(SmsColumn.DATE)
//               .lessThanOrEqualTo(endDateString),
//         );

//         for (var messageObj in bankMessages) {
//           String body = (messageObj.body ?? '').replaceAll('\n', ' ');
//           String header = messageObj.address ?? '';
//           if (!promotionalMessageList.contains(body.toLowerCase()) &&
//               (body.toLowerCase().contains('credit') ||
//                   body.toLowerCase().contains('debit') ||
//                   body.toLowerCase().contains('credited') ||
//                   body.toLowerCase().contains('sent') ||
//                   body.toLowerCase().contains('inr') ||
//                   body.toLowerCase().contains('rs') ||
//                   body.toLowerCase().contains('received'))) {
//             creditedMessages.add(body);
//             creditedAmount += _extractAmountFromBody(header,body);
//           }
//         }
//       }

//       data['creditedMessages'] = creditedMessages;
//       data['debitedMessages'] = debitedMessages;
//       data['totalCreditedAmount'] = creditedAmount;
//       data['totalDebitedAmount'] = debitedAmount;
//     } catch (e) {
//       print('Error in _getDataFromMessages: $e');
//     }

//     return data;
//   }

//   double _extractAmountFromBody(String header,String body) {
//     // Implement logic to extract amount from message body
//     // For now, let's assume it returns a random amount
//     return 100.0; // Example: returning 100.0 as a placeholder
//   }

//   void _processData(Map<String, dynamic> data) {
//     setState(() {
//       _creditedMessages = data['creditedMessages'];
//       _debitedMessages = data['debitedMessages'];
//       totalCreditedAmount = data['totalCreditedAmount'];
//       totalDebitedAmount = data['totalDebitedAmount'];
//     });
//   }
// }
